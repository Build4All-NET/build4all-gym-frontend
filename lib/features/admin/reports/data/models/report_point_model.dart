import '../../domain/entities/report_point_entity.dart';

class ReportPointModel {
  final String label;
  final double value;

  const ReportPointModel({required this.label, required this.value});

  factory ReportPointModel.fromJson(Map<String, dynamic> json) {
    return ReportPointModel(
      label: json['label'] as String? ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
    );
  }

  ReportPointEntity toEntity() => ReportPointEntity(label: label, value: value);
}
