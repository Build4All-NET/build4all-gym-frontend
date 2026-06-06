import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../domain/entities/member_invoice_entity.dart';
import '../bloc/member_invoice_bloc.dart';
import '../bloc/member_invoice_event.dart';
import '../bloc/member_invoice_state.dart';
import '../widgets/member_invoice_badge.dart';

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
    final pdf = await _buildMemberInvoicePdf(
      invoice: invoice,
      l10n: l10n,
      localeName: localeName,
    );

    final bytes = await pdf.save();

    final safeInvoiceNumber = invoice.invoiceNumber.replaceAll(
      RegExp(r'[^A-Za-z0-9_-]'),
      '_',
    );

    final fileName = 'Invoice-$safeInvoiceNumber.pdf';

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');

    await file.writeAsBytes(bytes, flush: true);

    await Share.shareXFiles(
      [
        XFile(
          file.path,
          mimeType: 'application/pdf',
          name: fileName,
        ),
      ],
      text: l10n.memberInvoicePdfTitle,
    );
  }
}

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
// PDF builder using downloaded Variable Font
// Clean fixed design for Arabic / English invoice PDF
// ─────────────────────────────────────────────────────────────────────────────

bool _containsArabic(String text) {
  return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
}

Future<pw.Document> _buildMemberInvoicePdf({
  required MemberInvoiceEntity invoice,
  required AppLocalizations l10n,
  required String localeName,
}) async {
  final isArabic = localeName.toLowerCase().startsWith('ar');

  final arabicFont = pw.Font.ttf(
    await rootBundle.load(
      'assets/fonts/NotoSansArabic-VariableFont_wdth,wght.ttf',
    ),
  );

  final pdf = pw.Document(
    theme: pw.ThemeData.withFont(
      base: arabicFont,
      bold: arabicFont,
    ),
  );

  final money = NumberFormat('#,##0.00', localeName);

  const primary = PdfColor.fromInt(0xFF0D47A1);
  const primarySoft = PdfColor.fromInt(0xFFEAF2FF);
  const muted = PdfColor.fromInt(0xFF666666);
  const line = PdfColor.fromInt(0xFFE5E7EB);
  const success = PdfColor.fromInt(0xFF15803D);
  const danger = PdfColor.fromInt(0xFFB91C1C);

  pw.TextDirection dir() {
    return isArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr;
  }

  pw.TextAlign alignStart() {
    return isArabic ? pw.TextAlign.right : pw.TextAlign.left;
  }

  pdf.addPage(
    pw.MultiPage(
      pageTheme: const pw.PageTheme(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
      ),
      build: (_) {
        return [
          pw.SizedBox(height: 18),

          pw.SizedBox(height: 18),

          // Meta row
          pw.Row(
            children: [
              pw.Expanded(
                child: _pdfInfoBox(
                  label: l10n.memberInvoiceInvoiceNumber,
                  value: invoice.invoiceNumber,
                  isArabic: isArabic,
                ),
              ),
              pw.SizedBox(width: 12),
              pw.Expanded(
                child: _pdfInfoBox(
                  label: l10n.memberInvoicesDate,
                  value: _formatDate(invoice.invoiceDate, localeName),
                  isArabic: isArabic,
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 18),

          _pdfSectionTitle(
            l10n.memberInvoiceItems,
            isArabic: isArabic,
          ),

          pw.SizedBox(height: 8),

          _pdfItemsTable(
            invoice: invoice,
            l10n: l10n,
            money: money,
            isArabic: isArabic,
          ),

          pw.SizedBox(height: 18),

          // Totals full width
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: primarySoft,
              borderRadius: pw.BorderRadius.circular(8),
              border: pw.Border.all(color: line),
            ),
            child: pw.Column(
              children: [
                _pdfTotalRow(
                  l10n.memberInvoiceSubtotal,
                  money.format(invoice.subtotal),
                  muted,
                  isArabic: isArabic,
                ),
                if (invoice.discountAmount > 0)
                  _pdfTotalRow(
                    l10n.memberInvoiceDiscount,
                    money.format(invoice.discountAmount),
                    success,
                    isArabic: isArabic,
                  ),
                if (invoice.taxAmount > 0)
                  _pdfTotalRow(
                    l10n.memberInvoiceTax,
                    money.format(invoice.taxAmount),
                    muted,
                    isArabic: isArabic,
                  ),
                pw.Divider(color: line),
                _pdfTotalRow(
                  l10n.memberInvoiceTotal,
                  money.format(invoice.totalAmount),
                  PdfColors.black,
                  isArabic: isArabic,
                  bold: true,
                ),
                _pdfTotalRow(
                  l10n.memberInvoicesPaid,
                  money.format(invoice.paidAmount),
                  success,
                  isArabic: isArabic,
                  bold: true,
                ),
                if (invoice.dueAmount > 0)
                  _pdfTotalRow(
                    l10n.memberInvoicesDue,
                    money.format(invoice.dueAmount),
                    danger,
                    isArabic: isArabic,
                    bold: true,
                  ),
              ],
            ),
          ),

          if (invoice.payments.isNotEmpty) ...[
            pw.SizedBox(height: 20),
            _pdfSectionTitle(
              l10n.memberInvoicePayments,
              isArabic: isArabic,
            ),
            pw.SizedBox(height: 8),
            for (final payment in invoice.payments)
              _pdfPaymentRow(
                payment: payment,
                l10n: l10n,
                money: money,
                localeName: localeName,
                isArabic: isArabic,
              ),
          ],

          pw.SizedBox(height: 24),
          pw.Divider(color: line),
          pw.SizedBox(height: 8),
          pw.Center(
            child: pw.Text(
              l10n.memberInvoicePdfFooter,
              textDirection: dir(),
              style: const pw.TextStyle(
                color: muted,
                fontSize: 10,
              ),
            ),
          ),
        ];
      },
    ),
  );

  return pdf;
}

pw.Widget _pdfSectionTitle(
    String title, {
      required bool isArabic,
    }) {
  return pw.Container(
    width: double.infinity,
    padding: const pw.EdgeInsets.symmetric(vertical: 4),
    child: pw.Text(
      title,
      textDirection: isArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr,
      textAlign: isArabic ? pw.TextAlign.right : pw.TextAlign.left,
      style: pw.TextStyle(
        color: PdfColors.grey700,
        fontSize: 11,
        fontWeight: pw.FontWeight.bold,
        letterSpacing: isArabic ? 0 : 0.6,
      ),
    ),
  );
}

pw.Widget _pdfInfoBox({
  required String label,
  required String value,
  required bool isArabic,
}) {
  final valueHasArabic = _containsArabic(value);

  return pw.Container(
    padding: const pw.EdgeInsets.all(10),
    decoration: pw.BoxDecoration(
      color: const PdfColor.fromInt(0xFFF8FAFC),
      borderRadius: pw.BorderRadius.circular(8),
      border: pw.Border.all(color: const PdfColor.fromInt(0xFFE5E7EB)),
    ),
    child: pw.Column(
      crossAxisAlignment:
      isArabic ? pw.CrossAxisAlignment.end : pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          textDirection:
          isArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr,
          textAlign: isArabic ? pw.TextAlign.right : pw.TextAlign.left,
          style: pw.TextStyle(
            color: PdfColors.grey600,
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 3),
        pw.Text(
          value,
          textDirection:
          valueHasArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr,
          textAlign: valueHasArabic ? pw.TextAlign.right : pw.TextAlign.left,
          style: pw.TextStyle(
            color: PdfColors.black,
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

pw.Widget _pdfItemsTable({
  required MemberInvoiceEntity invoice,
  required AppLocalizations l10n,
  required NumberFormat money,
  required bool isArabic,
}) {
  const borderColor = PdfColor.fromInt(0xFFE5E7EB);
  const headerBg = PdfColor.fromInt(0xFFF1F5F9);

  pw.TextDirection dir() {
    return isArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr;
  }

  pw.TextAlign startAlign() {
    return isArabic ? pw.TextAlign.right : pw.TextAlign.left;
  }

  return pw.Table(
    border: pw.TableBorder.all(
      color: borderColor,
      width: 0.5,
    ),
    columnWidths: const {
      0: pw.FlexColumnWidth(3.2),
      1: pw.FlexColumnWidth(0.8),
      2: pw.FlexColumnWidth(1.3),
      3: pw.FlexColumnWidth(1.3),
    },
    children: [
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: headerBg),
        children: [
          _pdfTableHeaderCell(
            l10n.memberInvoiceDescription,
            isArabic: isArabic,
            align: startAlign(),
          ),
          _pdfTableHeaderCell(
            l10n.memberInvoiceQty,
            isArabic: isArabic,
            align: pw.TextAlign.center,
          ),
          _pdfTableHeaderCell(
            l10n.memberInvoiceUnitPrice,
            isArabic: isArabic,
            align: pw.TextAlign.right,
          ),
          _pdfTableHeaderCell(
            l10n.memberInvoiceTotal,
            isArabic: isArabic,
            align: pw.TextAlign.right,
          ),
        ],
      ),
      for (final item in invoice.items)
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(7),
              child: pw.Column(
                crossAxisAlignment: isArabic
                    ? pw.CrossAxisAlignment.end
                    : pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    item.itemName,
                    textDirection:
                    _containsArabic(item.itemName) ? dir() : pw.TextDirection.ltr,
                    textAlign: _containsArabic(item.itemName)
                        ? startAlign()
                        : pw.TextAlign.left,
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  if (item.description != null &&
                      item.description!.trim().isNotEmpty) ...[
                    pw.SizedBox(height: 2),
                    pw.Text(
                      item.description!,
                      textDirection: _containsArabic(item.description!)
                          ? dir()
                          : pw.TextDirection.ltr,
                      textAlign: _containsArabic(item.description!)
                          ? startAlign()
                          : pw.TextAlign.left,
                      style: const pw.TextStyle(
                        fontSize: 8,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            _pdfTableCell(
              item.qty.toString(),
              isArabic: false,
              align: pw.TextAlign.center,
            ),
            _pdfTableCell(
              money.format(item.unitPrice),
              isArabic: false,
              align: pw.TextAlign.right,
            ),
            _pdfTableCell(
              money.format(item.lineTotal),
              isArabic: false,
              align: pw.TextAlign.right,
              bold: true,
            ),
          ],
        ),
    ],
  );
}

pw.Widget _pdfTableHeaderCell(
    String text, {
      required bool isArabic,
      required pw.TextAlign align,
    }) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(7),
    child: pw.Text(
      text,
      textDirection: isArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr,
      textAlign: align,
      style: pw.TextStyle(
        fontSize: 8.5,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.grey700,
      ),
    ),
  );
}

pw.Widget _pdfTableCell(
    String text, {
      required bool isArabic,
      required pw.TextAlign align,
      bool bold = false,
    }) {
  final textHasArabic = _containsArabic(text);

  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(
      horizontal: 9,
      vertical: 8,
    ),
    child: pw.Text(
      text,
      textDirection:
      textHasArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr,
      textAlign: align,
      style: pw.TextStyle(
        fontSize: 9,
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
      ),
    ),
  );

}
pw.Widget _pdfPaymentRow({
  required MemberInvoicePaymentEntity payment,
  required AppLocalizations l10n,
  required NumberFormat money,
  required String localeName,
  required bool isArabic,
}) {
  final method = payment.method == null
      ? l10n.memberInvoicesPaymentOther
      : _paymentMethodLabel(payment.method!, l10n);

  final statusText = _paymentStatusLabel(payment.status, l10n);

  final paidAtText = payment.paidAt != null &&
      payment.paidAt!.trim().isNotEmpty
      ? _formatDateTime(payment.paidAt!, localeName)
      : null;

  final amountText = money.format(payment.amount);

  return pw.Container(
    width: double.infinity,
    margin: const pw.EdgeInsets.only(bottom: 8),
    padding: const pw.EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 10,
    ),
    decoration: pw.BoxDecoration(
      color: const PdfColor.fromInt(0xFFF8FAFC),
      borderRadius: pw.BorderRadius.circular(6),
      border: pw.Border.all(
        color: const PdfColor.fromInt(0xFFE5E7EB),
      ),
    ),
    child: pw.Column(
      crossAxisAlignment:
      isArabic ? pw.CrossAxisAlignment.end : pw.CrossAxisAlignment.start,
      children: [
        // First line: date
        if (paidAtText != null) ...[
          pw.Text(
            paidAtText,
            textDirection: _containsArabic(paidAtText)
                ? pw.TextDirection.rtl
                : pw.TextDirection.ltr,
            textAlign:
            _containsArabic(paidAtText) ? pw.TextAlign.right : pw.TextAlign.left,
            style: const pw.TextStyle(
              color: PdfColors.grey600,
              fontSize: 8.5,
            ),
          ),
          pw.SizedBox(height: 7),
        ],

        // Second line: paid label + amount beside it
        pw.Row(
          children: [
            if (isArabic) ...[
              pw.Text(
                amountText,
                textDirection: pw.TextDirection.ltr,
                style: pw.TextStyle(
                  color: PdfColors.green700,
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(width: 8),
              pw.Expanded(
                child: pw.Text(
                  statusText,
                  textDirection: _containsArabic(statusText)
                      ? pw.TextDirection.rtl
                      : pw.TextDirection.ltr,
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(
                    color: PdfColors.grey700,
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(width: 8),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 3,
                ),
                decoration: pw.BoxDecoration(
                  color: const PdfColor.fromInt(0xFF0D47A1),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Text(
                  method,
                  textDirection: _containsArabic(method)
                      ? pw.TextDirection.rtl
                      : pw.TextDirection.ltr,
                  style: const pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 8,
                  ),
                ),
              ),
            ] else ...[
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 3,
                ),
                decoration: pw.BoxDecoration(
                  color: const PdfColor.fromInt(0xFF0D47A1),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Text(
                  method,
                  textDirection: _containsArabic(method)
                      ? pw.TextDirection.rtl
                      : pw.TextDirection.ltr,
                  style: const pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 8,
                  ),
                ),
              ),
              pw.SizedBox(width: 8),
              pw.Expanded(
                child: pw.Text(
                  statusText,
                  textDirection: _containsArabic(statusText)
                      ? pw.TextDirection.rtl
                      : pw.TextDirection.ltr,
                  textAlign: pw.TextAlign.left,
                  style: pw.TextStyle(
                    color: PdfColors.grey700,
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(width: 8),
              pw.Text(
                amountText,
                textDirection: pw.TextDirection.ltr,
                style: pw.TextStyle(
                  color: PdfColors.green700,
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ],
    ),
  );
}

pw.Widget _pdfTotalRow(
    String label,
    String value,
    PdfColor valueColor, {
      required bool isArabic,
      bool bold = false,
    }) {
  final labelHasArabic = _containsArabic(label);

  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 5),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        if (isArabic) ...[
          // Label on the right
          pw.Expanded(
            child: pw.Text(
              label,
              textDirection:
              labelHasArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr,
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(
                fontSize: bold ? 11 : 10,
                color: PdfColors.grey700,
                fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
              ),
            ),
          ),

          // Space between text and number
          pw.SizedBox(width: 18),

          // Value beside it on the left
          pw.Text(
            value,
            textDirection: pw.TextDirection.ltr,
            textAlign: pw.TextAlign.left,
            style: pw.TextStyle(
              fontSize: bold ? 11.5 : 10,
              color: valueColor,
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ] else ...[
          pw.Expanded(
            child: pw.Text(
              label,
              textDirection:
              labelHasArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr,
              textAlign: pw.TextAlign.left,
              style: pw.TextStyle(
                fontSize: bold ? 11 : 10,
                color: PdfColors.grey700,
                fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
              ),
            ),
          ),
          pw.SizedBox(width: 18),
          pw.Text(
            value,
            textDirection: pw.TextDirection.ltr,
            textAlign: pw.TextAlign.right,
            style: pw.TextStyle(
              fontSize: bold ? 11.5 : 10,
              color: valueColor,
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ],
    ),
  );

}