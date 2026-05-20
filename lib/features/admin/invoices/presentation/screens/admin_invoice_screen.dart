import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../../AppBar/presentation/admin_app_bar.dart';
import '../../../navigation/presentation/widgets/admin_navigation_drawer.dart';
import '../../domain/entities/admin_invoice_entity.dart';
import '../bloc/admin_invoice_bloc.dart';

class AdminInvoiceScreen extends StatefulWidget {
  final int invoiceId;

  const AdminInvoiceScreen({super.key, required this.invoiceId});

  @override
  State<AdminInvoiceScreen> createState() => _AdminInvoiceScreenState();
}

class _AdminInvoiceScreenState extends State<AdminInvoiceScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminInvoiceBloc>().add(LoadInvoiceEvent(widget.invoiceId));
  }

  @override
  Widget build(BuildContext context) {
    final tokens  = context.read<ThemeCubit>().state.tokens;
    final c       = tokens.colors;
    final profile = context.watch<AdminProfileCubit>().state;

    return Scaffold(
      backgroundColor: c.background,
      drawer: SafeArea(
        child: AdminNavigationDrawer(
          gymName:         profile.gymName,
          branchName:      profile.branchName,
          adminName:       profile.adminName,
          adminEmail:      profile.adminEmail,
          avatarUrl:       profile.avatarUrl,
          initialActiveId: 'invoices',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            AdminAppBar(title: 'Invoice'),
            Expanded(
              child: BlocBuilder<AdminInvoiceBloc, AdminInvoiceState>(
                builder: (ctx, state) {
                  if (state is AdminInvoiceLoading) {
                    return Center(
                        child: CircularProgressIndicator(color: c.primary));
                  }
                  if (state is AdminInvoiceError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.error_outline, color: c.danger, size: 48),
                            const SizedBox(height: 12),
                            Text(state.message,
                                textAlign: TextAlign.center,
                                style: tokens.typography.bodyMedium
                                    .copyWith(color: c.danger)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => ctx
                                  .read<AdminInvoiceBloc>()
                                  .add(LoadInvoiceEvent(widget.invoiceId)),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (state is AdminInvoiceLoaded) {
                    return _InvoiceView(
                      invoice: state.invoice,
                      gymName: profile.gymName,
                      tokens:  tokens,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Invoice view ───────────────────────────────────────────────────────────────

class _InvoiceView extends StatelessWidget {
  final AdminInvoiceEntity invoice;
  final String             gymName;
  final dynamic            tokens;

  const _InvoiceView({
    required this.invoice,
    required this.gymName,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    final t = tokens.typography;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InvoiceCard(invoice: invoice, gymName: gymName, tokens: tokens),
            ],
          ),
        ),
        Positioned(
          bottom: 24,
          left: 16,
          right: 16,
          child: SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () => _downloadPdf(context, invoice, gymName, c, t),
              icon: const Icon(Icons.picture_as_pdf_outlined, size: 20),
              label: Text(
                'Download / Share PDF',
                style: t.bodyMedium.copyWith(
                    color: c.onPrimary, fontWeight: FontWeight.w800),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: c.primary,
                foregroundColor: c.onPrimary,
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _downloadPdf(
    BuildContext context,
    AdminInvoiceEntity invoice,
    String gymName,
    dynamic c,
    dynamic t,
  ) async {
    final pdf = _buildPdf(invoice, gymName);
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'Invoice-${invoice.invoiceNumber}',
    );
  }
}

// ── Invoice card ───────────────────────────────────────────────────────────────

class _InvoiceCard extends StatelessWidget {
  final AdminInvoiceEntity invoice;
  final String             gymName;
  final dynamic            tokens;

  const _InvoiceCard({
    required this.invoice,
    required this.gymName,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    final c   = tokens.colors;
    final t   = tokens.typography;
    final fmt = NumberFormat('#,##0.00');
    final statusColor = _statusColor(invoice.status, c);

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.border.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
              color: c.label.withValues(alpha: 0.06),
              blurRadius: 14,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header banner ──────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: c.primary.withValues(alpha: 0.08),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gymName.toUpperCase(),
                        style: t.headlineSmall.copyWith(
                          color: c.primary,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ),
                      if (invoice.branchName != null) ...[
                        const SizedBox(height: 4),
                        Text(invoice.branchName!,
                            style: t.bodySmall.copyWith(color: c.muted)),
                      ],
                      if (invoice.branchAddress != null)
                        Text(invoice.branchAddress!,
                            style: t.bodySmall.copyWith(color: c.muted)),
                      if (invoice.branchPhone != null)
                        Text(invoice.branchPhone!,
                            style: t.bodySmall.copyWith(color: c.muted)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'INVOICE',
                      style: t.headlineSmall.copyWith(
                        color: c.label,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        invoice.status.toUpperCase(),
                        style: t.bodySmall.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Invoice meta ─────────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                        child: _MetaBlock(
                            label: 'Invoice No.',
                            value: invoice.invoiceNumber,
                            tokens: tokens)),
                    Expanded(
                        child: _MetaBlock(
                            label: 'Date',
                            value: _formatDate(invoice.invoiceDate),
                            tokens: tokens,
                            align: TextAlign.end)),
                  ],
                ),

                const SizedBox(height: 20),
                Divider(color: c.border.withValues(alpha: 0.15), height: 1),
                const SizedBox(height: 20),

                // ── Bill To ──────────────────────────────────────────────────
                if (invoice.member != null) ...[
                  Text('BILL TO',
                      style: t.bodySmall.copyWith(
                          color: c.muted,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8)),
                  const SizedBox(height: 6),
                  Text(invoice.member!.name,
                      style: t.titleMedium.copyWith(
                          color: c.label, fontWeight: FontWeight.w800)),
                  Text(invoice.member!.email,
                      style: t.bodySmall.copyWith(color: c.muted)),
                  if (invoice.member!.phone != null)
                    Text(invoice.member!.phone!,
                        style: t.bodySmall.copyWith(color: c.muted)),
                  const SizedBox(height: 20),
                  Divider(
                      color: c.border.withValues(alpha: 0.15), height: 1),
                  const SizedBox(height: 20),
                ],

                // ── Items table ──────────────────────────────────────────────
                Text('ITEMS',
                    style: t.bodySmall.copyWith(
                        color: c.muted,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8)),
                const SizedBox(height: 10),
                _itemsTable(invoice.items, c, t, fmt),

                const SizedBox(height: 20),
                Divider(color: c.border.withValues(alpha: 0.15), height: 1),
                const SizedBox(height: 12),

                // ── Totals ───────────────────────────────────────────────────
                _TotalRow(
                    label: 'Subtotal',
                    value: '\$ ${fmt.format(invoice.subtotal)}',
                    tokens: tokens),
                if (invoice.discountAmount > 0)
                  _TotalRow(
                      label: 'Discount',
                      value: '- \$ ${fmt.format(invoice.discountAmount)}',
                      tokens: tokens,
                      valueColor: c.success),
                if (invoice.taxAmount > 0)
                  _TotalRow(
                      label: 'Tax',
                      value: '\$ ${fmt.format(invoice.taxAmount)}',
                      tokens: tokens),
                const SizedBox(height: 6),
                Divider(color: c.border.withValues(alpha: 0.15), height: 1),
                const SizedBox(height: 6),
                _TotalRow(
                    label: 'TOTAL',
                    value: '\$ ${fmt.format(invoice.totalAmount)}',
                    tokens: tokens,
                    bold: true),
                _TotalRow(
                    label: 'Paid',
                    value: '\$ ${fmt.format(invoice.paidAmount)}',
                    tokens: tokens,
                    valueColor: c.success),
                if (invoice.dueAmount > 0)
                  _TotalRow(
                      label: 'Balance Due',
                      value: '\$ ${fmt.format(invoice.dueAmount)}',
                      tokens: tokens,
                      bold: true,
                      valueColor: c.danger),

                // ── Payment details ──────────────────────────────────────────
                if (invoice.payments.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Divider(
                      color: c.border.withValues(alpha: 0.15), height: 1),
                  const SizedBox(height: 12),
                  Text('PAYMENT DETAILS',
                      style: t.bodySmall.copyWith(
                          color: c.muted,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8)),
                  const SizedBox(height: 10),
                  for (final p in invoice.payments)
                    _PaymentRow(payment: p, tokens: tokens, fmt: fmt),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemsTable(
    List<AdminInvoiceItemEntity> items,
    dynamic c,
    dynamic t,
    NumberFormat fmt,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Expanded(
                  flex: 4,
                  child: Text('Description',
                      style: t.bodySmall.copyWith(
                          color: c.muted, fontWeight: FontWeight.w700))),
              SizedBox(
                  width: 36,
                  child: Text('Qty',
                      textAlign: TextAlign.center,
                      style: t.bodySmall.copyWith(
                          color: c.muted, fontWeight: FontWeight.w700))),
              SizedBox(
                  width: 70,
                  child: Text('Price',
                      textAlign: TextAlign.end,
                      style: t.bodySmall.copyWith(
                          color: c.muted, fontWeight: FontWeight.w700))),
              SizedBox(
                  width: 70,
                  child: Text('Total',
                      textAlign: TextAlign.end,
                      style: t.bodySmall.copyWith(
                          color: c.muted, fontWeight: FontWeight.w700))),
            ],
          ),
        ),
        Divider(color: c.border.withValues(alpha: 0.15), height: 1),
        for (final item in items) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.itemName,
                          style: t.bodyMedium.copyWith(
                              color: c.label, fontWeight: FontWeight.w700)),
                      if (item.description != null)
                        Text(item.description!,
                            style: t.bodySmall.copyWith(color: c.muted)),
                    ],
                  ),
                ),
                SizedBox(
                    width: 36,
                    child: Text('${item.qty}',
                        textAlign: TextAlign.center,
                        style: t.bodyMedium.copyWith(color: c.label))),
                SizedBox(
                    width: 70,
                    child: Text('\$ ${fmt.format(item.unitPrice)}',
                        textAlign: TextAlign.end,
                        style: t.bodyMedium.copyWith(color: c.label))),
                SizedBox(
                    width: 70,
                    child: Text('\$ ${fmt.format(item.lineTotal)}',
                        textAlign: TextAlign.end,
                        style: t.bodyMedium.copyWith(
                            color: c.label, fontWeight: FontWeight.w700))),
              ],
            ),
          ),
          Divider(color: c.border.withValues(alpha: 0.08), height: 1),
        ],
      ],
    );
  }

  Color _statusColor(String status, dynamic c) {
    switch (status.toLowerCase()) {
      case 'paid':      return c.success;
      case 'partial':   return c.warning ?? Colors.orange;
      case 'overdue':
      case 'cancelled': return c.danger;
      default:          return c.muted;
    }
  }

  String _formatDate(String raw) {
    try {
      return DateFormat('MMM dd, yyyy').format(DateTime.parse(raw));
    } catch (_) {
      return raw;
    }
  }
}

