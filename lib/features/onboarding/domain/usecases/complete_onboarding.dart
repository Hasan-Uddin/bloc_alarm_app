import '../repositories/onboarding_repository.dart';

// Use case to mark onboarding as complete
class CompleteOnboarding {
  final OnboardingRepository repository;

  CompleteOnboarding(this.repository);

  Future<void> call() async {
    return await repository.completeOnboarding();
  }
}
