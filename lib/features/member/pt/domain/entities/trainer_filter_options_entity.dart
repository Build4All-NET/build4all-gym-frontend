class TrainerFilterOptionsEntity {
  // Specialties from backend — excludes الكل and المفضلة (hardcoded client-side)
  final List<String> specialties;

  const TrainerFilterOptionsEntity({
    required this.specialties,
  });
}