// ─────────────────────────────────────────────────────────────────────────────
// lib/features/admin/settings/domain/entities/settings_business_rules_entity.dart
//
// PURPOSE:
//   Pure Dart domain entity for the 4 gym business-rule toggles.
//   This class has ZERO dependency on Flutter, Dio, or JSON — it lives only
//   in the domain layer and is passed between use-cases and the BLoC/Cubit.
//
// WHY IMMUTABLE:
//   Cubits emit new state objects rather than mutating existing ones.
//   copyWith() lets us change one field while preserving the rest,
//   identical to how ThemeState and other cubits in this project work.
// ─────────────────────────────────────────────────────────────────────────────

class SettingsBusinessRulesEntity {
  /// Users can join classes without buying a membership plan.
  final bool allowClassWithoutMembership;

  /// An active membership is required before a class subscription is allowed.
  final bool requireMembershipForClass;

  /// Members can purchase plans without enrolling in any class.
  final bool allowMembershipWithoutClass;

  /// Memberships and classes can be purchased as separate, independent transactions.
  final bool allowBothIndependently;

  /// Members can book a PT package without an active membership plan.
  final bool allowPtBookingWithoutMembership;

  /// Hours after plan purchase during which a member may request a refund.
  /// null = no time restriction, 0 = refunds not allowed for plans.
  final int? planRefundWindowHours;

  /// Hours after class booking during which a member may request a refund.
  /// null = no time restriction, 0 = refunds not allowed for classes.
  final int? classRefundWindowHours;

  /// Hours after PT package purchase during which a member may request a refund.
  /// null = no time restriction, 0 = refunds not allowed for PT packages.
  final int? ptPackageRefundWindowHours;

  const SettingsBusinessRulesEntity({
    required this.allowClassWithoutMembership,
    required this.requireMembershipForClass,
    required this.allowMembershipWithoutClass,
    required this.allowBothIndependently,
    required this.allowPtBookingWithoutMembership,
    this.planRefundWindowHours,
    this.classRefundWindowHours,
    this.ptPackageRefundWindowHours,
  });

  /// Default factory — mirrors the defaults defined in the backend GymSettings entity.
  factory SettingsBusinessRulesEntity.defaults() => const SettingsBusinessRulesEntity(
    allowClassWithoutMembership: true,
    requireMembershipForClass: false,
    allowMembershipWithoutClass: true,
    allowBothIndependently: true,
    allowPtBookingWithoutMembership: false,
  );

  /// Returns a new entity with only the provided fields changed.
  // Sentinel used to clear a nullable int field via copyWith.
  static const int _clearWindow = -999;

  SettingsBusinessRulesEntity copyWith({
    bool? allowClassWithoutMembership,
    bool? requireMembershipForClass,
    bool? allowMembershipWithoutClass,
    bool? allowBothIndependently,
    bool? allowPtBookingWithoutMembership,
    int? planRefundWindowHours = _clearWindow,
    int? classRefundWindowHours = _clearWindow,
    int? ptPackageRefundWindowHours = _clearWindow,
  }) {
    return SettingsBusinessRulesEntity(
      allowClassWithoutMembership:
      allowClassWithoutMembership ?? this.allowClassWithoutMembership,
      requireMembershipForClass:
      requireMembershipForClass ?? this.requireMembershipForClass,
      allowMembershipWithoutClass:
      allowMembershipWithoutClass ?? this.allowMembershipWithoutClass,
      allowBothIndependently:
      allowBothIndependently ?? this.allowBothIndependently,
      allowPtBookingWithoutMembership:
      allowPtBookingWithoutMembership ?? this.allowPtBookingWithoutMembership,
      planRefundWindowHours: planRefundWindowHours == _clearWindow
          ? this.planRefundWindowHours
          : planRefundWindowHours,
      classRefundWindowHours: classRefundWindowHours == _clearWindow
          ? this.classRefundWindowHours
          : classRefundWindowHours,
      ptPackageRefundWindowHours: ptPackageRefundWindowHours == _clearWindow
          ? this.ptPackageRefundWindowHours
          : ptPackageRefundWindowHours,
    );
  }
}
