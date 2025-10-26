import '../entities/onboarding_state_entity.dart';

abstract class OnboardingRepository {
  Future<OnboardingStateEntity> getOnboardingState(String userId);
  Future<void> completeOnboarding(String userId);
}
