// This model represents the response returned after logging a weight entry.
//
// Example backend JSON:
// {
//   "weight": 72.5,
//   "recordedAt": "2024-07-15T10:30:00Z"
// }
//
// After parsing with fromJson, the app can use "object":
// bodyMetric.weight
// bodyMetric.recordedAt

class BodyMetricModel {
  // Logged weight value
  final double weight;

  // Date and time when the weight was recorded (ISO string)
  final String recordedAt;

  // Creates a typed BodyMetricModel object
  const BodyMetricModel({
    required this.weight,
    required this.recordedAt,
  });

  // Converts backend JSON into a BodyMetricModel object
  factory BodyMetricModel.fromJson(Map<String, dynamic> json) {
    return BodyMetricModel(
      // Safely convert numeric value to double, fallback to 0.0 if null
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,

      // Safely read the datetime string, fallback to empty string if null
      recordedAt: json['recordedAt']?.toString() ?? '',
    );
  }
}