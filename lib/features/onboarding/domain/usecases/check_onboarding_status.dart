import '../repositories/onboarding_repository.dart';

// Use case to check if onboarding is completed
class CheckOnboardingStatus {
  final OnboardingRepository repository;

  CheckOnboardingStatus(this.repository);

  Future<bool> call() async {
    return await repository.isOnboardingCompleted();
  }
}
