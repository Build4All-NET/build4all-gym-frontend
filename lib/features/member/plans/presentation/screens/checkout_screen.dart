// lib/features/member/plans/presentation/screens/checkout_screen.dart
//
// PURPOSE:
//   Two-step checkout flow for a member purchasing a gym plan:
//
//   STEP 1 — Payment method picker
//     Fetches available methods from GET /api/member/payment-methods.
//     Renders tiles: Stripe (card), PayPal, MPGS, Cash.
//
//   STEP 2 — Order summary + confirm
//     Shows selected plan, coupon discount, final total, and selected method.
//     On "Pay Now", calls POST /api/member/plans/checkout.
//     Routes the response to the right payment UI:
//       STRIPE  → flutter_stripe PaymentSheet (using clientSecret + publishableKey)
//       PAYPAL  → opens redirectUrl in webview (url_launcher)
//       MPGS    → opens redirectUrl in webview
//       CASH    → shows "Pending approval" confirmation screen
//
// USAGE (replace the TODO in plan_detail_screen.dart):
//   Navigator.push(context, MaterialPageRoute(
//     builder: (_) => CheckoutScreen(
//       planId: widget.planId,
//       plan: plan,
//       coupon: state.coupon,
//       tokenStore: tokenStore,
//     ),
//   ));
//
// PACKAGES NEEDED (add to pubspec.yaml if not present):
//   flutter_stripe: ^10.x.x          (Stripe native SDK)
//   url_launcher:   ^6.x.x           (PayPal / MPGS webview redirect)

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:build4allgym/core/config/env.dart';
import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/features/auth/data/services/auth_token_store.dart';
import 'package:build4allgym/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/plan_detail_entity.dart';
import '../../../plans/data/services/checkout_service.dart'; // existing service

