import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:build4allgym/l10n/app_localizations.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../member/plans/data/repositories/member_plans_repository_impl.dart';
import '../../../../member/plans/data/services/member_plans_remote_datasource.dart';
import '../../../../member/plans/domain/entities/payment_method_entity.dart';
import '../../../../member/plans/domain/usecases/get_payment_methods_usecase.dart';
import '../../data/services/sessions_service.dart';
import '../../domain/entities/book_session_result_entity.dart';
import '../bloc/sessions_bloc.dart';
import '../bloc/sessions_event.dart';
import '../bloc/sessions_state.dart';

class SessionBookingPaymentSheet extends StatefulWidget {
  final int sessionId;
  final String className;
  final double price;
  final DateTime startTime;
  final Dio dio;

  const SessionBookingPaymentSheet({
    super.key,
    required this.sessionId,
    required this.className,
    required this.price,
    required this.startTime,
    required this.dio,
  });

  static Future<void> show(
      BuildContext context, {
        required int sessionId,
        required String className,
        required double price,
        required DateTime startTime,
        required Dio dio,
      }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<SessionsBloc>(),
        child: SessionBookingPaymentSheet(
          sessionId: sessionId,
          className: className,
          price: price,
          startTime: startTime,
          dio: dio,
        ),
      ),
    );
  }

  @override
  State<SessionBookingPaymentSheet> createState() =>
      _SessionBookingPaymentSheetState();
}

