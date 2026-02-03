// Onboarding repository interface
// Defines the contract for onboarding data operations
abstract class OnboardingRepository {
  Future<bool> isOnboardingCompleted();
  Future<void> completeOnboarding();
}
