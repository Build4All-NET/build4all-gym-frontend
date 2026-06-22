// FILE: lib/features/admin/balance_sheet/presentation/screens/admin_balance_sheet_screen.dart
//
// Balance Sheet:
//   Net Profit (collection - expense) header
//   Collection / Expense summary cards
//   ── divider ──
//   Date filter (presets + custom range)
//   Tabs: Collection (all invoices) | Expense (all expenses)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../../AppBar/presentation/admin_app_bar.dart';
import '../../../navigation/presentation/widgets/admin_navigation_drawer.dart';
import '../../../invoices/domain/entities/admin_invoice_entity.dart';
import '../../../expenses/domain/entities/expense_entity.dart';
import '../cubit/balance_sheet_cubit.dart';

class AdminBalanceSheetScreen extends StatefulWidget {
  const AdminBalanceSheetScreen({super.key});

  @override
  State<AdminBalanceSheetScreen> createState() => _AdminBalanceSheetScreenState();
}

class _AdminBalanceSheetScreenState extends State<AdminBalanceSheetScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BalanceSheetCubit>().load();
  }

  Future<void> _pickCustomRange(BuildContext context) async {
    final now = DateTime.now();
    final current = context.read<BalanceSheetCubit>().state;
    final initial = current is BalanceSheetLoaded ? current.customRange : null;

    // Default the calendar to the current month so it opens with a full
    // month already selected instead of an empty/arbitrary range.
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);
    final defaultRange = DateTimeRange(
      start: monthStart,
      end: monthEnd.isAfter(now) ? now : monthEnd,
    );

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
      initialDateRange: initial ?? defaultRange,
    );
    if (picked != null && context.mounted) {
      context.read<BalanceSheetCubit>().setRange(BalanceSheetRange.custom, customRange: picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final l10n = AppLocalizations.of(context)!;
    final profile = context.watch<AdminProfileCubit>().state;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: AdminNavigationDrawer(
          gymName: profile.gymName,
          branchName: profile.branchName,
          adminName: profile.adminName,
          adminEmail: profile.adminEmail,
          avatarUrl: profile.avatarUrl,
          initialActiveId: 'balance_sheet',
        ),
        backgroundColor: c.background,
        body: SafeArea(
          child: Column(
            children: [
              AdminAppBar(title: l10n.navBalanceSheet, notificationCount: 0),
              Expanded(
                child: BlocBuilder<BalanceSheetCubit, BalanceSheetState>(
                  builder: (context, state) {
                    if (state is BalanceSheetError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.error_outline_rounded, color: c.danger, size: 48),
                              const SizedBox(height: 12),
                              Text(state.message, textAlign: TextAlign.center, style: TextStyle(color: c.muted)),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => context.read<BalanceSheetCubit>().load(),
                                style: ElevatedButton.styleFrom(backgroundColor: c.primary, foregroundColor: c.onPrimary),
                                child: Text(l10n.retry),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (state is! BalanceSheetLoaded) {
                      return Center(child: CircularProgressIndicator(color: c.primary));
                    }

                    return Column(
                      children: [
                        _DateFilterBar(
                          state: state,
                          l10n: l10n,
                          tokens: tokens,
                          onPickCustom: () => _pickCustomRange(context),
                        ),
                        _SummaryHeader(state: state, l10n: l10n, tokens: tokens),
                        Divider(height: 1, thickness: 1, color: c.border.withValues(alpha: 0.18)),
                        Container(
                          color: c.surface,
                          child: TabBar(
                            labelColor: c.primary,
                            unselectedLabelColor: c.muted,
                            indicatorColor: c.primary,
                            indicatorWeight: 2.5,
                            labelStyle: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
                            unselectedLabelStyle: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                            tabs: [
                              Tab(text: '${l10n.balance_sheet_collectionTab} (${state.invoices.length})'),
                              Tab(text: '${l10n.balance_sheet_expenseTab} (${state.expenses.length})'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              _CollectionListView(state: state, l10n: l10n, tokens: tokens),
                              _ExpenseListView(state: state, l10n: l10n, tokens: tokens),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Date filter bar — presets + custom range picker ───────────────────────────

class _DateFilterBar extends StatelessWidget {
  final BalanceSheetLoaded state;
  final AppLocalizations l10n;
  final dynamic tokens;
  final VoidCallback onPickCustom;

  const _DateFilterBar({
    required this.state,
    required this.l10n,
    required this.tokens,
    required this.onPickCustom,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    final options = <(BalanceSheetRange, String)>[
      (BalanceSheetRange.today, l10n.balance_sheet_filterToday),
      (BalanceSheetRange.thisWeek, l10n.balance_sheet_filterThisWeek),
      (BalanceSheetRange.thisMonth, l10n.balance_sheet_filterThisMonth),
      (BalanceSheetRange.thisYear, l10n.balance_sheet_filterThisYear),
      (BalanceSheetRange.allTime, l10n.balance_sheet_filterAllTime),
      (BalanceSheetRange.custom, l10n.balance_sheet_filterCustom),
    ];

    return Container(
      color: c.surface,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: options.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final (range, label) = options[i];
                final isSelected = state.range == range;
                return GestureDetector(
                  onTap: () {
                    if (range == BalanceSheetRange.custom) {
                      onPickCustom();
                    } else {
                      context.read<BalanceSheetCubit>().setRange(range);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? c.primary : c.background,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSelected ? c.primary : c.border.withOpacity(0.25)),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected ? c.onPrimary : c.label,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (state.range == BalanceSheetRange.custom && state.customRange != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text(
                '${DateFormat('dd MMM yyyy').format(state.customRange!.start)}  –  ${DateFormat('dd MMM yyyy').format(state.customRange!.end)}',
                style: TextStyle(fontSize: 12, color: c.muted, fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Net profit + collection/expense summary ───────────────────────────────────

class _SummaryHeader extends StatelessWidget {
  final BalanceSheetLoaded state;
  final AppLocalizations l10n;
  final dynamic tokens;

  const _SummaryHeader({required this.state, required this.l10n, required this.tokens});

  String _money(num v) => '₹${v.toStringAsFixed(0)}';

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    final isProfit = state.netProfit >= 0;
    final profitColor = isProfit ? c.success : c.danger;

    return Container(
      color: c.surface,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        children: [
          // ── Net profit ───────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: profitColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: profitColor.withOpacity(0.25)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: profitColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isProfit ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                    color: profitColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.balance_sheet_netProfit,
                        style: TextStyle(fontSize: 12.5, color: c.muted, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _money(state.netProfit),
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: profitColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // ── Collection / Expense ────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: l10n.balance_sheet_collection,
                  value: _money(state.totalCollection),
                  icon: Icons.payments_rounded,
                  color: c.success,
                  surface: c.background,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniStat(
                  label: l10n.balance_sheet_expense,
                  value: _money(state.totalExpense),
                  icon: Icons.money_off_rounded,
                  color: c.danger,
                  surface: c.background,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color surface;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.surface,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: color)),
        ],
      ),
    );
  }
}

// ── Collection tab — invoices ──────────────────────────────────────────────────

class _CollectionListView extends StatelessWidget {
  final BalanceSheetLoaded state;
  final AppLocalizations l10n;
  final dynamic tokens;

  const _CollectionListView({required this.state, required this.l10n, required this.tokens});

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;

    if (state.invoices.isEmpty) {
      return RefreshIndicator(
        color: c.primary,
        onRefresh: () => context.read<BalanceSheetCubit>().refresh(),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(48),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.receipt_long_outlined, color: c.muted, size: 48),
                    const SizedBox(height: 12),
                    Text(l10n.balance_sheet_noCollections, style: TextStyle(color: c.muted)),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: c.primary,
      onRefresh: () => context.read<BalanceSheetCubit>().refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: state.invoices.length,
        itemBuilder: (context, i) => _CollectionCard(
          invoice: state.invoices[i],
          tokens: tokens,
          onTap: () => Navigator.of(context).pushNamed(
            '/admin/invoices/detail',
            arguments: state.invoices[i].invoiceId,
          ),
        ),
      ),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  final AdminInvoiceSummaryEntity invoice;
  final dynamic tokens;
  final VoidCallback onTap;

  const _CollectionCard({required this.invoice, required this.tokens, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    final fmt = NumberFormat('#,##0.00');

    String dateStr;
    try {
      dateStr = DateFormat('MMM dd, yyyy').format(DateTime.parse(invoice.invoiceDate));
    } catch (_) {
      dateStr = invoice.invoiceDate;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: c.border.withOpacity(0.15)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: c.success.withOpacity(0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.receipt_outlined, color: c.success, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(invoice.invoiceNumber,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: c.label)),
                  const SizedBox(height: 3),
                  Text(invoice.memberName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: c.muted)),
                  const SizedBox(height: 2),
                  Text(dateStr, style: TextStyle(fontSize: 11, color: c.muted)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text('₹${fmt.format(invoice.paidAmount)}',
                style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: c.success)),
          ],
        ),
      ),
    );
  }
}

// ── Expense tab — read-only expense rows ───────────────────────────────────────

class _ExpenseListView extends StatelessWidget {
  final BalanceSheetLoaded state;
  final AppLocalizations l10n;
  final dynamic tokens;

  const _ExpenseListView({required this.state, required this.l10n, required this.tokens});

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;

    if (state.expenses.isEmpty) {
      return RefreshIndicator(
        color: c.primary,
        onRefresh: () => context.read<BalanceSheetCubit>().refresh(),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(48),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.money_off_outlined, color: c.muted, size: 48),
                    const SizedBox(height: 12),
                    Text(l10n.balance_sheet_noExpenses, style: TextStyle(color: c.muted)),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: c.primary,
      onRefresh: () => context.read<BalanceSheetCubit>().refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: state.expenses.length,
        itemBuilder: (context, i) => _ExpenseRow(expense: state.expenses[i], tokens: tokens),
      ),
    );
  }
}

class _ExpenseRow extends StatelessWidget {
  final ExpenseEntity expense;
  final dynamic tokens;

  const _ExpenseRow({required this.expense, required this.tokens});

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.border.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: c.danger.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.money_off_rounded, color: c.danger, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(expense.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: c.label)),
                const SizedBox(height: 3),
                Text('${expense.category} · ${expense.branchName}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: c.muted)),
                const SizedBox(height: 2),
                Text(DateFormat('MMM dd, yyyy').format(expense.expenseDate),
                    style: TextStyle(fontSize: 11, color: c.muted)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text('₹${expense.amount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: c.danger)),
        ],
      ),
    );
  }
}