// ─────────────────────────────────────────────────────────────────────────────
// CHECKOUT SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class CheckoutScreen extends StatefulWidget {
  final int              planId;
  final PlanDetailEntity plan;
  final String?          couponCode;
  final double?          finalPrice;   // after coupon, null = plan.price
  final AuthTokenStore   tokenStore;

  const CheckoutScreen({
    super.key,
    required this.planId,
    required this.plan,
    this.couponCode,
    this.finalPrice,
    required this.tokenStore,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // Step 1: payment method selection
  // Step 2: order summary + confirm
  int _step = 1;

  List<_PaymentMethodOption> _methods = [];
  bool _loadingMethods = true;
  String? _methodsError;

  _PaymentMethodOption? _selectedMethod;

  bool _checkingOut = false;

  @override
  void initState() {
    super.initState();
    _loadMethods();
  }

  double get _totalAmount => widget.finalPrice ?? widget.plan.price;

  Future<void> _loadMethods() async {
    try {
      final token = await widget.tokenStore.getToken();
      final response = await http.get(
        Uri.parse('${Env.apiProjectBaseUrl}/api/member/payment-methods'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _methods = data
              .cast<Map<String, dynamic>>()
              .map(_PaymentMethodOption.fromJson)
              .toList();
          _loadingMethods = false;
        });
      } else {
        setState(() {
          _methodsError = 'Failed to load payment methods';
          _loadingMethods = false;
        });
      }
    } catch (e) {
      setState(() {
        _methodsError = e.toString();
        _loadingMethods = false;
      });
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // CHECKOUT CALL
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> _checkout() async {
    if (_selectedMethod == null) return;
    setState(() => _checkingOut = true);

    try {
      final token = await widget.tokenStore.getToken();
      final body = jsonEncode({
        'planId':           widget.planId,
        'paymentMethod':    _selectedMethod!.code,
        'couponCode':       widget.couponCode,
        'autoRenewEnabled': false,
      });

      final response = await http.post(
        Uri.parse('${Env.apiProjectBaseUrl}/api/member/plans/checkout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode != 200) {
        final err = jsonDecode(response.body);
        throw Exception(err['error'] ?? err['message'] ?? 'Checkout failed');
      }

      final Map<String, dynamic> data = jsonDecode(response.body);
      await _handleGatewayResponse(data);
    } catch (e) {
      if (mounted) {
        final tokens = context.read<ThemeCubit>().state.tokens;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
          backgroundColor: tokens.colors.danger,
        ));
      }
    } finally {
      if (mounted) setState(() => _checkingOut = false);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // GATEWAY ROUTING
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> _handleGatewayResponse(Map<String, dynamic> data) async {
    final providerCode = (data['providerCode'] as String? ?? '').toUpperCase();
    final clientSecret  = data['clientSecret']  as String?;
    final publishableKey = data['publishableKey'] as String?;
    final redirectUrl   = data['redirectUrl']    as String?;
    final membershipId  = data['membershipId'];

    switch (providerCode) {
      case 'STRIPE':
        await _handleStripe(
          clientSecret:   clientSecret!,
          publishableKey: publishableKey!,
          membershipId:   membershipId,
        );
        break;

      case 'PAYPAL':
      case 'MPGS':
        await _handleWebRedirect(
          redirectUrl:  redirectUrl!,
          providerCode: providerCode,
          membershipId: membershipId,
        );
        break;

      case 'CASH':
        _navigateToCashConfirmation(data);
        break;

      default:
        _navigateToSuccess(membershipId: membershipId, providerCode: providerCode);
    }
  }

  Future<void> _handleStripe({
    required String clientSecret,
    required String publishableKey,
    required dynamic membershipId,
  }) async {
    // ──────────────────────────────────────────────────────────────────────
    // STRIPE INTEGRATION  (requires flutter_stripe in pubspec.yaml)
    //
    // 1. Add to pubspec.yaml:
    //      flutter_stripe: ^10.1.1
    //
    // 2. Uncomment the imports below and the code in this method.
    //
    // 3. Add to AndroidManifest:
    //      <activity android:name="com.stripe.android.paymentsheet.PaymentSheetActivity" />
    //
    // For now we show a placeholder message.
    // ──────────────────────────────────────────────────────────────────────

    /*
    import 'package:flutter_stripe/flutter_stripe.dart';

    Stripe.publishableKey = publishableKey;
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'Your Gym Name',
      ),
    );
    await Stripe.instance.presentPaymentSheet();
    _navigateToSuccess(membershipId: membershipId, providerCode: 'STRIPE');
    */

    if (!mounted) return;
    // Placeholder until flutter_stripe is added:
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Stripe Payment'),
        content: Text(
          'Client secret received.\n\nTo complete Stripe integration:\n'
          '1. Add flutter_stripe to pubspec.yaml\n'
          '2. Uncomment the Stripe code in checkout_screen.dart',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToSuccess(
                  membershipId: membershipId, providerCode: 'STRIPE');
            },
            child: const Text('Simulate Success'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleWebRedirect({
    required String redirectUrl,
    required String providerCode,
    required dynamic membershipId,
  }) async {
    // ──────────────────────────────────────────────────────────────────────
    // PAYPAL / MPGS WEBVIEW  (requires url_launcher or webview_flutter)
    //
    // Option A — External browser (simplest):
    //   import 'package:url_launcher/url_launcher.dart';
    //   await launchUrl(Uri.parse(redirectUrl), mode: LaunchMode.externalApplication);
    //
    // Option B — In-app WebView (better UX):
    //   Use webview_flutter and navigate back on success/cancel callback URL.
    //
    // For now we show the URL in a dialog.
    // ──────────────────────────────────────────────────────────────────────

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('$providerCode Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Redirect URL received:'),
            const SizedBox(height: 8),
            SelectableText(redirectUrl,
                style: const TextStyle(fontSize: 12, color: Colors.blue)),
            const SizedBox(height: 12),
            const Text(
              'To complete: add url_launcher and open this URL, or use '
              'webview_flutter for in-app payment.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToSuccess(
                  membershipId: membershipId, providerCode: providerCode);
            },
            child: const Text('Simulate Success'),
          ),
        ],
      ),
    );
  }

  void _navigateToCashConfirmation(Map<String, dynamic> data) {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => _CashPendingScreen(
          planName: data['planName'] as String? ?? widget.plan.name,
          invoiceNumber: data['invoiceNumber'] as String? ?? '',
          totalAmount: _totalAmount,
        ),
      ),
    );
  }

  void _navigateToSuccess({dynamic membershipId, String? providerCode}) {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => _PaymentSuccessScreen(
          planName: widget.plan.name,
          providerCode: providerCode ?? '',
          totalAmount: _totalAmount,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return Scaffold(
      backgroundColor: tokens.colors.background,
      appBar: AppBar(
        backgroundColor: tokens.colors.primary,
        foregroundColor: tokens.colors.onPrimary,
        title: Text(
          _step == 1 ? 'Choose Payment' : 'Order Summary',
          style: tokens.typography.titleMedium.copyWith(
              color: tokens.colors.onPrimary, fontWeight: FontWeight.w800),
        ),
        elevation: 0,
      ),
      body: _step == 1 ? _buildStep1(tokens) : _buildStep2(tokens),
    );
  }

  // ── STEP 1: Payment method picker ──────────────────────────────────────────
  Widget _buildStep1(tokens) {
    if (_loadingMethods) {
      return Center(
          child: CircularProgressIndicator(color: tokens.colors.primary));
    }
    if (_methodsError != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: tokens.colors.danger, size: 48),
            const SizedBox(height: 12),
            Text(_methodsError!,
                style: tokens.typography.bodyMedium
                    .copyWith(color: tokens.colors.danger)),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: _loadMethods, child: const Text('Retry')),
          ],
        ),
      );
    }
    if (_methods.isEmpty) {
      return Center(
        child: Text('No payment methods available.',
            style: tokens.typography.bodyMedium
                .copyWith(color: tokens.colors.muted)),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _methods.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final m = _methods[i];
              final selected = _selectedMethod?.code == m.code;
              return GestureDetector(
                onTap: () => setState(() => _selectedMethod = m),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: selected
                        ? tokens.colors.primary.withOpacity(0.1)
                        : tokens.colors.card,
                    border: Border.all(
                      color: selected
                          ? tokens.colors.primary
                          : tokens.colors.card,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(tokens.card.radius),
                  ),
                  child: Row(
                    children: [
                      Icon(_iconFor(m.code),
                          color: selected
                              ? tokens.colors.primary
                              : tokens.colors.muted,
                          size: 28),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(m.displayName,
                                style: tokens.typography.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: selected
                                        ? tokens.colors.primary
                                        : tokens.colors.label)),
                            Text(
                              m.type == 'offline'
                                  ? 'Pay in person at reception'
                                  : 'Online payment',
                              style: tokens.typography.bodySmall
                                  .copyWith(color: tokens.colors.muted),
                            ),
                          ],
                        ),
                      ),
                      if (selected)
                        Icon(Icons.check_circle_rounded,
                            color: tokens.colors.primary),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Continue button
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: SizedBox(
            height: 54,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedMethod == null
                  ? null
                  : () => setState(() => _step = 2),
              style: ElevatedButton.styleFrom(
                backgroundColor: tokens.colors.primary,
                foregroundColor: tokens.colors.onPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: Text('Continue',
                  style: tokens.typography.bodyMedium.copyWith(
                      color: tokens.colors.onPrimary,
                      fontWeight: FontWeight.w800)),
            ),
          ),
        ),
      ],
    );
  }

  // ── STEP 2: Order summary + pay ───────────────────────────────────────────
  Widget _buildStep2(tokens) {
    final method = _selectedMethod!;
    final isCash = method.type == 'offline';

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Plan card
                _SummaryCard(tokens: tokens, children: [
                  _Row(tokens: tokens, label: 'Plan', value: widget.plan.name),
                  if (widget.plan.durationDays != null)
                    _Row(
                        tokens: tokens,
                        label: 'Duration',
                        value: '${widget.plan.durationDays} days'),
                  if (widget.couponCode != null)
                    _Row(
                        tokens: tokens,
                        label: 'Coupon',
                        value: widget.couponCode!,
                        valueColor: tokens.colors.success),
                  const Divider(),
                  _Row(
                    tokens: tokens,
                    label: 'Total',
                    value: '\$${_totalAmount.toStringAsFixed(2)}',
                    bold: true,
                    valueColor: tokens.colors.primary,
                  ),
                ]),
                const SizedBox(height: 16),

                // Selected method card
                _SummaryCard(tokens: tokens, children: [
                  Row(
                    children: [
                      Icon(_iconFor(method.code),
                          color: tokens.colors.primary, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(method.displayName,
                                style: tokens.typography.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w700)),
                            Text(
                              isCash
                                  ? 'Your request will be sent to the admin. Pay at reception.'
                                  : 'You will be directed to complete payment.',
                              style: tokens.typography.bodySmall
                                  .copyWith(color: tokens.colors.muted),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => setState(() => _step = 1),
                        child: Text('Change',
                            style: tokens.typography.bodySmall
                                .copyWith(color: tokens.colors.primary)),
                      ),
                    ],
                  ),
                ]),
              ],
            ),
          ),
        ),

        // Pay / Request button
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: SizedBox(
            height: 54,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _checkingOut ? null : _checkout,
              style: ElevatedButton.styleFrom(
                backgroundColor: tokens.colors.primary,
                foregroundColor: tokens.colors.onPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: _checkingOut
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: tokens.colors.onPrimary))
                  : Text(
                      isCash ? 'Submit Cash Request' : 'Pay Now',
                      style: tokens.typography.bodyMedium.copyWith(
                          color: tokens.colors.onPrimary,
                          fontWeight: FontWeight.w800),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  IconData _iconFor(String code) {
    switch (code.toUpperCase()) {
      case 'STRIPE':  return Icons.credit_card_rounded;
      case 'PAYPAL':  return Icons.account_balance_wallet_rounded;
      case 'MPGS':    return Icons.contactless_rounded;
      case 'CASH':    return Icons.payments_rounded;
      default:        return Icons.payment_rounded;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CASH PENDING SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class _CashPendingScreen extends StatelessWidget {
  final String planName;
  final String invoiceNumber;
  final double totalAmount;
  const _CashPendingScreen({
    required this.planName,
    required this.invoiceNumber,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    return Scaffold(
      backgroundColor: tokens.colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: tokens.colors.warning.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.hourglass_top_rounded,
                    color: tokens.colors.warning, size: 40),
              ),
              const SizedBox(height: 20),
              Text('Cash Request Submitted',
                  style: tokens.typography.titleMedium.copyWith(
                      fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center),
              const SizedBox(height: 10),
              Text(
                'Your request for "$planName" has been submitted.\n'
                'Please visit reception with \$${totalAmount.toStringAsFixed(2)} to complete payment.\n'
                'An admin will activate your membership upon confirmation.',
                style: tokens.typography.bodyMedium
                    .copyWith(color: tokens.colors.muted),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text('Ref: $invoiceNumber',
                  style: tokens.typography.bodySmall.copyWith(
                      color: tokens.colors.muted)),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.popUntil(context, (r) => r.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tokens.colors.primary,
                    foregroundColor: tokens.colors.onPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text('Back to Home',
                      style: tokens.typography.bodyMedium.copyWith(
                          color: tokens.colors.onPrimary,
                          fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PAYMENT SUCCESS SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class _PaymentSuccessScreen extends StatelessWidget {
  final String planName;
  final String providerCode;
  final double totalAmount;
  const _PaymentSuccessScreen({
    required this.planName,
    required this.providerCode,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    return Scaffold(
      backgroundColor: tokens.colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: tokens.colors.success.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_circle_rounded,
                    color: tokens.colors.success, size: 40),
              ),
              const SizedBox(height: 20),
              Text('Payment Successful!',
                  style: tokens.typography.titleMedium.copyWith(
                      fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center),
              const SizedBox(height: 10),
              Text(
                'You are now subscribed to "$planName".\n'
                'Amount charged: \$${totalAmount.toStringAsFixed(2)}',
                style: tokens.typography.bodyMedium
                    .copyWith(color: tokens.colors.muted),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.popUntil(context, (r) => r.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tokens.colors.primary,
                    foregroundColor: tokens.colors.onPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text('Go to My Membership',
                      style: tokens.typography.bodyMedium.copyWith(
                          color: tokens.colors.onPrimary,
                          fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SMALL HELPERS
// ─────────────────────────────────────────────────────────────────────────────

class _PaymentMethodOption {
  final String code;
  final String displayName;
  final String type; // "online" | "offline"

  const _PaymentMethodOption({
    required this.code,
    required this.displayName,
    required this.type,
  });

  factory _PaymentMethodOption.fromJson(Map<String, dynamic> json) {
    return _PaymentMethodOption(
      code:        json['code']        as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      type:        json['type']        as String? ?? 'online',
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final List<Widget> children;
  const _SummaryCard({required this.children, required tokens}) : _tokens = tokens;
  final dynamic _tokens;

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.colors.card,
        borderRadius: BorderRadius.circular(tokens.card.radius),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;
  const _Row({
    required this.label,
    required this.value,
    this.bold = false,
    this.valueColor,
    required tokens,
  }) : _tokens = tokens;
  final dynamic _tokens;

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label,
              style: tokens.typography.bodySmall
                  .copyWith(color: tokens.colors.muted)),
          const Spacer(),
          Text(value,
              style: tokens.typography.bodyMedium.copyWith(
                  fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
                  color: valueColor ?? tokens.colors.label)),
        ],
      ),
    );
  }
}
