import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../../AppBar/presentation/admin_app_bar.dart';
import '../../../navigation/presentation/widgets/admin_navigation_drawer.dart';
import '../../domain/entities/admin_invoice_entity.dart';
import '../bloc/admin_invoices_list_bloc.dart';

class AdminInvoicesListScreen extends StatefulWidget {
  const AdminInvoicesListScreen({super.key});

  @override
  State<AdminInvoicesListScreen> createState() =>
      _AdminInvoicesListScreenState();
}

class _AdminInvoicesListScreenState extends State<AdminInvoicesListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminInvoicesListBloc>().add(LoadInvoicesListEvent());
  }

  @override
  Widget build(BuildContext context) {
    final tokens  = context.read<ThemeCubit>().state.tokens;
    final c       = tokens.colors;
    final l10n    = AppLocalizations.of(context)!;
    final profile = context.watch<AdminProfileCubit>().state;

    final statusFilters = [
      _StatusFilter(label: l10n.admin_invoices_filterAll,       status: null,        icon: Icons.receipt_long_outlined),
      _StatusFilter(label: l10n.admin_invoices_filterPaid,      status: 'paid',      icon: Icons.check_circle_outline),
      _StatusFilter(label: l10n.admin_invoices_filterPending,   status: 'pending',   icon: Icons.hourglass_top_rounded),
      _StatusFilter(label: l10n.admin_invoices_filterOverdue,   status: 'overdue',   icon: Icons.warning_amber_rounded),
      _StatusFilter(label: l10n.admin_invoices_filterCancelled, status: 'cancelled', icon: Icons.cancel_outlined),
    ];

    final typeFilters = [
      _TypeFilter(label: l10n.admin_invoices_typeAll,     type: null,    icon: Icons.all_inbox_outlined),
      _TypeFilter(label: l10n.admin_invoices_typePlans,   type: 'PLAN',  icon: Icons.card_membership_outlined),
      _TypeFilter(label: l10n.admin_invoices_typeClasses, type: 'CLASS', icon: Icons.fitness_center_outlined),
      _TypeFilter(label: l10n.admin_invoices_typePt,      type: 'PT',    icon: Icons.sports_outlined),
    ];

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
            AdminAppBar(title: l10n.navInvoices),
            BlocBuilder<AdminInvoicesListBloc, AdminInvoicesListState>(
              buildWhen: (prev, curr) => curr is AdminInvoicesListLoaded,
              builder: (ctx, state) {
                final selectedStatus = state is AdminInvoicesListLoaded ? state.selectedStatus : null;
                final selectedType   = state is AdminInvoicesListLoaded ? state.selectedType   : null;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FilterChipsRow(
                      filters:        statusFilters,
                      selectedStatus: selectedStatus,
                      tokens:         tokens,
                      onSelect: (s) {
                        final cur = ctx.read<AdminInvoicesListBloc>().state;
                        final curType = cur is AdminInvoicesListLoaded ? cur.selectedType : null;
                        ctx.read<AdminInvoicesListBloc>().add(
                          FilterInvoicesEvent(status: s, type: curType),
                        );
                      },
                    ),
                    const SizedBox(height: 6),
                    _TypeFilterChipsRow(
                      filters:      typeFilters,
                      selectedType: selectedType,
                      tokens:       tokens,
                      onSelect: (t) {
                        final cur = ctx.read<AdminInvoicesListBloc>().state;
                        final curStatus = cur is AdminInvoicesListLoaded ? cur.selectedStatus : null;
                        ctx.read<AdminInvoicesListBloc>().add(
                          FilterInvoicesEvent(status: curStatus, type: t),
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                  ],
                );
              },
            ),
            Expanded(
              child: BlocBuilder<AdminInvoicesListBloc, AdminInvoicesListState>(
                builder: (ctx, state) {
                  if (state is AdminInvoicesListLoading) {
                    return Center(
                        child: CircularProgressIndicator(color: c.primary));
                  }
                  if (state is AdminInvoicesListError) {
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
                                  .read<AdminInvoicesListBloc>()
                                  .add(LoadInvoicesListEvent()),
                              child: Text(l10n.retry),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (state is AdminInvoicesListLoaded) {
                    if (state.invoices.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.receipt_long_outlined,
                                color: c.muted, size: 56),
                            const SizedBox(height: 16),
                            Text(l10n.admin_invoices_noInvoices,
                                style: tokens.typography.titleMedium
                                    .copyWith(color: c.label)),
                            const SizedBox(height: 8),
                            Text(
                              state.selectedStatus != null
                                  ? l10n.admin_invoices_noFilteredInvoices(state.selectedStatus!)
                                  : l10n.admin_invoices_emptyDesc,
                              textAlign: TextAlign.center,
                              style: tokens.typography.bodyMedium
                                  .copyWith(color: c.muted),
                            ),
                          ],
                        ),
                      );
                    }
                    return RefreshIndicator(
                      color: c.primary,
                      onRefresh: () async => ctx
                          .read<AdminInvoicesListBloc>()
                          .add(LoadInvoicesListEvent(status: state.selectedStatus, type: state.selectedType)),
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                        itemCount: state.invoices.length,
                        itemBuilder: (context, i) => _InvoiceSummaryCard(
                          invoice: state.invoices[i],
                          tokens:  tokens,
                          onTap:   () => Navigator.of(context).pushNamed(
                            '/admin/invoices/detail',
                            arguments: state.invoices[i].invoiceId,
                          ),
                        ),
                      ),
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

// ─── Filter chip data ─────────────────────────────────────────────────────────

class _StatusFilter {
  final String  label;
  final String? status;
  final IconData icon;
  const _StatusFilter({required this.label, required this.status, required this.icon});
}

class _TypeFilter {
  final String  label;
  final String? type;
  final IconData icon;
  const _TypeFilter({required this.label, required this.type, required this.icon});
}

// ─── Filter chips row ─────────────────────────────────────────────────────────

class _FilterChipsRow extends StatelessWidget {
  final List<_StatusFilter>     filters;
  final String?                 selectedStatus;
  final dynamic                 tokens;
  final void Function(String?)  onSelect;

  const _FilterChipsRow({
    required this.filters,
    required this.selectedStatus,
    required this.tokens,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final f         = filters[i];
          final isSelected = f.status == selectedStatus;
          return GestureDetector(
            onTap: () => onSelect(f.status),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? c.primary : c.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? c.primary : c.border.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(f.icon,
                      size: 14,
                      color: isSelected ? c.onPrimary : c.muted),
                  const SizedBox(width: 5),
                  Text(
                    f.label,
                    style: tokens.typography.bodySmall.copyWith(
                      color:      isSelected ? c.onPrimary : c.label,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Type filter chips row ────────────────────────────────────────────────────

class _TypeFilterChipsRow extends StatelessWidget {
  final List<_TypeFilter>     filters;
  final String?               selectedType;
  final dynamic               tokens;
  final void Function(String?) onSelect;

  const _TypeFilterChipsRow({
    required this.filters,
    required this.selectedType,
    required this.tokens,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final f          = filters[i];
          final isSelected = f.type == selectedType;
          return GestureDetector(
            onTap: () => onSelect(f.type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: isSelected ? c.success : c.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? c.success : c.border.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(f.icon,
                      size: 13,
                      color: isSelected ? Colors.white : c.muted),
                  const SizedBox(width: 5),
                  Text(
                    f.label,
                    style: tokens.typography.bodySmall.copyWith(
                      color:      isSelected ? Colors.white : c.label,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _InvoiceSummaryCard extends StatelessWidget {
  final AdminInvoiceSummaryEntity invoice;
  final dynamic                   tokens;
  final VoidCallback              onTap;

  const _InvoiceSummaryCard({
    required this.invoice,
    required this.tokens,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c   = tokens.colors;
    final t   = tokens.typography;
    final l10n = AppLocalizations.of(context)!;
    final fmt = NumberFormat('#,##0.00');

    Color statusColor;
    switch (invoice.status.toLowerCase()) {
      case 'paid':
        statusColor = c.success;
        break;
      case 'partial':
        statusColor = Colors.orange;
        break;
      case 'overdue':
      case 'cancelled':
        statusColor = c.danger;
        break;
      default:
        statusColor = c.muted;
    }

    String dateStr = '';
    try {
      dateStr =
          DateFormat('MMM dd, yyyy').format(DateTime.parse(invoice.invoiceDate));
    } catch (_) {
      dateStr = invoice.invoiceDate;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: c.border.withValues(alpha: 0.15)),
          boxShadow: [
            BoxShadow(
                color: c.label.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 3)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.receipt_outlined, color: statusColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Invoice number — full width, never wraps
                  Text(
                    invoice.invoiceNumber,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.bodyMedium.copyWith(
                        color: c.label, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  // Member name + badges on same row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          invoice.memberName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.bodySmall.copyWith(color: c.muted),
                        ),
                      ),
                      if (invoice.type != null) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _typeColor(invoice.type!).withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            invoice.type!.toUpperCase(),
                            style: t.bodySmall.copyWith(
                                color: _typeColor(invoice.type!),
                                fontWeight: FontWeight.w700,
                                fontSize: 9.5),
                          ),
                        ),
                      ],
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          invoice.status.toUpperCase(),
                          style: t.bodySmall.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 9.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  // Date + payment method
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          dateStr,
                          style: t.bodySmall.copyWith(color: c.muted, fontSize: 11.0),
                        ),
                      ),
                      if (invoice.paymentMethod != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_paymentIcon(invoice.paymentMethod!), size: 11, color: c.muted),
                            const SizedBox(width: 3),
                            Text(
                              invoice.paymentMethod!.toUpperCase(),
                              style: t.bodySmall.copyWith(color: c.muted, fontSize: 10.0),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('\$ ${fmt.format(invoice.totalAmount)}',
                    style: t.bodyMedium.copyWith(
                        color: c.label, fontWeight: FontWeight.w900)),
                if (invoice.dueAmount > 0)
                  Text(l10n.admin_invoice_dueAmount('\$ ${fmt.format(invoice.dueAmount)}'),
                      style: t.bodySmall.copyWith(
                          color: c.danger, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(width: 6),
            Icon(Icons.chevron_right_rounded, color: c.muted, size: 18),
          ],
        ),
      ),
    );
  }

  Color _typeColor(String type) {
    switch (type.toUpperCase()) {
      case 'PLAN':  return Colors.deepPurple;
      case 'CLASS': return Colors.teal;
      case 'PT':    return Colors.orange;
      default:      return Colors.grey;
    }
  }

  IconData _paymentIcon(String method) {
    switch (method.toUpperCase()) {
      case 'STRIPE': return Icons.credit_card_outlined;
      case 'CASH':   return Icons.payments_outlined;
      case 'PAYPAL': return Icons.account_balance_wallet_outlined;
      default:       return Icons.payment_outlined;
    }
  }
}
