import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
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
  // ============== External Dependencies ==============

  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Connectivity
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());

  // ============== Core ==============

  // Network Info
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfo(getIt<Connectivity>()),
  );

  // Initialize Dio Client
  DioClient.init();

  // ============== Data Sources ==============

  // Onboarding Data Source
  getIt.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSourceImpl(getIt<SharedPreferences>()),
  );

  // Notes Data Sources
  getIt.registerLazySingleton<NoteLocalDataSource>(
    () => NoteLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<NoteRemoteDataSource>(
    () => NoteRemoteDataSourceImpl(),
  );

  // ============== Repositories ==============

  // Onboarding Repository
  getIt.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(getIt<OnboardingLocalDataSource>()),
  );

  // Notes Repository
  getIt.registerLazySingleton<NoteRepository>(
    () => NoteRepositoryImpl(
      localDataSource: getIt<NoteLocalDataSource>(),
      remoteDataSource: getIt<NoteRemoteDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  // ============== Use Cases ==============

  // Onboarding Use Cases
  getIt.registerLazySingleton(
    () => CheckOnboardingStatus(getIt<OnboardingRepository>()),
  );
  getIt.registerLazySingleton(
    () => CompleteOnboarding(getIt<OnboardingRepository>()),
  );

  // Notes Use Cases
  getIt.registerLazySingleton(() => GetNotes(getIt<NoteRepository>()));
  getIt.registerLazySingleton(() => CreateNote(getIt<NoteRepository>()));
  getIt.registerLazySingleton(() => UpdateNote(getIt<NoteRepository>()));
  getIt.registerLazySingleton(() => DeleteNote(getIt<NoteRepository>()));

  // ============== BLoCs ==============

  // Onboarding BLoC
  getIt.registerFactory(
    () => OnboardingBloc(
      checkOnboardingStatus: getIt<CheckOnboardingStatus>(),
      completeOnboarding: getIt<CompleteOnboarding>(),
    ),
  );

  // Notes BLoCs
  getIt.registerFactory(
    () =>
        NotesBloc(getNotes: getIt<GetNotes>(), deleteNote: getIt<DeleteNote>()),
  );
  getIt.registerFactory(
    () => NoteFormBloc(
      createNote: getIt<CreateNote>(),
      updateNote: getIt<UpdateNote>(),
    ),
  );
}

// Reset dependencies (useful for testing)
Future<void> resetDependencies() async {
  await getIt.reset();
}
