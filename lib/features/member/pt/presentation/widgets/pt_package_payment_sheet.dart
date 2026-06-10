import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../data/services/member_pt_service.dart';
import '../../domain/entities/pt_package_booking_response_entity.dart';
import '../bloc/pt_package_booking_bloc.dart';
import '../bloc/pt_package_booking_event.dart';
import '../bloc/pt_package_booking_state.dart';

class PtPackagePaymentSheet extends StatefulWidget {
  final double totalAmount;
  final String packageName;
  final MemberPtService memberPtService;

  const PtPackagePaymentSheet({
    super.key,
    required this.totalAmount,
    required this.packageName,
    required this.memberPtService,
  });

  static Future<void> show(
    BuildContext context, {
    required double totalAmount,
    required String packageName,
    required MemberPtService memberPtService,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<PtPackageBookingBloc>(),
        child: PtPackagePaymentSheet(
          totalAmount: totalAmount,
          packageName: packageName,
          memberPtService: memberPtService,
        ),
      ),
    );
  }

  @override
  State<PtPackagePaymentSheet> createState() => _PtPackagePaymentSheetState();
}

class _PtPackagePaymentSheetState extends State<PtPackagePaymentSheet> {
  List<_PaymentMethod> _methods = [];
  String? _selectedMethod;
  bool _loadingMethods = true;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
  }

  Future<void> _loadPaymentMethods() async {
    try {
      final raw = await widget.memberPtService.getPaymentMethods();
      if (mounted) {
        setState(() {
          _methods = raw
              .map((m) => _PaymentMethod(
                    name: m['name'] as String? ?? '',
                    displayName: m['displayName'] as String? ?? m['name'] as String? ?? '',
                  ))
              .where((m) => m.name.isNotEmpty)
              .toList();
          if (_methods.isNotEmpty) _selectedMethod = _methods.first.name;
          _loadingMethods = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingMethods = false);
    }
  }

  void _confirm(BuildContext context) {
    if (_selectedMethod == null) return;
    setState(() => _submitting = true);
    context
        .read<PtPackageBookingBloc>()
        .add(PtPackagePaymentConfirmRequested(_selectedMethod!));
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return BlocListener<PtPackageBookingBloc, PtPackageBookingState>(
      listener: (ctx, state) async {
        if (state is PtPackageBookingPaymentReady) {
          setState(() => _submitting = false);
          Navigator.of(ctx).pop();
          if (ctx.mounted) {
            await _handleOnlinePayment(ctx, state.booking, tokens);
          }
        } else if (state is PtPackageBookingSuccess) {
          setState(() => _submitting = false);
          Navigator.of(ctx).pop();
          if (ctx.mounted) _showResultSheet(ctx, state.booking, tokens);
        } else if (state is PtPackageBookingError) {
          setState(() => _submitting = false);
          if (ctx.mounted) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: c.danger,
              ),
            );
          }
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        expand: false,
        builder: (_, scrollController) => Container(
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: c.border.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                color: c.primary,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: isRtl
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: tokens.colors.onPrimary.withOpacity(0.22),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: tokens.colors.onPrimary,
                            size: 18.0,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: isRtl
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(end: 52.0),
                        child: Text(
                          'تأكيد الحجز',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: tokens.typography.headlineSmall.copyWith(
                            color: tokens.colors.onPrimary,
                            fontWeight: FontWeight.w900,
                            fontSize: 22.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Summary card
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: c.background,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: c.border.withOpacity(0.15)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.packageName,
                                style: tokens.typography.titleMedium.copyWith(
                                  color: c.label,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            Text(
                              '\$ ${widget.totalAmount.toStringAsFixed(2)}',
                              style: tokens.typography.headlineSmall.copyWith(
                                color: c.primary,
                                fontWeight: FontWeight.w900,
                                fontSize: 22.0,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        'طريقة الدفع',
                        style: tokens.typography.titleMedium.copyWith(
                          color: c.label,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),

                      if (_loadingMethods)
                        Center(child: CircularProgressIndicator(color: c.primary))
                      else if (_methods.isEmpty)
                        Text(
                          'لا توجد طرق دفع متاحة',
                          style: tokens.typography.bodyMedium.copyWith(color: c.muted),
                        )
                      else
                        ..._methods.map((m) => _MethodTile(
                              method: m,
                              isSelected: _selectedMethod == m.name,
                              tokens: tokens,
                              onTap: () => setState(() => _selectedMethod = m.name),
                            )),

                      const SizedBox(height: 24),

                      SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: (_submitting ||
                                  _loadingMethods ||
                                  _selectedMethod == null)
                              ? null
                              : () => _confirm(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: c.primary,
                            foregroundColor: c.onPrimary,
                            disabledBackgroundColor: c.primary.withOpacity(0.4),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: _submitting
                              ? SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: c.onPrimary,
                                  ),
                                )
                              : Text(
                                  'تأكيد الحجز',
                                  style: tokens.typography.bodyMedium.copyWith(
                                    color: c.onPrimary,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleOnlinePayment(
    BuildContext context,
    PtPackageBookingResponseEntity booking,
    dynamic tokens,
  ) async {
    if (booking.isStripe) {
      await _presentStripeSheet(context, booking, tokens);
    } else if (booking.isRedirect) {
      await _launchRedirectPayment(context, booking, tokens);
    }
  }

  Future<void> _presentStripeSheet(
    BuildContext context,
    PtPackageBookingResponseEntity booking,
    dynamic tokens,
  ) async {
    try {
      Stripe.publishableKey = booking.publishableKey!;
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: booking.clientSecret!,
          merchantDisplayName: 'Build4All Gym',
        ),
      );
      await Stripe.instance.presentPaymentSheet();

      // Activate booking + generate sessions on backend.
      if (context.mounted) {
        context
            .read<PtPackageBookingBloc>()
            .add(const PtPackagePaymentActivated());
      }
    } on StripeException catch (e) {
      if (context.mounted && e.error.code != FailureCode.Canceled) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.error.localizedMessage ?? 'Payment failed'),
          backgroundColor: tokens.colors.danger,
        ));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
          backgroundColor: tokens.colors.danger,
        ));
      }
    }
  }

  Future<void> _launchRedirectPayment(
    BuildContext context,
    PtPackageBookingResponseEntity booking,
    dynamic tokens,
  ) async {
    final url = Uri.parse(booking.redirectUrl!);
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (_) {}

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => _WaitingSheet(
        tokens: tokens,
        onDone: () {
          Navigator.of(ctx).pop();
          context
              .read<PtPackageBookingBloc>()
              .add(const PtPackagePaymentActivated());
        },
        onRelaunch: () async {
          try {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          } catch (_) {}
        },
      ),
    );
  }

  void _showResultSheet(
    BuildContext context,
    PtPackageBookingResponseEntity booking,
    dynamic tokens,
  ) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => _ResultSheet(booking: booking, tokens: tokens),
    );
  }
}

