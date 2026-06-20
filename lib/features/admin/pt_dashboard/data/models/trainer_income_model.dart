// =============================================================================
// FILE: lib/features/admin/pt_dashboard/data/models/trainer_income_model.dart
// LAYER: Data — Model
//
// Maps the JSON returned by GET /api/trainer/income.
// =============================================================================

import '../../domain/entities/trainer_income_entity.dart';

class TrainerIncomeSessionModel {
  final String source;
  final int? ptSessionId;
  final int? expenseId;
  final int? classSessionId;
  final DateTime startTime;
  final int? userId;
  final String? memberName;
  final String sourceName;
  final double sessionPrice;
  final double? commissionPercentage;
  final double trainerEarning;

  const TrainerIncomeSessionModel({
    required this.source,
    this.ptSessionId,
    this.expenseId,
    this.classSessionId,
    required this.startTime,
    this.userId,
    this.memberName,
    required this.sourceName,
    required this.sessionPrice,
    this.commissionPercentage,
    required this.trainerEarning,
  });

  factory TrainerIncomeSessionModel.fromJson(Map<String, dynamic> json) {
    return TrainerIncomeSessionModel(
      source: json['source'] as String? ?? 'PT_SESSION',
      ptSessionId: (json['ptSessionId'] as num?)?.toInt(),
      expenseId: (json['expenseId'] as num?)?.toInt(),
      classSessionId: (json['classSessionId'] as num?)?.toInt(),
      startTime: DateTime.parse(json['startTime'] as String),
      userId: (json['userId'] as num?)?.toInt(),
      memberName: json['memberName'] as String?,
      sourceName: json['sourceName'] as String? ?? '',
      sessionPrice: (json['sessionPrice'] as num?)?.toDouble() ?? 0.0,
      commissionPercentage: (json['commissionPercentage'] as num?)?.toDouble(),
      trainerEarning: (json['trainerEarning'] as num?)?.toDouble() ?? 0.0,
    );
  }

  TrainerIncomeSessionEntity toEntity() {
    return TrainerIncomeSessionEntity(
      source: source,
      ptSessionId: ptSessionId,
      expenseId: expenseId,
      classSessionId: classSessionId,
      startTime: startTime,
      userId: userId,
      memberName: memberName,
      sourceName: sourceName,
      sessionPrice: sessionPrice,
      commissionPercentage: commissionPercentage,
      trainerEarning: trainerEarning,
    );
  }
}

class TrainerIncomeSummaryModel {
  final int totalSessions;
  final double totalEarning;
  final List<TrainerIncomeSessionModel> sessions;

  const TrainerIncomeSummaryModel({
    required this.totalSessions,
    required this.totalEarning,
    required this.sessions,
  });

  factory TrainerIncomeSummaryModel.fromJson(Map<String, dynamic> json) {
    final list = (json['sessions'] as List<dynamic>? ?? [])
        .map((e) => TrainerIncomeSessionModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return TrainerIncomeSummaryModel(
      totalSessions: (json['totalSessions'] as num?)?.toInt() ?? 0,
      totalEarning: (json['totalEarning'] as num?)?.toDouble() ?? 0.0,
      sessions: list,
    );
  }

  TrainerIncomeSummaryEntity toEntity() {
    return TrainerIncomeSummaryEntity(
      totalSessions: totalSessions,
      totalEarning: totalEarning,
      sessions: sessions.map((s) => s.toEntity()).toList(),
    );
  }
}
