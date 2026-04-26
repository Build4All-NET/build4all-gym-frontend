class BodyProgressModel {
  final double? currentWeight;
  final double? previousWeight;
  final double? weightDifference;
  final double? bmi;
  final double? bodyFatPercentage;

  const BodyProgressModel({
    this.currentWeight,
    this.previousWeight,
    this.weightDifference,
    this.bmi,
    this.bodyFatPercentage,
  });

  factory BodyProgressModel.fromJson(Map<String, dynamic> json) {
    return BodyProgressModel(
      currentWeight: (json['currentWeight'] as num?)?.toDouble(),
      previousWeight: (json['previousWeight'] as num?)?.toDouble(),
      weightDifference: (json['weightDifference'] as num?)?.toDouble(),
      bmi: (json['bmi'] as num?)?.toDouble(),
      bodyFatPercentage: (json['bodyFatPercentage'] as num?)?.toDouble(),
    );
  }
}