// ── Supporting widgets ─────────────────────────────────────────────────────────

class _MetaBlock extends StatelessWidget {
  final String    label;
  final String    value;
  final dynamic   tokens;
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
        Text(label,
            style: t.bodySmall
                .copyWith(color: c.muted, fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(value,
            textAlign: align,
            style: t.bodyMedium
                .copyWith(color: c.label, fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String  label;
  final String  value;
  final dynamic tokens;
  final bool    bold;
  final Color?  valueColor;

  const _TotalRow({
    required this.label,
    required this.value,
    required this.tokens,
    this.bold       = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    final t = tokens.typography;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: t.bodyMedium.copyWith(
                    color: c.muted,
                    fontWeight: bold ? FontWeight.w800 : FontWeight.w500)),
          ),
          Text(value,
              style: t.bodyMedium.copyWith(
                  color: valueColor ?? c.label,
                  fontWeight: bold ? FontWeight.w900 : FontWeight.w700)),
        ],
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  final AdminInvoicePaymentEntity payment;
  final dynamic                   tokens;
  final NumberFormat              fmt;

  const _PaymentRow(
      {required this.payment, required this.tokens, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    final t = tokens.typography;

    String paidAt = '';
    if (payment.paidAt != null) {
      try {
        paidAt = DateFormat('MMM dd, yyyy  HH:mm')
            .format(DateTime.parse(payment.paidAt!));
      } catch (_) {
        paidAt = payment.paidAt!;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: c.border.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: c.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              payment.method,
              style: t.bodySmall
                  .copyWith(color: c.primary, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (paidAt.isNotEmpty)
                  Text(paidAt, style: t.bodySmall.copyWith(color: c.muted)),
                if (payment.receivedBy != null)
                  Text('Received by: ${payment.receivedBy}',
                      style: t.bodySmall.copyWith(color: c.muted)),
              ],
            ),
          ),
          Text('\$ ${fmt.format(payment.amount)}',
              style: t.bodyMedium.copyWith(
                  color: c.success, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

// ── PDF builder ────────────────────────────────────────────────────────────────

pw.Document _buildPdf(AdminInvoiceEntity invoice, String gymName) {
  final pdf = pw.Document();
  final fmt = NumberFormat('#,##0.00');

  String fmtDate(String raw) {
    try {
      return DateFormat('MMM dd, yyyy').format(DateTime.parse(raw));
    } catch (_) {
      return raw;
    }
  }

  String fmtDateTime(String? raw) {
    if (raw == null) return '';
    try {
      return DateFormat('MMM dd, yyyy  HH:mm').format(DateTime.parse(raw));
    } catch (_) {
      return raw;
    }
  }

  const headerBg     = PdfColors.blue900;
  const accentColor  = PdfColors.blue700;
  const mutedColor   = PdfColors.grey600;
  const dividerColor = PdfColors.grey300;

  pdf.addPage(
    pw.MultiPage(
      pageTheme: pw.PageTheme(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
      ),
      build: (ctx) => [
        // ── Header ─────────────────────────────────────────────────────────
        pw.Container(
          padding: const pw.EdgeInsets.all(20),
          decoration: pw.BoxDecoration(
            color: headerBg,
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(gymName.toUpperCase(),
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      )),
                  if (invoice.branchName != null)
                    pw.Text(invoice.branchName!,
                        style: pw.TextStyle(
                            color: PdfColor.fromInt(0xB3FFFFFF), fontSize: 10)),
                  if (invoice.branchAddress != null)
                    pw.Text(invoice.branchAddress!,
                        style: pw.TextStyle(
                            color: PdfColor.fromInt(0xB3FFFFFF), fontSize: 10)),
                  if (invoice.branchPhone != null)
                    pw.Text(invoice.branchPhone!,
                        style: pw.TextStyle(
                            color: PdfColor.fromInt(0xB3FFFFFF), fontSize: 10)),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('INVOICE',
                      style: pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                          letterSpacing: 3.0)),
                  pw.SizedBox(height: 6),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.white,
                      borderRadius:
                          const pw.BorderRadius.all(pw.Radius.circular(4)),
                    ),
                    child: pw.Text(
                      invoice.status.toUpperCase(),
                      style: pw.TextStyle(
                          color: accentColor,
                          fontSize: 9,
                          fontWeight: pw.FontWeight.bold,
                          letterSpacing: 1.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        pw.SizedBox(height: 20),

        // ── Meta row ───────────────────────────────────────────────────────
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Invoice No.',
                    style: pw.TextStyle(
                        color: mutedColor,
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold)),
                pw.Text(invoice.invoiceNumber,
                    style: pw.TextStyle(
                        fontSize: 11, fontWeight: pw.FontWeight.bold)),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text('Date',
                    style: pw.TextStyle(
                        color: mutedColor,
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold)),
                pw.Text(fmtDate(invoice.invoiceDate),
                    style: pw.TextStyle(
                        fontSize: 11, fontWeight: pw.FontWeight.bold)),
              ],
            ),
          ],
        ),

        pw.SizedBox(height: 16),
        pw.Divider(color: dividerColor, thickness: 0.5),
        pw.SizedBox(height: 12),

        // ── Bill To ────────────────────────────────────────────────────────
        if (invoice.member != null) ...[
          pw.Text('BILL TO',
              style: pw.TextStyle(
                  color: mutedColor,
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                  letterSpacing: 1.0)),
          pw.SizedBox(height: 4),
          pw.Text(invoice.member!.name,
              style:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.Text(invoice.member!.email,
              style:
                  const pw.TextStyle(color: PdfColors.grey700, fontSize: 10)),
          if (invoice.member!.phone != null)
            pw.Text(invoice.member!.phone!,
                style: const pw.TextStyle(
                    color: PdfColors.grey700, fontSize: 10)),
          pw.SizedBox(height: 16),
          pw.Divider(color: dividerColor, thickness: 0.5),
          pw.SizedBox(height: 12),
        ],

        // ── Items table header ─────────────────────────────────────────────
        pw.Container(
          color: PdfColors.grey200,
          padding:
              const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: pw.Row(children: [
            pw.Expanded(
              flex: 4,
              child: pw.Text('Description',
                  style: pw.TextStyle(
                      fontSize: 9, fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(
              width: 30,
              child: pw.Text('Qty',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontSize: 9, fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(
              width: 60,
              child: pw.Text('Unit Price',
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(
                      fontSize: 9, fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(
              width: 60,
              child: pw.Text('Total',
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(
                      fontSize: 9, fontWeight: pw.FontWeight.bold)),
            ),
          ]),
        ),

        // ── Items rows ─────────────────────────────────────────────────────
        for (final item in invoice.items) ...[
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                  bottom: pw.BorderSide(
                      color: PdfColors.grey200, width: 0.5)),
            ),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 4,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(item.itemName,
                          style: pw.TextStyle(
                              fontSize: 10, fontWeight: pw.FontWeight.bold)),
                      if (item.description != null)
                        pw.Text(item.description!,
                            style: const pw.TextStyle(
                                color: PdfColors.grey600, fontSize: 9)),
                    ],
                  ),
                ),
                pw.SizedBox(
                  width: 30,
                  child: pw.Text('${item.qty}',
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 10)),
                ),
                pw.SizedBox(
                  width: 60,
                  child: pw.Text('\$ ${fmt.format(item.unitPrice)}',
                      textAlign: pw.TextAlign.right,
                      style: const pw.TextStyle(fontSize: 10)),
                ),
                pw.SizedBox(
                  width: 60,
                  child: pw.Text('\$ ${fmt.format(item.lineTotal)}',
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(
                          fontSize: 10, fontWeight: pw.FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],

        pw.SizedBox(height: 12),

        // ── Totals ─────────────────────────────────────────────────────────
        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.SizedBox(
            width: 220,
            child: pw.Column(children: [
              _pdfTotalRow('Subtotal',
                  '\$ ${fmt.format(invoice.subtotal)}', mutedColor),
              if (invoice.discountAmount > 0)
                _pdfTotalRow('Discount',
                    '- \$ ${fmt.format(invoice.discountAmount)}', mutedColor),
              if (invoice.taxAmount > 0)
                _pdfTotalRow(
                    'Tax', '\$ ${fmt.format(invoice.taxAmount)}', mutedColor),
              pw.Divider(color: dividerColor, thickness: 0.5),
              _pdfTotalRow('TOTAL',
                  '\$ ${fmt.format(invoice.totalAmount)}', PdfColors.black,
                  bold: true),
              _pdfTotalRow('Paid',
                  '\$ ${fmt.format(invoice.paidAmount)}', PdfColors.green700),
              if (invoice.dueAmount > 0)
                _pdfTotalRow('Balance Due',
                    '\$ ${fmt.format(invoice.dueAmount)}', PdfColors.red700,
                    bold: true),
            ]),
          ),
        ),

        // ── Payment details ────────────────────────────────────────────────
        if (invoice.payments.isNotEmpty) ...[
          pw.SizedBox(height: 20),
          pw.Divider(color: dividerColor, thickness: 0.5),
          pw.SizedBox(height: 8),
          pw.Text('PAYMENT DETAILS',
              style: pw.TextStyle(
                  color: mutedColor,
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                  letterSpacing: 1.0)),
          pw.SizedBox(height: 6),
          for (final p in invoice.payments)
            pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 6),
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius:
                    const pw.BorderRadius.all(pw.Radius.circular(4)),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Row(children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: pw.BoxDecoration(
                        color: accentColor,
                        borderRadius:
                            const pw.BorderRadius.all(pw.Radius.circular(3)),
                      ),
                      child: pw.Text(p.method,
                          style: const pw.TextStyle(
                              color: PdfColors.white, fontSize: 8)),
                    ),
                    pw.SizedBox(width: 8),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        if (p.paidAt != null)
                          pw.Text(fmtDateTime(p.paidAt),
                              style: const pw.TextStyle(
                                  color: PdfColors.grey600, fontSize: 8)),
                        if (p.receivedBy != null)
                          pw.Text('Received by: ${p.receivedBy}',
                              style: const pw.TextStyle(
                                  color: PdfColors.grey600, fontSize: 8)),
                      ],
                    ),
                  ]),
                  pw.Text('\$ ${fmt.format(p.amount)}',
                      style: pw.TextStyle(
                          color: PdfColors.green700,
                          fontSize: 11,
                          fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ),
        ],

        // ── Footer ─────────────────────────────────────────────────────────
        pw.SizedBox(height: 24),
        pw.Divider(color: dividerColor, thickness: 0.5),
        pw.SizedBox(height: 6),
        pw.Center(
          child: pw.Text(
            'Thank you for your business!',
            style:
                const pw.TextStyle(color: PdfColors.grey600, fontSize: 10),
          ),
        ),
      ],
    ),
  );

  return pdf;
}

pw.Widget _pdfTotalRow(String label, String value, PdfColor valueColor,
    {bool bold = false}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label,
            style: pw.TextStyle(
                fontSize: 10,
                color: PdfColors.grey700,
                fontWeight:
                    bold ? pw.FontWeight.bold : pw.FontWeight.normal)),
        pw.Text(value,
            style: pw.TextStyle(
                fontSize: bold ? 11 : 10,
                color: valueColor,
                fontWeight:
                    bold ? pw.FontWeight.bold : pw.FontWeight.normal)),
      ],
    ),
  );
}
