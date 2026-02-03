import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../helpers/logger.dart';
import '../../../location/domain/usecases/get_saved_location.dart';
import '../../domain/entities/alarm_entity.dart';
import '../../domain/usecases/add_alarm.dart';
import '../../domain/usecases/delete_alarm.dart';
import '../../domain/usecases/get_alarms.dart';
import '../../domain/usecases/toggle_alarm.dart';
import 'alarm_event.dart';
import 'alarm_state.dart';

class AlarmBloc extends Bloc<AlarmEvent, AlarmState> {
  final GetAlarms getAlarms;
  final AddAlarm addAlarm;
  final DeleteAlarm deleteAlarm;
  final ToggleAlarm toggleAlarm;
  final GetSavedLocation getSavedLocation;

  AlarmBloc({
    required this.getAlarms,
    required this.addAlarm,
    required this.deleteAlarm,
    required this.toggleAlarm,
    required this.getSavedLocation,
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
    try {
      AppLogger.info('🔄 BLoC: Loading alarms...');

      // Only show loading spinner on first load, not on refresh
      final shouldShowLoading = state is AlarmInitial || state is AlarmError;
      if (shouldShowLoading) {
        emit(AlarmLoading());
      }

      // Get alarms
      final alarmsResult = await getAlarms(const NoParams());

      // Handle failure
      if (alarmsResult.isLeft()) {
        final failure = alarmsResult.fold((l) => l, (r) => null);
        AppLogger.error('❌ BLoC: Failed to load alarms');
        if (!emit.isDone) {
          emit(AlarmError(failure?.message ?? 'Failed to load alarms'));
        }
        return;
      }

      // Extract alarms
      final alarms = alarmsResult.fold((l) => <AlarmEntity>[], (r) => r);

      AppLogger.info('✅ BLoC: Loaded ${alarms.length} alarms');
      for (var alarm in alarms) {
        AppLogger.debug(
          '   - ${alarm.time} (ID: ${alarm.id}, Active: ${alarm.isActive})',
        );
      }

      // Get location
      final locationResult = await getSavedLocation(const NoParams());

      String userLocation = 'Add your location';
      if (locationResult.isRight()) {
        final locationEntity = locationResult.fold((l) => null, (r) => r);
        if (locationEntity != null) {
          userLocation = locationEntity.address;
          AppLogger.info('📍 BLoC: Location: $userLocation');
        }
      }

      // Emit final state
      if (!emit.isDone) {
        emit(AlarmLoaded(alarms: alarms, userLocation: userLocation));
        AppLogger.info('✅ BLoC: State emitted with ${alarms.length} alarms');
      }
    } catch (e, stackTrace) {
      AppLogger.error('❌ BLoC: Exception - $e');
      AppLogger.error('StackTrace: $stackTrace');

      if (!emit.isDone) {
        emit(AlarmError('Failed to load alarms: $e'));
      }
    }
  }

  Future<void> _onLoadUserLocation(
    LoadUserLocationEvent event,
    Emitter<AlarmState> emit,
  ) async {
    if (state is! AlarmLoaded) return;

    try {
      final currentState = state as AlarmLoaded;
      final result = await getSavedLocation(const NoParams());

      if (!emit.isDone) {
        final userLocation = result.isRight()
            ? result.fold((l) => null, (r) => r)?.address ?? 'Add your location'
            : 'Add your location';

        emit(currentState.copyWith(userLocation: userLocation));
      }
    } catch (e) {
      AppLogger.error('❌ BLoC: Exception loading location - $e');
    }
  }

  Future<void> _onAddAlarm(
    AddAlarmEvent event,
    Emitter<AlarmState> emit,
  ) async {
    try {
      final formattedTime =
          '${event.time.hour.toString().padLeft(2, '0')}:${event.time.minute.toString().padLeft(2, '0')}';
      AppLogger.info('➕ BLoC: Adding alarm at $formattedTime');

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
        id: DateTime.now().millisecondsSinceEpoch,
        alarmDateTime: alarmDateTime,
        isActive: true,
      );

      AppLogger.info('📝 BLoC: Saving alarm ID: ${newAlarm.id}');

      final result = await addAlarm(AddAlarmParams(alarm: newAlarm));

      if (result.isLeft()) {
        final failure = result.fold((l) => l, (r) => null);
        AppLogger.error('❌ BLoC: Failed to add alarm - ${failure?.message}');
        if (!emit.isDone) {
          emit(AlarmError(failure?.message ?? 'Failed to add alarm'));
        }
        return;
      }

      AppLogger.info('✅ BLoC: Alarm added successfully');

      // Small delay to ensure Hive write completes
      await Future.delayed(const Duration(milliseconds: 150));

      // Reload alarms
      add(LoadAlarmsEvent());
    } catch (e, stackTrace) {
      AppLogger.error('❌ BLoC: Exception adding alarm - $e');
      AppLogger.error('StackTrace: $stackTrace');

      if (!emit.isDone) {
        emit(AlarmError('Failed to add alarm: $e'));
      }
    }
  }

