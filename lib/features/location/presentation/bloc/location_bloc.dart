import 'package:alarm_app/core/usecases/usecase.dart';
import 'package:alarm_app/features/location/domain/usecases/delete_location.dart';
import 'package:alarm_app/features/location/domain/usecases/get_current_location.dart';
import 'package:alarm_app/features/location/domain/usecases/get_saved_location.dart';
import 'package:alarm_app/features/location/domain/usecases/save_location.dart';
import 'package:alarm_app/features/location/presentation/bloc/location_event.dart';
import 'package:alarm_app/features/location/presentation/bloc/location_state.dart';
import 'package:alarm_app/helpers/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final GetCurrentLocation getCurrentLocation;
  final GetSavedLocation getSavedLocation;
  final SaveLocation saveLocation;
  final DeleteLocation deleteLocation;

  LocationBloc({
    required this.getCurrentLocation,
    required this.getSavedLocation,
    required this.saveLocation,
    required this.deleteLocation,
  }) : super(const LocationInitial()) {
    on<GetCurrentLocationEvent>(_onGetCurrentLocation);
    on<CheckSavedLocationEvent>(_onCheckSavedLocation);
    on<SkipLocationEvent>(_onSkipLocation);
    on<DeleteLocationEvent>(_onDeleteLocation);
    on<RetryLocationEvent>(_onRetryLocation); // ✅ Handler added
  }

  Future<void> _onGetCurrentLocation(
    GetCurrentLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    AppLogger.info('BLoC: Getting current location');
    emit(const LocationLoading('Getting your location...'));

    final result = await getCurrentLocation(NoParams());

    result.fold(
      (failure) {
        AppLogger.error('BLoC: Failed to get location - ${failure.message}');
        emit(LocationError(failure.message));
      },
      (location) async {
        AppLogger.info('BLoC: Location obtained, saving...');

        final saveResult = await saveLocation(
          SaveLocationParams(location: location),
        );

        saveResult.fold(
          (failure) {
            AppLogger.error('BLoC: Failed to save location');
            emit(
              LocationError(
                'Location obtained but failed to save: ${failure.message}',
              ),
            );
          },
          (_) {
            AppLogger.info('BLoC: Location saved successfully');
            emit(LocationLoaded(location));
          },
        );
      },
    );
  }

  Future<void> _onCheckSavedLocation(
    CheckSavedLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    AppLogger.info('BLoC: Checking saved location');
    emit(const LocationLoading('Checking saved location...'));

    final result = await getSavedLocation(NoParams());

    result.fold(
      (failure) {
        AppLogger.info('BLoC: No saved location found');
        emit(const LocationInitial());
      },
      (location) {
        if (location != null) {
          AppLogger.info('BLoC: Saved location found - ${location.address}');
          emit(LocationLoaded(location, isFromCache: true));
        } else {
          AppLogger.info('BLoC: No saved location');
          emit(const LocationInitial());
        }
      },
    );
  }

  Future<void> _onSkipLocation(
    SkipLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    AppLogger.info('BLoC: Location skipped by user');
    emit(const LocationSkipped());
  }

  Future<void> _onDeleteLocation(
    DeleteLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    AppLogger.info('BLoC: Deleting location');
    emit(const LocationDeleting());

    final result = await deleteLocation(NoParams());

    result.fold(
      (failure) {
        AppLogger.error('BLoC: Failed to delete location - ${failure.message}');
        emit(LocationError('Failed to delete location: ${failure.message}'));
      },
      (_) {
        AppLogger.info('BLoC: Location deleted successfully');
        emit(const LocationDeleted());
        emit(const LocationInitial());
      },
    );
  }

  // Retry location handler
  // Triggered when user clicks retry after an error
  Future<void> _onRetryLocation(
    RetryLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    AppLogger.info('BLoC: Retrying location fetch');
    // Simply trigger the get current location event again
    add(const GetCurrentLocationEvent());
  }
}
