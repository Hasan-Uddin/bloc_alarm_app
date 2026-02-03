// Location imports
import 'package:alarm_app/core/storage/local_storage.dart';
import 'package:alarm_app/features/location/data/datasources/location_local_datasource.dart';
import 'package:alarm_app/features/location/data/models/location_model.dart';
import 'package:alarm_app/features/location/data/repositories/location_repository_impl.dart';
import 'package:alarm_app/features/location/domain/repositories/location_repository.dart';
import 'package:alarm_app/features/location/domain/usecases/delete_location.dart';
import 'package:alarm_app/features/location/domain/usecases/get_current_location.dart';
import 'package:alarm_app/features/location/domain/usecases/get_saved_location.dart';
import 'package:alarm_app/features/location/domain/usecases/save_location.dart';
import 'package:alarm_app/features/location/presentation/bloc/location_bloc.dart';
import 'package:alarm_app/helpers/logger.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../networks/dio_client.dart';
import '../../networks/network_info.dart';

// Onboarding imports
import '../../features/onboarding/data/datasources/onboarding_local_datasource.dart';
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart';
import '../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../../features/onboarding/domain/usecases/check_onboarding_status.dart';
import '../../features/onboarding/domain/usecases/complete_onboarding.dart';
import '../../features/onboarding/presentation/bloc/onboarding_bloc.dart';

// Notes imports
import '../../features/notes/data/datasources/note_local_datasource.dart';
import '../../features/notes/data/datasources/note_remote_datasource.dart';
import '../../features/notes/data/repositories/note_repository_impl.dart';
import '../../features/notes/domain/repositories/note_repository.dart';
import '../../features/notes/domain/usecases/create_note.dart';
import '../../features/notes/domain/usecases/delete_note.dart';
import '../../features/notes/domain/usecases/get_notes.dart';
import '../../features/notes/domain/usecases/update_note.dart';
import '../../features/notes/presentation/bloc/note_form_bloc.dart';
import '../../features/notes/presentation/bloc/notes_bloc.dart';

// Dependency injection container
// Uses GetIt for service locator pattern
final getIt = GetIt.instance;

// Initialize all dependencies
// This should be called before running the app
Future<void> initializeDependencies() async {
  // ============== Local Storage (Hive + SharedPreferences) ==============

  // Open Location Hive Box
  await LocalStorage.openBox<LocationModel>(
    LocationLocalDataSourceImpl.LOCATION_BOX,
  );
  AppLogger.info('Location box opened');

  // ============== External Dependencies ==============

  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  getIt.registerLazySingleton<Connectivity>(() => Connectivity());

  // ============== Core ==============

  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfo(getIt<Connectivity>()),
  );

  DioClient.init();

  // ============== Data Sources ==============

  // Onboarding
  getIt.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSourceImpl(getIt<SharedPreferences>()),
  );

  // Notes
  getIt.registerLazySingleton<NoteLocalDataSource>(
    () => NoteLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<NoteRemoteDataSource>(
    () => NoteRemoteDataSourceImpl(),
  );

  // Location
  getIt.registerLazySingleton<LocationLocalDataSource>(
    () => LocationLocalDataSourceImpl(),
  );

  // ============== Repositories ==============

  getIt.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(getIt<OnboardingLocalDataSource>()),
  );

  getIt.registerLazySingleton<NoteRepository>(
    () => NoteRepositoryImpl(
      localDataSource: getIt<NoteLocalDataSource>(),
      remoteDataSource: getIt<NoteRemoteDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  getIt.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(localDataSource: getIt()),
  );

  // ============== Use Cases ==============

  // Onboarding
  getIt.registerLazySingleton(
    () => CheckOnboardingStatus(getIt<OnboardingRepository>()),
  );
  getIt.registerLazySingleton(
    () => CompleteOnboarding(getIt<OnboardingRepository>()),
  );

  // Location
  getIt.registerLazySingleton(() => GetCurrentLocation(getIt()));
  getIt.registerLazySingleton(() => GetSavedLocation(getIt()));
  getIt.registerLazySingleton(() => SaveLocation(getIt()));
  getIt.registerLazySingleton(() => DeleteLocation(getIt()));

  // Notes
  getIt.registerLazySingleton(() => GetNotes(getIt<NoteRepository>()));
  getIt.registerLazySingleton(() => CreateNote(getIt<NoteRepository>()));
  getIt.registerLazySingleton(() => UpdateNote(getIt<NoteRepository>()));
  getIt.registerLazySingleton(() => DeleteNote(getIt<NoteRepository>()));

  // ============== BLoCs ==============

  getIt.registerFactory(
    () => OnboardingBloc(
      checkOnboardingStatus: getIt(),
      completeOnboarding: getIt(),
    ),
  );

  getIt.registerFactory(
    () => LocationBloc(
      getCurrentLocation: getIt(),
      getSavedLocation: getIt(),
      saveLocation: getIt(),
      deleteLocation: getIt(),
    ),
  );

  getIt.registerFactory(
    () => NotesBloc(getNotes: getIt(), deleteNote: getIt()),
  );

  getIt.registerFactory(
    () => NoteFormBloc(createNote: getIt(), updateNote: getIt()),
  );

  AppLogger.info('Dependency injection setup completed');
}

// Reset dependencies (useful for testing)
Future<void> resetDependencies() async {
  await getIt.reset();
}
