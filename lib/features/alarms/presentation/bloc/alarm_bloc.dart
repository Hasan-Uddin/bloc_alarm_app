import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../helpers/logger.dart';
import '../../domain/entities/alarm_entity.dart';
import '../../domain/usecases/add_alarm.dart';
import '../../domain/usecases/delete_alarm.dart';
import '../../domain/usecases/get_alarms.dart';
import '../../domain/usecases/get_user_location.dart';
import '../../domain/usecases/toggle_alarm.dart';
import 'alarm_event.dart';
import 'alarm_state.dart';

class AlarmBloc extends Bloc<AlarmEvent, AlarmState> {
  final GetAlarms getAlarms;
  final AddAlarm addAlarm;
  final DeleteAlarm deleteAlarm;
  final ToggleAlarm toggleAlarm;
  final GetUserLocation getUserLocation;

  AlarmBloc({
    required this.getAlarms,
    required this.addAlarm,
    required this.deleteAlarm,
    required this.toggleAlarm,
    required this.getUserLocation,
  }) : super(AlarmInitial()) {
    on<LoadAlarmsEvent>(_onLoadAlarms);
    on<LoadUserLocationEvent>(_onLoadUserLocation);
    on<AddAlarmEvent>(_onAddAlarm);
    on<DeleteAlarmEvent>(_onDeleteAlarm);
    on<ToggleAlarmEvent>(_onToggleAlarm);
  }

  Future<void> _onLoadAlarms(
    LoadAlarmsEvent event,
    Emitter<AlarmState> emit,
  ) async {
    AppLogger.info('BLoC: Loading alarms');
    emit(AlarmLoading());

    final result = await getAlarms(const NoParams());

    result.fold(
      (failure) {
        AppLogger.error('BLoC: Failed to load alarms');
        emit(AlarmError(failure.message));
      },
      (alarms) {
        AppLogger.info('BLoC: ${alarms.length} alarms loaded');

        // Also load user location
        _loadLocationForState(emit, alarms);
      },
    );
  }

  Future<void> _loadLocationForState(
    Emitter<AlarmState> emit,
    List<AlarmEntity> alarms,
  ) async {
    final locationResult = await getUserLocation(const NoParams());

    locationResult.fold(
      (failure) {
        emit(AlarmLoaded(alarms: alarms, userLocation: 'Add your location'));
      },
      (location) {
        emit(
          AlarmLoaded(
            alarms: alarms,
            userLocation: location ?? 'Add your location',
          ),
        );
      },
    );
  }

  Future<void> _onLoadUserLocation(
    LoadUserLocationEvent event,
    Emitter<AlarmState> emit,
  ) async {
    final result = await getUserLocation(const NoParams());

    if (state is AlarmLoaded) {
      final currentState = state as AlarmLoaded;

      result.fold(
        (failure) {
          emit(currentState.copyWith(userLocation: 'Add your location'));
        },
        (location) {
          emit(
            currentState.copyWith(
              userLocation: location ?? 'Add your location',
            ),
          );
        },
      );
    }
  }

  Future<void> _onAddAlarm(
    AddAlarmEvent event,
    Emitter<AlarmState> emit,
  ) async {
    AppLogger.info('BLoC: Adding alarm at ${event.time.format}');

    final now = DateTime.now();
    var alarmDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      event.time.hour,
      event.time.minute,
    );

    if (alarmDateTime.isBefore(now)) {
      alarmDateTime = alarmDateTime.add(const Duration(days: 1));
    }

    final newAlarm = AlarmEntity(
      id: DateTime.now().millisecondsSinceEpoch % 10000000,
      alarmDateTime: alarmDateTime,
    );

    final result = await addAlarm(AddAlarmParams(alarm: newAlarm));

    result.fold(
      (failure) {
        AppLogger.error('BLoC: Failed to add alarm');
        emit(AlarmError(failure.message));
      },
      (_) {
        AppLogger.info('BLoC: Alarm added successfully');
        // Reload alarms
        add(LoadAlarmsEvent());
      },
    );
  }

  Future<void> _onDeleteAlarm(
    DeleteAlarmEvent event,
    Emitter<AlarmState> emit,
  ) async {
    AppLogger.info('BLoC: Deleting alarm ${event.id}');

    String? deletedTime;
    if (state is AlarmLoaded) {
      final currentState = state as AlarmLoaded;
      final alarm = currentState.alarms.firstWhere((a) => a.id == event.id);
      deletedTime = alarm.time;
    }

    final result = await deleteAlarm(DeleteAlarmParams(id: event.id));

    result.fold(
      (failure) {
        AppLogger.error('BLoC: Failed to delete alarm');
        emit(AlarmError(failure.message));
      },
      (_) {
        AppLogger.info('BLoC: Alarm deleted successfully');
        if (deletedTime != null) {
          emit(AlarmDeleted(deletedTime));
        }
        // Reload alarms
        add(LoadAlarmsEvent());
      },
    );
  }

  Future<void> _onToggleAlarm(
    ToggleAlarmEvent event,
    Emitter<AlarmState> emit,
  ) async {
    AppLogger.info('BLoC: Toggling alarm ${event.id} to ${event.isActive}');

    final result = await toggleAlarm(
      ToggleAlarmParams(id: event.id, isActive: event.isActive),
    );

    result.fold(
      (failure) {
        AppLogger.error('BLoC: Failed to toggle alarm');
        emit(AlarmError(failure.message));
      },
      (_) {
        AppLogger.info('BLoC: Alarm toggled successfully');
        // Reload alarms
        add(LoadAlarmsEvent());
      },
    );
  }
}
