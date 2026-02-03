import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_datasource.dart';

// Implementation of onboarding repository
class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl(this.localDataSource);

  @override
  Future<bool> isOnboardingCompleted() async {
    return await localDataSource.isOnboardingCompleted();
  }

  @override
  Future<void> completeOnboarding() async {
    return await localDataSource.setOnboardingCompleted();
  }
}
