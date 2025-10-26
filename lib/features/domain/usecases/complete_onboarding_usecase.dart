import '../repository/onboarding_repository.dart';

class CompleteOnboardingUseCase {
  final OnboardingRepository repository;
  CompleteOnboardingUseCase(this.repository);

  Future<void> call(String userId) async {
    await repository.completeOnboarding(userId);
  }
}
