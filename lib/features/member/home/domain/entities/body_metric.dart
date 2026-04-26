
class BodyMetric {
  // Logged weight value
  final double weight;

  // Date and time when the weight was recorded
  final String recordedAt;

  // Creates a clean BodyMetric entity
  const BodyMetric({
    required this.weight,
    required this.recordedAt,
  });
}