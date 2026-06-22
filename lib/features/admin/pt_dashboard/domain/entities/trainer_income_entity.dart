// =============================================================================
// FILE: lib/features/admin/pt_dashboard/domain/entities/trainer_income_entity.dart
// LAYER: Domain — Entity
//
// One row = one COMPLETED + PAID session and what the trainer earned from it
// (sessionPrice * commissionPercentage / 100). See GET /api/trainer/income.
// =============================================================================

class TrainerIncomeSessionEntity {
  /// "PT_SESSION" (commission on a delivered session), "CLASS" (commission on
  /// a delivered class), or "SALARY" (a salary expense paid to this trainer).
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

  const TrainerIncomeSessionEntity({
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

  bool get isSalary => source == 'SALARY';
  bool get isClass => source == 'CLASS';
}

class TrainerIncomeSummaryEntity {
  final int totalSessions;
  final double totalEarning;
  final List<TrainerIncomeSessionEntity> sessions;

  const TrainerIncomeSummaryEntity({
    required this.totalSessions,
    required this.totalEarning,
    required this.sessions,
  });

  static const empty = TrainerIncomeSummaryEntity(
    totalSessions: 0,
    totalEarning: 0,
    sessions: [],
  );
}
