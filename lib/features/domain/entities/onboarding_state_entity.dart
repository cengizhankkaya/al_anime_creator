class OnboardingStateEntity {
  final bool isCompleted;
  final DateTime? completedAt;

  const OnboardingStateEntity({
    required this.isCompleted,
    this.completedAt,
  });
}