  Future<void> _onDeleteAlarm(
    DeleteAlarmEvent event,
    Emitter<AlarmState> emit,
  ) async {
    try {
      AppLogger.info('🗑️ BLoC: Deleting alarm ${event.id}');

      // Get the alarm time before deleting (for snackbar)
      String? deletedTime;
      if (state is AlarmLoaded) {
        final currentState = state as AlarmLoaded;
        try {
          final alarm = currentState.alarms.firstWhere((a) => a.id == event.id);
          deletedTime = alarm.time;
          AppLogger.info('🗑️ BLoC: Found alarm to delete: ${alarm.time}');
        } catch (e) {
          AppLogger.warning(
            '⚠️ BLoC: Alarm ${event.id} not found in current state',
          );
        }
      }

      // Delete from repository
      final result = await deleteAlarm(DeleteAlarmParams(id: event.id));

      if (result.isLeft()) {
        final failure = result.fold((l) => l, (r) => null);
        AppLogger.error('❌ BLoC: Failed to delete - ${failure?.message}');
        if (!emit.isDone) {
          emit(AlarmError(failure?.message ?? 'Failed to delete alarm'));
        }
        return;
      }

      AppLogger.info('✅ BLoC: Alarm deleted from storage');

      // Emit deleted state for snackbar
      if (deletedTime != null && !emit.isDone) {
        emit(AlarmDeleted(deletedTime));
        await Future.delayed(const Duration(milliseconds: 300));
      }

      // Small delay to ensure Hive write completes
      await Future.delayed(const Duration(milliseconds: 150));

      // Reload alarms
      AppLogger.info('🔄 BLoC: Reloading alarms after delete...');
      add(LoadAlarmsEvent());
    } catch (e, stackTrace) {
      AppLogger.error('❌ BLoC: Exception deleting alarm - $e');
      AppLogger.error('StackTrace: $stackTrace');

      if (!emit.isDone) {
        emit(AlarmError('Failed to delete alarm: $e'));
      }
    }
  }

  Future<void> _onToggleAlarm(
    ToggleAlarmEvent event,
    Emitter<AlarmState> emit,
  ) async {
    try {
      AppLogger.info(
        '🔄 BLoC: Toggling alarm ${event.id} to ${event.isActive}',
      );

      // Perform toggle
      final result = await toggleAlarm(
        ToggleAlarmParams(id: event.id, isActive: event.isActive),
      );

      if (result.isLeft()) {
        final failure = result.fold((l) => l, (r) => null);
        AppLogger.error('❌ BLoC: Failed to toggle - ${failure?.message}');
        if (!emit.isDone) {
          emit(AlarmError(failure?.message ?? 'Failed to toggle alarm'));
        }
        return;
      }

      AppLogger.info('✅ BLoC: Alarm toggled in storage');

      // Small delay to ensure Hive write completes
      await Future.delayed(const Duration(milliseconds: 150));

      // Reload alarms
      AppLogger.info('🔄 BLoC: Reloading alarms after toggle...');
      add(LoadAlarmsEvent());
    } catch (e, stackTrace) {
      AppLogger.error('❌ BLoC: Exception toggling alarm - $e');
      AppLogger.error('StackTrace: $stackTrace');

      if (!emit.isDone) {
        emit(AlarmError('Failed to toggle alarm: $e'));
      }
    }
  }
}
