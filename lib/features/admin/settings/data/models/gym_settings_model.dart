// ─────────────────────────────────────────────────────────────────────────────
// lib/features/admin/settings/data/models/gym_settings_model.dart
//
// PURPOSE:
//   Data-layer model that knows how to serialize/deserialize to/from JSON.
//   The domain entity (SettingsBusinessRulesEntity) knows nothing about JSON —
//   this model bridges the gap between HTTP responses and the domain layer.
//
// JSON SHAPE (matches the backend GymSettingsDto):
//   {
//     "allowClassWithoutMembership": true,
//     "requireMembershipForClass":   false,
//     "allowMembershipWithoutClass": true,
//     "allowBothIndependently":      true
//   }
// ─────────────────────────────────────────────────────────────────────────────

import '../../domain/entities/settings_business_rules_entity.dart';

class GymSettingsModel {
  final bool allowClassWithoutMembership;
  final bool requireMembershipForClass;
  final bool allowMembershipWithoutClass;
  final bool allowBothIndependently;
  final bool allowPtBookingWithoutMembership;
  final int? planRefundWindowHours;
  final int? classRefundWindowHours;
  final int? ptPackageRefundWindowHours;

  const GymSettingsModel({
    required this.allowClassWithoutMembership,
    required this.requireMembershipForClass,
    required this.allowMembershipWithoutClass,
    required this.allowBothIndependently,
    required this.allowPtBookingWithoutMembership,
    this.planRefundWindowHours,
    this.classRefundWindowHours,
    this.ptPackageRefundWindowHours,
  });

  // ── JSON deserialization ────────────────────────────────────────────────────

  /// Parses the JSON map returned by GET /api/admin/settings.
  /// Uses ?? defaults in case the backend omits a field (defensive coding).
  factory GymSettingsModel.fromJson(Map<String, dynamic> json) =>
      GymSettingsModel(
        allowClassWithoutMembership:
        json['allowClassWithoutMembership'] as bool? ?? true,
        requireMembershipForClass:
        json['requireMembershipForClass'] as bool? ?? false,
        allowMembershipWithoutClass:
        json['allowMembershipWithoutClass'] as bool? ?? true,
        allowBothIndependently:
        json['allowBothIndependently'] as bool? ?? true,
        allowPtBookingWithoutMembership:
        json['allowPtBookingWithoutMembership'] as bool? ?? false,
        planRefundWindowHours: json['planRefundWindowHours'] as int?,
        classRefundWindowHours: json['classRefundWindowHours'] as int?,
        ptPackageRefundWindowHours: json['ptPackageRefundWindowHours'] as int?,
      );

  // ── JSON serialization ──────────────────────────────────────────────────────

  /// Converts the model to the JSON body expected by PUT /api/admin/settings.
  Map<String, dynamic> toJson() => {
    'allowClassWithoutMembership': allowClassWithoutMembership,
    'requireMembershipForClass': requireMembershipForClass,
    'allowMembershipWithoutClass': allowMembershipWithoutClass,
    'allowBothIndependently': allowBothIndependently,
    'allowPtBookingWithoutMembership': allowPtBookingWithoutMembership,
    'planRefundWindowHours': planRefundWindowHours,
    'classRefundWindowHours': classRefundWindowHours,
    'ptPackageRefundWindowHours': ptPackageRefundWindowHours,
  };

  // ── Mapping helpers ─────────────────────────────────────────────────────────

  /// Converts this data model → domain entity (for the repository to return).
  SettingsBusinessRulesEntity toEntity() => SettingsBusinessRulesEntity(
    allowClassWithoutMembership: allowClassWithoutMembership,
    requireMembershipForClass: requireMembershipForClass,
    allowMembershipWithoutClass: allowMembershipWithoutClass,
    allowBothIndependently: allowBothIndependently,
    allowPtBookingWithoutMembership: allowPtBookingWithoutMembership,
    planRefundWindowHours: planRefundWindowHours,
    classRefundWindowHours: classRefundWindowHours,
    ptPackageRefundWindowHours: ptPackageRefundWindowHours,
  );

  /// Converts a domain entity → data model (for the repository to serialize before PUT).
  factory GymSettingsModel.fromEntity(SettingsBusinessRulesEntity entity) =>
      GymSettingsModel(
        allowClassWithoutMembership: entity.allowClassWithoutMembership,
        requireMembershipForClass: entity.requireMembershipForClass,
        allowMembershipWithoutClass: entity.allowMembershipWithoutClass,
        allowBothIndependently: entity.allowBothIndependently,
        allowPtBookingWithoutMembership: entity.allowPtBookingWithoutMembership,
        planRefundWindowHours: entity.planRefundWindowHours,
        classRefundWindowHours: entity.classRefundWindowHours,
        ptPackageRefundWindowHours: entity.ptPackageRefundWindowHours,
      );
}