// ── Internal models ───────────────────────────────────────────────────────────

class _PaymentMethod {
  final String name;
  final String displayName;

  const _PaymentMethod({required this.name, required this.displayName});
}

// ── Payment method tile ───────────────────────────────────────────────────────

class _MethodTile extends StatelessWidget {
  final _PaymentMethod method;
  final bool isSelected;
  final dynamic tokens;
  final VoidCallback onTap;

  const _MethodTile({
    required this.method,
    required this.isSelected,
    required this.tokens,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? c.primary.withOpacity(0.07) : c.background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? c.primary : c.border.withOpacity(0.2),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              _iconFor(method.name),
              color: isSelected ? c.primary : c.muted,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                method.displayName,
                style: tokens.typography.bodyMedium.copyWith(
                  color: isSelected ? c.primary : c.label,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ),
            Radio<String>(
              value: method.name,
              groupValue: isSelected ? method.name : null,
              activeColor: c.primary,
              onChanged: (_) => onTap(),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(String name) {
    switch (name.toUpperCase()) {
      case 'CASH':
        return Icons.payments_outlined;
      case 'STRIPE':
        return Icons.credit_card_outlined;
      case 'PAYPAL':
        return Icons.account_balance_wallet_outlined;
      default:
        return Icons.payment_outlined;
    }
  }
}

// ── Result sheet ──────────────────────────────────────────────────────────────

class _ResultSheet extends StatelessWidget {
  final PtPackageBookingResponseEntity booking;
  final dynamic tokens;

  const _ResultSheet({required this.booking, required this.tokens});

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    final isPending = booking.isPending;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isPending
                  ? const Color(0xFFFFF3CD)
                  : c.success.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPending
                  ? Icons.hourglass_top_rounded
                  : Icons.check_circle_outline,
              color: isPending ? const Color(0xFF856404) : c.success,
              size: 34,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isPending ? 'في انتظار تأكيد الدفع' : 'تم الحجز بنجاح',
            style: tokens.typography.headlineSmall.copyWith(
              color: c.label,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isPending
                ? 'تم إرسال طلبك إلى الإدارة. سيتم تفعيل الحصص بعد تأكيد استلام الدفع.'
                : 'تم تأكيد حجزك وسيتم توليد جميع الحصص تلقائياً.',
            textAlign: TextAlign.center,
            style: tokens.typography.bodyMedium.copyWith(
              color: c.muted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: c.primary,
                foregroundColor: c.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'حسناً',
                style: tokens.typography.bodyMedium.copyWith(
                  color: c.onPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Waiting for redirect ──────────────────────────────────────────────────────

class _WaitingSheet extends StatelessWidget {
  final dynamic tokens;
  final VoidCallback onDone;
  final VoidCallback onRelaunch;

  const _WaitingSheet({
    required this.tokens,
    required this.onDone,
    required this.onRelaunch,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: c.primary.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.open_in_browser_rounded, color: c.primary, size: 34),
          ),
          const SizedBox(height: 16),
          Text(
            'أكمل الدفع في المتصفح',
            style: tokens.typography.headlineSmall.copyWith(
              color: c.label,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'تم فتح صفحة الدفع في المتصفح. أكمل عملية الدفع ثم ارجع هنا واضغط "تم".',
            textAlign: TextAlign.center,
            style: tokens.typography.bodyMedium.copyWith(color: c.muted, height: 1.5),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onDone,
              style: ElevatedButton.styleFrom(
                backgroundColor: c.primary,
                foregroundColor: c.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                'تم — التحقق من الدفع',
                style: tokens.typography.bodyMedium.copyWith(
                  color: c.onPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onRelaunch,
            child: Text(
              'إعادة فتح صفحة الدفع',
              style: tokens.typography.bodyMedium.copyWith(color: c.primary),
            ),
          ),
        ],
      ),
    );
  }
}
