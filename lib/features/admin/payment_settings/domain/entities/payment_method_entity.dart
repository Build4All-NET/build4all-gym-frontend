// lib/features/admin/payment_settings/domain/entities/payment_method_entity.dart

/// Represents one payment gateway as seen by the admin dashboard.
///
/// Loaded by GET /api/admin/payment-settings and used to build
/// the payment methods config list in AdminPaymentSettingsScreen.
class PaymentMethodEntity {
  /// Gateway code: "STRIPE" | "PAYPAL" | "MPGS" | "CASH"
  final String methodName;

  /// Human-readable label, e.g. "Stripe", "PayPal", "Card (MPGS)"
  final String displayName;

  /// Whether the platform (super-admin) has enabled this method at all.
  final bool platformEnabled;

  /// Whether THIS gym has turned the method on.
  final bool projectEnabled;

  /// Whether this gym has saved at least one config for the method.
  final bool configured;

  /// Schema: field definitions the admin needs to fill.
  /// Keys are field names (e.g. "publishableKey"), values are metadata maps.
  final Map<String, dynamic> configSchema;

  /// Current masked config values already saved.
  /// Secret fields show "***xxxx" (last 4 chars visible).
  final Map<String, dynamic> configValues;

  const PaymentMethodEntity({
    required this.methodName,
    required this.displayName,
    required this.platformEnabled,
    required this.projectEnabled,
    required this.configured,
    required this.configSchema,
    required this.configValues,
  });

  /// True if the method is ready to use (enabled and configured).
  bool get isActive => projectEnabled && configured;

  /// Icon per gateway.
  String get iconAsset {
    switch (methodName.toUpperCase()) {
      case 'STRIPE':  return 'assets/icons/stripe.png';
      case 'PAYPAL':  return 'assets/icons/paypal.png';
      case 'MPGS':    return 'assets/icons/mpgs.png';
      case 'CASH':    return 'assets/icons/cash.png';
      default:        return 'assets/icons/payment.png';
    }
  }
}
