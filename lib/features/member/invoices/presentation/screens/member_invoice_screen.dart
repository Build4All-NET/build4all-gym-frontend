import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../domain/entities/member_invoice_entity.dart';
import '../bloc/member_invoice_bloc.dart';
import '../bloc/member_invoice_event.dart';
import '../bloc/member_invoice_state.dart';
import '../widgets/member_invoice_badge.dart';

/// Member invoice details screen.
///
/// Admin-style layout:
/// - Header invoice card
/// - Items table
/// - Totals section
/// - Payments section
/// - Download / Share PDF button
///
/// Important:
/// - Uses member entities, not admin entities.
/// - Uses member bloc, not admin bloc.
/// - Uses localization, not hardcoded visible text.
/// - Maps statuses before display.
class MemberInvoiceScreen extends StatefulWidget {
  final int invoiceId;

  const MemberInvoiceScreen({
    super.key,
    required this.invoiceId,
  });

  @override
  State<MemberInvoiceScreen> createState() => _MemberInvoiceScreenState();
}

class _MemberInvoiceScreenState extends State<MemberInvoiceScreen> {
  @override
  void initState() {
    super.initState();

    context.read<MemberInvoiceBloc>().add(
      LoadMemberInvoiceEvent(invoiceId: widget.invoiceId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.watch<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: c.label,
            size: 20.0,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.memberInvoiceDetailsTitle,
          style: tokens.typography.titleMedium.copyWith(
            color: c.label,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: BlocBuilder<MemberInvoiceBloc, MemberInvoiceState>(
        builder: (context, state) {
          if (state is MemberInvoiceInitial || state is MemberInvoiceLoading) {
            return Center(
              child: CircularProgressIndicator(color: c.primary),
            );
          }

          if (state is MemberInvoiceError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: ElevatedButton(
                  onPressed: () {
                    context.read<MemberInvoiceBloc>().add(
                      LoadMemberInvoiceEvent(invoiceId: widget.invoiceId),
                    );
                  },
                  child: Text(l10n.memberInvoicesRetry),
                ),
              ),
            );
          }

          if (state is MemberInvoiceLoaded) {
            return _InvoiceView(
              invoice: state.invoice,
              tokens: tokens,
              l10n: l10n,
              localeName: Localizations.localeOf(context).toLanguageTag(),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Invoice view with fixed PDF button
// ─────────────────────────────────────────────────────────────────────────────

class _InvoiceView extends StatelessWidget {
  final MemberInvoiceEntity invoice;
  final dynamic tokens;
  final AppLocalizations l10n;
  final String localeName;

  const _InvoiceView({
    required this.invoice,
    required this.tokens,
    required this.l10n,
    required this.localeName,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    final t = tokens.typography;
    final money = NumberFormat('#,##0.00', localeName);

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InvoiceCard(
                invoice: invoice,
                tokens: tokens,
                l10n: l10n,
                money: money,
                localeName: localeName,
              ),
            ],
          ),
        ),

        // Fixed PDF button, same idea as admin invoice.
        Positioned(
          bottom: 24.0,
          left: 16.0,
          right: 16.0,
          child: SizedBox(
            height: 54.0,
            child: ElevatedButton.icon(
              onPressed: () => _downloadPdf(
                invoice: invoice,
                l10n: l10n,
                localeName: localeName,
              ),
              icon: const Icon(Icons.picture_as_pdf_outlined, size: 20.0),
              label: Text(
                l10n.memberInvoiceDownloadPdf,
                style: t.bodyMedium.copyWith(
                  color: c.onPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: c.primary,
                foregroundColor: c.onPrimary,
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _downloadPdf({
    required MemberInvoiceEntity invoice,
    required AppLocalizations l10n,
    required String localeName,
  }) async {
    final pdf = _buildMemberInvoicePdf(
      invoice: invoice,
      l10n: l10n,
      localeName: localeName,
    );

    await Printing.layoutPdf(
      onLayout: (_) async => pdf.save(),
      name: 'Invoice-${invoice.invoiceNumber}',
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Invoice card
// ─────────────────────────────────────────────────────────────────────────────

class _InvoiceCard extends StatelessWidget {
  final MemberInvoiceEntity invoice;
  final dynamic tokens;
  final AppLocalizations l10n;
  final NumberFormat money;
  final String localeName;

  const _InvoiceCard({
    required this.invoice,
    required this.tokens,
    required this.l10n,
    required this.money,
    required this.localeName,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    final t = tokens.typography;
    final statusColor = _statusColor(invoice.status, c);

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: c.border.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: c.label.withValues(alpha: 0.06),
            blurRadius: 14.0,
            offset: const Offset(0.0, 4.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeaderBanner(
            invoice: invoice,
            tokens: tokens,
            l10n: l10n,
            money: money,
            localeName: localeName,
            statusColor: statusColor,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Invoice number + date
                Row(
                  children: [
                    Expanded(
                      child: _MetaBlock(
                        label: l10n.memberInvoiceInvoiceNumber,
                        value: invoice.invoiceNumber,
                        tokens: tokens,
                      ),
                    ),
                    Expanded(
                      child: _MetaBlock(
                        label: l10n.memberInvoicesDate,
                        value: _formatDate(invoice.invoiceDate, localeName),
                        tokens: tokens,
                        align: TextAlign.end,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20.0),
                Divider(color: c.border.withValues(alpha: 0.15), height: 1.0),
                const SizedBox(height: 20.0),

                // Items
                Text(
                  l10n.memberInvoiceItems,
                  style: t.bodySmall.copyWith(
                    color: c.muted,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 10.0),
                _ItemsTable(
                  items: invoice.items,
                  tokens: tokens,
                  l10n: l10n,
                  money: money,
                ),

                const SizedBox(height: 20.0),
                Divider(color: c.border.withValues(alpha: 0.15), height: 1.0),
                const SizedBox(height: 12.0),

                // Totals
                _TotalRow(
                  label: l10n.memberInvoiceSubtotal,
                  value: money.format(invoice.subtotal),
                  tokens: tokens,
                ),
                if (invoice.discountAmount > 0)
                  _TotalRow(
                    label: l10n.memberInvoiceDiscount,
                    value: money.format(invoice.discountAmount),
                    tokens: tokens,
                    valueColor: c.success,
                  ),
                if (invoice.taxAmount > 0)
                  _TotalRow(
                    label: l10n.memberInvoiceTax,
                    value: money.format(invoice.taxAmount),
                    tokens: tokens,
                  ),
                const SizedBox(height: 6.0),
                Divider(color: c.border.withValues(alpha: 0.15), height: 1.0),
                const SizedBox(height: 6.0),
                _TotalRow(
                  label: l10n.memberInvoiceTotal,
                  value: money.format(invoice.totalAmount),
                  tokens: tokens,
                  bold: true,
                ),
                _TotalRow(
                  label: l10n.memberInvoicesPaid,
                  value: money.format(invoice.paidAmount),
                  tokens: tokens,
                  valueColor: c.success,
                ),
                if (invoice.dueAmount > 0)
                  _TotalRow(
                    label: l10n.memberInvoicesDue,
                    value: money.format(invoice.dueAmount),
                    tokens: tokens,
                    bold: true,
                    valueColor: c.danger,
                  ),

                // Payments
                if (invoice.payments.isNotEmpty) ...[
                  const SizedBox(height: 20.0),
                  Divider(
                    color: c.border.withValues(alpha: 0.15),
                    height: 1.0,
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    l10n.memberInvoicePayments,
                    style: t.bodySmall.copyWith(
                      color: c.muted,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  for (final payment in invoice.payments)
                    _PaymentRow(
                      payment: payment,
                      tokens: tokens,
                      l10n: l10n,
                      money: money,
                      localeName: localeName,
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────────────────────────

class _HeaderBanner extends StatelessWidget {
  final MemberInvoiceEntity invoice;
  final dynamic tokens;
  final AppLocalizations l10n;
  final NumberFormat money;
  final String localeName;
  final Color statusColor;

  const _HeaderBanner({
    required this.invoice,
    required this.tokens,
    required this.l10n,
    required this.money,
    required this.localeName,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    final t = tokens.typography;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: c.primary.withValues(alpha: 0.08),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46.0,
            height: 46.0,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14.0),
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              color: statusColor,
              size: 23.0,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.memberInvoiceDetailsTitle,
                  style: t.headlineSmall.copyWith(
                    color: c.primary,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 6.0),
                if (invoice.branchName != null &&
                    invoice.branchName!.trim().isNotEmpty)
                  Text(
                    invoice.branchName!,
                    style: t.bodySmall.copyWith(color: c.muted),
                  ),
                if (invoice.branchAddress != null &&
                    invoice.branchAddress!.trim().isNotEmpty)
                  Text(
                    invoice.branchAddress!,
                    style: t.bodySmall.copyWith(color: c.muted),
                  ),
                if (invoice.branchPhone != null &&
                    invoice.branchPhone!.trim().isNotEmpty)
                  Text(
                    invoice.branchPhone!,
                    style: t.bodySmall.copyWith(color: c.muted),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                money.format(invoice.totalAmount),
                style: t.titleMedium.copyWith(
                  color: c.label,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6.0),
              MemberInvoiceBadge(
                text: _statusLabel(invoice.status, l10n),
                color: statusColor,
                tokens: tokens,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Items table
// ─────────────────────────────────────────────────────────────────────────────

class _ItemsTable extends StatelessWidget {
  final List<MemberInvoiceItemEntity> items;
  final dynamic tokens;
  final AppLocalizations l10n;
  final NumberFormat money;

  const _ItemsTable({
    required this.items,
    required this.tokens,
    required this.l10n,
    required this.money,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    final t = tokens.typography;

    if (items.isEmpty) {
      return _EmptyBox(
        tokens: tokens,
        text: l10n.memberInvoicesEmptyTitle,
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  l10n.memberInvoiceDescription,
                  style: t.bodySmall.copyWith(
                    color: c.muted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                width: 36.0,
                child: Text(
                  l10n.memberInvoiceQty,
                  textAlign: TextAlign.center,
                  style: t.bodySmall.copyWith(
                    color: c.muted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                width: 70.0,
                child: Text(
                  l10n.memberInvoiceUnitPrice,
                  textAlign: TextAlign.end,
                  style: t.bodySmall.copyWith(
                    color: c.muted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                width: 70.0,
                child: Text(
                  l10n.memberInvoiceTotal,
                  textAlign: TextAlign.end,
                  style: t.bodySmall.copyWith(
                    color: c.muted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(color: c.border.withValues(alpha: 0.15), height: 1.0),
        for (final item in items) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.itemName,
                        style: t.bodyMedium.copyWith(
                          color: c.label,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (item.description != null &&
                          item.description!.trim().isNotEmpty)
                        Text(
                          item.description!,
                          style: t.bodySmall.copyWith(color: c.muted),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 36.0,
                  child: Text(
                    item.qty.toString(),
                    textAlign: TextAlign.center,
                    style: t.bodyMedium.copyWith(color: c.label),
                  ),
                ),
                SizedBox(
                  width: 70.0,
                  child: Text(
                    money.format(item.unitPrice),
                    textAlign: TextAlign.end,
                    style: t.bodyMedium.copyWith(color: c.label),
                  ),
                ),
                SizedBox(
                  width: 70.0,
                  child: Text(
                    money.format(item.lineTotal),
                    textAlign: TextAlign.end,
                    style: t.bodyMedium.copyWith(
                      color: c.label,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(color: c.border.withValues(alpha: 0.08), height: 1.0),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Payment row
// ─────────────────────────────────────────────────────────────────────────────

class _PaymentRow extends StatelessWidget {
  final MemberInvoicePaymentEntity payment;
  final dynamic tokens;
  final AppLocalizations l10n;
  final NumberFormat money;
  final String localeName;

  const _PaymentRow({
    required this.payment,
    required this.tokens,
    required this.l10n,
    required this.money,
    required this.localeName,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    final t = tokens.typography;
    final statusColor = _paymentStatusColor(payment.status, c);

    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: c.background,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: c.border.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          MemberInvoiceBadge(
            text: payment.method == null
                ? l10n.memberInvoicesPaymentOther
                : _paymentMethodLabel(payment.method!, l10n),
            color: c.primary,
            tokens: tokens,
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MemberInvoiceBadge(
                  text: _paymentStatusLabel(payment.status, l10n),
                  color: statusColor,
                  tokens: tokens,
                ),
                if (payment.paidAt != null &&
                    payment.paidAt!.trim().isNotEmpty) ...[
                  const SizedBox(height: 4.0),
                  Text(
                    _formatDateTime(payment.paidAt!, localeName),
                    style: t.bodySmall.copyWith(color: c.muted),
                  ),
                ],
                if (payment.notes != null && payment.notes!.trim().isNotEmpty)
                  Text(
                    payment.notes!,
                    style: t.bodySmall.copyWith(color: c.muted),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8.0),
          Text(
            money.format(payment.amount),
            style: t.bodyMedium.copyWith(
              color: c.success,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Small widgets
// ─────────────────────────────────────────────────────────────────────────────

class _MetaBlock extends StatelessWidget {
  final String label;
  final String value;
  final dynamic tokens;
  final TextAlign align;

  const _MetaBlock({
    required this.label,
    required this.value,
    required this.tokens,
    this.align = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    final t = tokens.typography;

    return Column(
      crossAxisAlignment: align == TextAlign.end
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: t.bodySmall.copyWith(
            color: c.muted,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2.0),
        Text(
          value,
          textAlign: align,
          style: t.bodyMedium.copyWith(
            color: c.label,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final dynamic tokens;
  final bool bold;
  final Color? valueColor;

  const _TotalRow({
    required this.label,
    required this.value,
    required this.tokens,
    this.bold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    final t = tokens.typography;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: t.bodyMedium.copyWith(
                color: c.muted,
                fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: t.bodyMedium.copyWith(
              color: valueColor ?? c.label,
              fontWeight: bold ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyBox extends StatelessWidget {
  final dynamic tokens;
  final String text;

  const _EmptyBox({
    required this.tokens,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: c.background,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: c.border.withValues(alpha: 0.12)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: tokens.typography.bodyMedium.copyWith(
          color: c.muted,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Colors + labels
// ─────────────────────────────────────────────────────────────────────────────

Color _statusColor(String status, dynamic c) {
  switch (status.toLowerCase()) {
    case 'paid':
      return c.success;
    case 'refunded':
      return c.primary;
    case 'cancelled':
    case 'overdue':
      return c.danger;
    case 'pending':
      return c.primary;
    default:
      return c.muted;
  }
}

Color _paymentStatusColor(String status, dynamic c) {
  switch (status.toLowerCase()) {
    case 'completed':
      return c.success;
    case 'refunded':
      return c.primary;
    case 'failed':
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
    default:
      return l10n.memberInvoicesStatusUnknown;
  }
}

String _paymentStatusLabel(String status, AppLocalizations l10n) {
  switch (status.toLowerCase()) {
    case 'completed':
      return l10n.memberInvoicesStatusPaid;
    case 'pending':
      return l10n.memberInvoicesStatusPending;
    case 'refunded':
      return l10n.memberInvoicesStatusRefunded;
    case 'failed':
      return l10n.memberInvoicesStatusFailed;
    default:
      return l10n.memberInvoicesStatusUnknown;
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

String _formatDateTime(String rawDate, String localeName) {
  try {
    return DateFormat.yMMMd(localeName)
        .add_Hm()
        .format(DateTime.parse(rawDate));
  } catch (_) {
    return rawDate;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PDF builder
// ─────────────────────────────────────────────────────────────────────────────

pw.Document _buildMemberInvoicePdf({
  required MemberInvoiceEntity invoice,
  required AppLocalizations l10n,
  required String localeName,
}) {
  final pdf = pw.Document();
  final money = NumberFormat('#,##0.00', localeName);

  const headerBg = PdfColors.blue900;
  const accentColor = PdfColors.blue700;
  const mutedColor = PdfColors.grey600;
  const dividerColor = PdfColors.grey300;

  pdf.addPage(
    pw.MultiPage(
      pageTheme: pw.PageTheme(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36.0),
      ),
      build: (_) => [
        // Header
        pw.Container(
          padding: const pw.EdgeInsets.all(20.0),
          decoration: pw.BoxDecoration(
            color: headerBg,
            borderRadius: const pw.BorderRadius.all(
              pw.Radius.circular(8.0),
            ),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    l10n.memberInvoicePdfTitle,
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 22.0,
                      fontWeight: pw.FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                  if (invoice.branchName != null &&
                      invoice.branchName!.trim().isNotEmpty)
                    pw.Text(
                      invoice.branchName!,
                      style: const pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 10.0,
                      ),
                    ),
                  if (invoice.branchAddress != null &&
                      invoice.branchAddress!.trim().isNotEmpty)
                    pw.Text(
                      invoice.branchAddress!,
                      style: const pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 10.0,
                      ),
                    ),
                  if (invoice.branchPhone != null &&
                      invoice.branchPhone!.trim().isNotEmpty)
                    pw.Text(
                      invoice.branchPhone!,
                      style: const pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 10.0,
                      ),
                    ),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    invoice.invoiceNumber,
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 11.0,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 6.0),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 3.0,
                    ),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.white,
                      borderRadius: const pw.BorderRadius.all(
                        pw.Radius.circular(4.0),
                      ),
                    ),
                    child: pw.Text(
                      _statusLabel(invoice.status, l10n),
                      style: pw.TextStyle(
                        color: accentColor,
                        fontSize: 9.0,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        pw.SizedBox(height: 20.0),

        // Meta
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            _pdfMetaBlock(
              label: l10n.memberInvoiceInvoiceNumber,
              value: invoice.invoiceNumber,
            ),
            _pdfMetaBlock(
              label: l10n.memberInvoicesDate,
              value: _formatDate(invoice.invoiceDate, localeName),
              alignEnd: true,
            ),
          ],
        ),

        pw.SizedBox(height: 16.0),
        pw.Divider(color: dividerColor, thickness: 0.5),
        pw.SizedBox(height: 12.0),

        // Items
        pw.Text(
          l10n.memberInvoiceItems,
          style: pw.TextStyle(
            color: mutedColor,
            fontSize: 9.0,
            fontWeight: pw.FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        pw.SizedBox(height: 8.0),

        _pdfItemsTable(
          invoice: invoice,
          l10n: l10n,
          money: money,
        ),

        pw.SizedBox(height: 14.0),

        // Totals
        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.SizedBox(
            width: 230.0,
            child: pw.Column(
              children: [
                _pdfTotalRow(
                  l10n.memberInvoiceSubtotal,
                  money.format(invoice.subtotal),
                  mutedColor,
                ),
                if (invoice.discountAmount > 0)
                  _pdfTotalRow(
                    l10n.memberInvoiceDiscount,
                    money.format(invoice.discountAmount),
                    mutedColor,
                  ),
                if (invoice.taxAmount > 0)
                  _pdfTotalRow(
                    l10n.memberInvoiceTax,
                    money.format(invoice.taxAmount),
                    mutedColor,
                  ),
                pw.Divider(color: dividerColor, thickness: 0.5),
                _pdfTotalRow(
                  l10n.memberInvoiceTotal,
                  money.format(invoice.totalAmount),
                  PdfColors.black,
                  bold: true,
                ),
                _pdfTotalRow(
                  l10n.memberInvoicesPaid,
                  money.format(invoice.paidAmount),
                  PdfColors.green700,
                ),
                if (invoice.dueAmount > 0)
                  _pdfTotalRow(
                    l10n.memberInvoicesDue,
                    money.format(invoice.dueAmount),
                    PdfColors.red700,
                    bold: true,
                  ),
              ],
            ),
          ),
        ),

        // Payments
        if (invoice.payments.isNotEmpty) ...[
          pw.SizedBox(height: 20.0),
          pw.Divider(color: dividerColor, thickness: 0.5),
          pw.SizedBox(height: 8.0),
          pw.Text(
            l10n.memberInvoicePayments,
            style: pw.TextStyle(
              color: mutedColor,
              fontSize: 9.0,
              fontWeight: pw.FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          pw.SizedBox(height: 6.0),
          for (final payment in invoice.payments)
            _pdfPaymentRow(
              payment: payment,
              l10n: l10n,
              money: money,
              localeName: localeName,
            ),
        ],

        // Footer
        pw.SizedBox(height: 24.0),
        pw.Divider(color: dividerColor, thickness: 0.5),
        pw.SizedBox(height: 6.0),
        pw.Center(
          child: pw.Text(
            l10n.memberInvoicePdfFooter,
            style: const pw.TextStyle(
              color: PdfColors.grey600,
              fontSize: 10.0,
            ),
          ),
        ),
      ],
    ),
  );

  return pdf;
}

pw.Widget _pdfMetaBlock({
  required String label,
  required String value,
  bool alignEnd = false,
}) {
  return pw.Column(
    crossAxisAlignment:
    alignEnd ? pw.CrossAxisAlignment.end : pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        label,
        style: pw.TextStyle(
          color: PdfColors.grey600,
          fontSize: 9.0,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
      pw.Text(
        value,
        style: pw.TextStyle(
          fontSize: 11.0,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    ],
  );
}

pw.Widget _pdfItemsTable({
  required MemberInvoiceEntity invoice,
  required AppLocalizations l10n,
  required NumberFormat money,
}) {
  return pw.Column(
    children: [
      pw.Container(
        color: PdfColors.grey200,
        padding: const pw.EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 6.0,
        ),
        child: pw.Row(
          children: [
            pw.Expanded(
              flex: 4,
              child: pw.Text(
                l10n.memberInvoiceDescription,
                style: pw.TextStyle(
                  fontSize: 9.0,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(
              width: 30.0,
              child: pw.Text(
                l10n.memberInvoiceQty,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 9.0,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(
              width: 60.0,
              child: pw.Text(
                l10n.memberInvoiceUnitPrice,
                textAlign: pw.TextAlign.right,
                style: pw.TextStyle(
                  fontSize: 9.0,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(
              width: 60.0,
              child: pw.Text(
                l10n.memberInvoiceTotal,
                textAlign: pw.TextAlign.right,
                style: pw.TextStyle(
                  fontSize: 9.0,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      for (final item in invoice.items)
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 8.0,
          ),
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(
                color: PdfColors.grey200,
                width: 0.5,
              ),
            ),
          ),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                flex: 4,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      item.itemName,
                      style: pw.TextStyle(
                        fontSize: 10.0,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    if (item.description != null &&
                        item.description!.trim().isNotEmpty)
                      pw.Text(
                        item.description!,
                        style: const pw.TextStyle(
                          color: PdfColors.grey600,
                          fontSize: 9.0,
                        ),
                      ),
                  ],
                ),
              ),
              pw.SizedBox(
                width: 30.0,
                child: pw.Text(
                  item.qty.toString(),
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(fontSize: 10.0),
                ),
              ),
              pw.SizedBox(
                width: 60.0,
                child: pw.Text(
                  money.format(item.unitPrice),
                  textAlign: pw.TextAlign.right,
                  style: const pw.TextStyle(fontSize: 10.0),
                ),
              ),
              pw.SizedBox(
                width: 60.0,
                child: pw.Text(
                  money.format(item.lineTotal),
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(
                    fontSize: 10.0,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
    ],
  );
}

pw.Widget _pdfPaymentRow({
  required MemberInvoicePaymentEntity payment,
  required AppLocalizations l10n,
  required NumberFormat money,
  required String localeName,
}) {
  return pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 6.0),
    padding: const pw.EdgeInsets.all(8.0),
    decoration: pw.BoxDecoration(
      color: PdfColors.grey100,
      borderRadius: const pw.BorderRadius.all(
        pw.Radius.circular(4.0),
      ),
    ),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Row(
          children: [
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 6.0,
                vertical: 2.0,
              ),
              decoration: pw.BoxDecoration(
                color: PdfColors.blue700,
                borderRadius: const pw.BorderRadius.all(
                  pw.Radius.circular(3.0),
                ),
              ),
              child: pw.Text(
                payment.method == null
                    ? l10n.memberInvoicesPaymentOther
                    : _paymentMethodLabel(payment.method!, l10n),
                style: const pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 8.0,
                ),
              ),
            ),
            pw.SizedBox(width: 8.0),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  _paymentStatusLabel(payment.status, l10n),
                  style: const pw.TextStyle(
                    color: PdfColors.grey600,
                    fontSize: 8.0,
                  ),
                ),
                if (payment.paidAt != null &&
                    payment.paidAt!.trim().isNotEmpty)
                  pw.Text(
                    _formatDateTime(payment.paidAt!, localeName),
                    style: const pw.TextStyle(
                      color: PdfColors.grey600,
                      fontSize: 8.0,
                    ),
                  ),
              ],
            ),
          ],
        ),
        pw.Text(
          money.format(payment.amount),
          style: pw.TextStyle(
            color: PdfColors.green700,
            fontSize: 11.0,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

pw.Widget _pdfTotalRow(
    String label,
    String value,
    PdfColor valueColor, {
      bool bold = false,
    }) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2.0),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 10.0,
            color: PdfColors.grey700,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: bold ? 11.0 : 10.0,
            color: valueColor,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}