class _SessionBookingPaymentSheetState
    extends State<SessionBookingPaymentSheet> {
  List<PaymentMethodEntity> _methods = [];
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
      final ds = MemberPlansRemoteDatasourceImpl(dio: widget.dio);
      final repo = MemberPlansRepositoryImpl(remoteDatasource: ds);
      final methods = await GetPaymentMethodsUseCase(repository: repo)();

      if (!mounted) return;

      setState(() {
        _methods = methods;

        if (methods.isNotEmpty) {
          _selectedMethod = methods.first.name;
        }

        _loadingMethods = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loadingMethods = false;
      });
    }
  }

  Future<void> _confirmBooking(BuildContext context) async {
    if (_selectedMethod == null || _submitting) return;

    setState(() {
      _submitting = true;
    });

    context.read<SessionsBloc>().add(
      SessionBookRequested(
        widget.sessionId,
        paymentMethod: _selectedMethod,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<SessionsBloc, SessionsState>(
      listener: (ctx, state) async {
        if (state is SessionBookingDone) {
          if (mounted) {
            setState(() {
              _submitting = false;
            });
          }

          /*
           * Save the bloc before closing the payment sheet.
           * After Navigator.pop(), ctx may no longer be mounted.
           */
          final sessionsBloc = ctx.read<SessionsBloc>();
          final navigator = Navigator.of(ctx);

          navigator.pop();

          /*
           * Reload the session detail so the backend-provided
           * memberBookingStatus is immediately reflected in the UI.
           *
           * For Cash:
           * memberBookingStatus becomes PENDING.
           *
           * The booking button then becomes disabled and displays
           * "Pending confirmation".
           */
          sessionsBloc.add(
            SessionDetailRequested(widget.sessionId),
          );

          if (context.mounted) {
            _showResultSheet(
              context,
              state.result,
              tokens,
            );
          }
        } else if (state is SessionBookingError) {
          if (mounted) {
            setState(() {
              _submitting = false;
            });
          }

          if (!ctx.mounted) return;

          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: c.danger,
            ),
          );
        } else if (state is SessionBookingPaymentReady) {
          if (mounted) {
            setState(() {
              _submitting = false;
            });
          }

          final navigator = Navigator.of(ctx);

          navigator.pop();

          if (context.mounted) {
            await _handleOnlinePayment(
              context,
              state.result,
              tokens,
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
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28),
            ),
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
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    20,
                    20,
                    32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.ptPackageConfirmBooking,
                        textAlign: TextAlign.center,
                        style: tokens.typography.headlineSmall.copyWith(
                          color: c.label,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 20),

                      _SummaryCard(
                        className: widget.className,
                        price: widget.price,
                        startTime: widget.startTime,
                        tokens: tokens,
                      ),

                      const SizedBox(height: 20),

                      Text(
                        l10n.memberInvoicesPaymentMethod,
                        style: tokens.typography.titleMedium.copyWith(
                          color: c.label,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),

                      if (_loadingMethods)
                        Center(
                          child: CircularProgressIndicator(
                            color: c.primary,
                          ),
                        )
                      else if (_methods.isEmpty)
                        Text(
                          l10n.paymentSheetNoMethodsAvailable,
                          style: tokens.typography.bodyMedium.copyWith(
                            color: c.muted,
                          ),
                        )
                      else
                        ..._methods.map(
                              (method) => _PaymentMethodTile(
                            method: method,
                            isSelected:
                            _selectedMethod == method.name,
                            tokens: tokens,
                            onTap: () {
                              setState(() {
                                _selectedMethod = method.name;
                              });
                            },
                          ),
                        ),

                      const SizedBox(height: 24),

                      SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _submitting ||
                              _loadingMethods ||
                              _selectedMethod == null
                              ? null
                              : () => _confirmBooking(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: c.primary,
                            foregroundColor: c.onPrimary,
                            disabledBackgroundColor:
                            c.primary.withOpacity(0.4),
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
                            l10n.ptPackageConfirmBooking,
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
      BookSessionResultEntity result,
      dynamic tokens,
      ) async {
    if (result.isStripe) {
      await _presentStripeSheet(
        context,
        result,
        tokens,
      );
    } else if (result.isRedirect) {
      await _launchRedirectPayment(
        context,
        result,
        tokens,
      );
    }
  }

  Future<void> _presentStripeSheet(
      BuildContext context,
      BookSessionResultEntity result,
      dynamic tokens,
      ) async {
    final c = tokens.colors;

    try {
      Stripe.publishableKey = result.publishableKey!;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: result.clientSecret!,
          merchantDisplayName: 'Build4All Gym',
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      if (result.transactionId != null &&
          result.invoiceId != null) {
        try {
          await SessionsService(widget.dio)
              .confirmBookingStripePayment(
            transactionId: result.transactionId!,
            invoiceId: result.invoiceId!,
          );
        } catch (_) {
          /*
           * Payment status will still be refreshed from the backend.
           */
        }
      }

      if (!context.mounted) return;

      context.read<SessionsBloc>().add(
        SessionDetailRequested(widget.sessionId),
      );

      _showResultSheet(
        context,
        result,
        tokens,
        confirmed: true,
      );
    } on StripeException catch (e) {
      if (!context.mounted) return;

      if (e.error.code != FailureCode.Canceled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.paymentSheetPaymentFailed,
            ),
            backgroundColor: c.danger,
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: c.danger,
        ),
      );
    }
  }

  Future<void> _launchRedirectPayment(
      BuildContext context,
      BookSessionResultEntity result,
      dynamic tokens,
      ) async {
    final url = Uri.parse(result.redirectUrl!);

    try {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      /*
       * The user can retry opening the page from the waiting sheet.
       */
    }

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (ctx) => _WaitingRedirectSheet(
        tokens: tokens,
        onDone: () {
          Navigator.of(ctx).pop();

          context.read<SessionsBloc>().add(
            SessionDetailRequested(widget.sessionId),
          );
        },
        onRelaunch: () async {
          try {
            await launchUrl(
              url,
              mode: LaunchMode.externalApplication,
            );
          } catch (_) {
            /*
             * Keep the waiting sheet open so the user may retry.
             */
          }
        },
      ),
    );
  }

  void _showResultSheet(
      BuildContext context,
      BookSessionResultEntity result,
      dynamic tokens, {
        bool confirmed = false,
      }) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (_) => _BookingResultSheet(
        result: result,
        tokens: tokens,
        confirmed: confirmed,
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String className;
  final double price;
  final DateTime startTime;
  final dynamic tokens;

  const _SummaryCard({
    required this.className,
    required this.price,
    required this.startTime,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;

    final timeStr = DateFormat(
      'EEEE, MMM d — HH:mm',
      Localizations.localeOf(context).languageCode,
    ).format(startTime);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: c.background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: c.border.withOpacity(0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  className,
                  style: tokens.typography.titleMedium.copyWith(
                    color: c.label,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                '\$ ${price.toStringAsFixed(2)}',
                style: tokens.typography.headlineSmall.copyWith(
                  color: c.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 22.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                size: 14,
                color: c.muted,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  timeStr,
                  style: tokens.typography.bodySmall.copyWith(
                    color: c.muted,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final PaymentMethodEntity method;
  final bool isSelected;
  final dynamic tokens;
  final VoidCallback onTap;

  const _PaymentMethodTile({
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
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? c.primary.withOpacity(0.07)
              : c.background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? c.primary
                : c.border.withOpacity(0.2),
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
                  fontWeight: isSelected
                      ? FontWeight.w800
                      : FontWeight.w600,
                ),
              ),
            ),
            Radio<String>(
              value: method.name,
              groupValue: isSelected ? method.name : null,
              activeColor: c.primary,
              onChanged: (_) => onTap(),
              materialTapTargetSize:
              MaterialTapTargetSize.shrinkWrap,
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

class _BookingResultSheet extends StatelessWidget {
  final BookSessionResultEntity result;
  final dynamic tokens;
  final bool confirmed;

  const _BookingResultSheet({
    required this.result,
    required this.tokens,
    required this.confirmed,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    final isPending = result.isPending && !confirmed;
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
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
              color: isPending
                  ? const Color(0xFF856404)
                  : c.success,
              size: 34,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isPending
                ? l10n.paymentSheetPendingConfirmationTitle
                : l10n.bookingSuccessTitle,
            style: tokens.typography.headlineSmall.copyWith(
              color: c.label,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isPending
                ? l10n.sessionBookingPendingMessage
                : l10n.sessionBookingSuccessMessage,
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
                l10n.paymentSheetOkButton,
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

class _WaitingRedirectSheet extends StatelessWidget {
  final dynamic tokens;
  final VoidCallback onDone;
  final VoidCallback onRelaunch;

  const _WaitingRedirectSheet({
    required this.tokens,
    required this.onDone,
    required this.onRelaunch,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
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
            child: Icon(
              Icons.open_in_browser_rounded,
              color: c.primary,
              size: 34,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.paymentSheetCompleteInBrowserTitle,
            style: tokens.typography.headlineSmall.copyWith(
              color: c.label,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.paymentSheetCompleteInBrowserMessage,
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
              onPressed: onDone,
              style: ElevatedButton.styleFrom(
                backgroundColor: c.primary,
                foregroundColor: c.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                l10n.paymentSheetDoneVerifyPayment,
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
              l10n.paymentSheetReopenPaymentPage,
              style: tokens.typography.bodyMedium.copyWith(
                color: c.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}