import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../domain/entities/member_invoice_entity.dart';
import 'member_invoice_badge.dart';

/// Member invoice card used in Payment History.
///
/// Figma-style:
/// - Amount on the left
/// - Invoice title/details on the right
/// - Status chip
/// - Bottom buttons
/// - Supports refund loading state
class MemberInvoiceSummaryCard extends StatelessWidget {
  final MemberInvoiceSummaryEntity invoice;
  final dynamic tokens;
  final AppLocalizations l10n;
  final String localeName;
  final bool isRequestingRefund;
  final VoidCallback onDetails;
  final VoidCallback? onRefund;

  const MemberInvoiceSummaryCard({
    super.key,
    required this.invoice,
    required this.tokens,
    required this.l10n,
    required this.localeName,
    required this.onDetails,
    this.onRefund,
    this.isRequestingRefund = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    final t = tokens.typography;
    final money = NumberFormat('#,##0.00', localeName);
    final statusColor = _statusColor(invoice.status, c);

    final canShowRefund = invoice.canRequestRefund && onRefund != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 14.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(
          color: c.border.withValues(alpha: 0.16),
        ),
        boxShadow: [
          BoxShadow(
            color: c.label.withValues(alpha: 0.06),
            blurRadius: 14.0,
            offset: const Offset(0.0, 5.0),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side: amount + invoice number
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      money.format(invoice.totalAmount),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.titleMedium.copyWith(
                        color: c.success,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      invoice.invoiceNumber,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.bodySmall.copyWith(
                        color: c.muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12.0),

              // Right side: type/branch + date/payment + status
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _invoiceTitle(invoice, l10n),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: t.bodyMedium.copyWith(
                        color: c.label,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      _subtitle(invoice, l10n, localeName),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: t.bodySmall.copyWith(
                        color: c.muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    MemberInvoiceBadge(
                      text: _statusLabel(invoice.status, l10n),
                      color: statusColor,
                      tokens: tokens,
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (invoice.refundStatus != null &&
              invoice.refundStatus!.trim().isNotEmpty) ...[
            const SizedBox(height: 10.0),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: MemberInvoiceBadge(
                text:
                '${l10n.memberInvoicesRefundStatus}: ${_refundLabel(invoice.refundStatus!, l10n)}',
                color: c.primary,
                tokens: tokens,
              ),
            ),
          ],

          const SizedBox(height: 14.0),
          Divider(
            height: 1.0,
            color: c.border.withValues(alpha: 0.18),
          ),
          const SizedBox(height: 14.0),

          Row(
            children: [
              if (canShowRefund) ...[
                Expanded(
                  child: SizedBox(
                    height: 42.0,
                    child: ElevatedButton.icon(
                      onPressed: isRequestingRefund ? null : onRefund,
                      icon: isRequestingRefund
                          ? SizedBox(
                        width: 16.0,
                        height: 16.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          color: c.onPrimary,
                        ),
                      )
                          : Icon(
                        Icons.refresh_rounded,
                        size: 17.0,
                        color: c.onPrimary,
                      ),
                      label: Text(
                        l10n.memberInvoicesRefund,
                        style: t.bodyMedium.copyWith(
                          color: c.onPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: c.danger,
                        disabledBackgroundColor:
                        c.danger.withValues(alpha: 0.55),
                        foregroundColor: c.onPrimary,
                        disabledForegroundColor: c.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
              ],
              Expanded(
                child: SizedBox(
                  height: 42.0,
                  child: OutlinedButton(
                    onPressed: onDetails,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: c.label,
                      side: BorderSide(
                        color: c.border.withValues(alpha: 0.55),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                    ),
                    child: Text(
                      l10n.memberInvoicesDetails,
                      style: t.bodyMedium.copyWith(
                        color: c.label,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
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

String _invoiceTitle(
    MemberInvoiceSummaryEntity invoice,
    AppLocalizations l10n,
    ) {
  final typeLabel = _typeLabel(invoice.type, l10n);

  if (invoice.branchName != null && invoice.branchName!.trim().isNotEmpty) {
    return '$typeLabel - ${invoice.branchName!.trim()}';
  }

  return typeLabel;
}

String _subtitle(
    MemberInvoiceSummaryEntity invoice,
    AppLocalizations l10n,
    String localeName,
    ) {
  final date = _formatDate(invoice.invoiceDate, localeName);

  if (invoice.paymentMethod != null &&
      invoice.paymentMethod!.trim().isNotEmpty) {
    return '$date · ${_paymentMethodLabel(invoice.paymentMethod!, l10n)}';
  }

  return date;
}

Color _statusColor(String status, dynamic c) {
  switch (status.toLowerCase()) {
    case 'paid':
      return c.success;
    case 'refunded':
      return c.primary;
    case 'cancelled':
    case 'failed':
    case 'overdue':
      return c.danger;
    case 'pending':
      return c.primary;
    default:
      return c.muted;
  }
}

String _statusLabel(String status, AppLocalizations l10n) {
  switch (status.toLowerCase()) {
    case 'paid':
      return l10n.memberInvoicesStatusPaid;
    case 'pending':
      return l10n.memberInvoicesStatusPending;
    case 'refunded':
      return l10n.memberInvoicesStatusRefunded;
    case 'cancelled':
      return l10n.memberInvoicesStatusCancelled;
    case 'failed':
      return l10n.memberInvoicesStatusFailed;
    default:
      return l10n.memberInvoicesStatusUnknown;
  }
}

String _refundLabel(String status, AppLocalizations l10n) {
  switch (status.toLowerCase()) {
    case 'pending':
      return l10n.memberInvoicesStatusPending;
    case 'approved':
      return l10n.memberInvoicesStatusRefunded;
    case 'rejected':
      return l10n.memberInvoicesStatusRejected;
    default:
      return l10n.memberInvoicesStatusUnknown;
  }
}

String _typeLabel(String? type, AppLocalizations l10n) {
  switch ((type ?? '').toLowerCase()) {
    case 'plan':
    case 'membership':
      return l10n.memberInvoicesTypePlans;
    case 'class':
      return l10n.memberInvoicesTypeClasses;
    case 'pt':
      return l10n.memberInvoicesTypePt;
    case 'pt_package':
      return l10n.memberInvoicesTypePtPackage;
    case 'daily_pass':
      return l10n.memberInvoicesTypeDailyPass;
    default:
      return l10n.memberInvoicesTypeOther;
  }
}

String _paymentMethodLabel(String method, AppLocalizations l10n) {
  switch (method.toLowerCase()) {
    case 'cash':
      return l10n.memberInvoicesPaymentCash;
    case 'card':
      return l10n.memberInvoicesPaymentCard;
    case 'stripe':
      return l10n.memberInvoicesPaymentStripe;
    case 'bank_transfer':
      return l10n.memberInvoicesPaymentBankTransfer;
    case 'wallet':
      return l10n.memberInvoicesPaymentWallet;
    default:
      return l10n.memberInvoicesPaymentOther;
  }
}

String _formatDate(String rawDate, String localeName) {
  try {
    return DateFormat.yMMMd(localeName).format(DateTime.parse(rawDate));
  } catch (_) {
    return rawDate;
  }
}