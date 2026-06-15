import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../domain/entities/member_invoice_entity.dart';
import '../bloc/member_invoices_list_bloc.dart';
import '../bloc/member_invoices_list_event.dart';
import '../bloc/member_invoices_list_state.dart';
import '../widgets/member_invoice_empty_view.dart';
import '../widgets/member_invoice_filter_chips.dart';
import '../widgets/member_invoice_summary_card.dart';

/// Member payment history screen.
///
/// This screen stays clean because card/filter/empty UI are separated
/// into reusable widgets inside presentation/widgets.
class MemberInvoicesListScreen extends StatefulWidget {
  const MemberInvoicesListScreen({super.key});

  @override
  State<MemberInvoicesListScreen> createState() =>
      _MemberInvoicesListScreenState();
}

class _MemberInvoicesListScreenState extends State<MemberInvoicesListScreen> {
  String? _selectedStatus;
  String? _selectedType;

  @override
  void initState() {
    super.initState();

    // Load payment history when the screen opens.
    context.read<MemberInvoicesListBloc>().add(
      const LoadMemberInvoicesEvent(),
    );
  }

  /// Reload invoices with currently selected filters.
  void _reload() {
    context.read<MemberInvoicesListBloc>().add(
      LoadMemberInvoicesEvent(
        status: _selectedStatus,
        type: _selectedType,
      ),
    );
  }

  /// Send refund request directly without popup.
  ///
  /// Backend will only create a pending refund request.
  /// Admin approval is handled elsewhere.
  void _confirmRefund(MemberInvoiceSummaryEntity invoice) {
    context.read<MemberInvoicesListBloc>().add(
      RequestMemberRefundEvent(
        invoiceId: invoice.invoiceId,
        reason: null,
        status: _selectedStatus,
        type: _selectedType,
      ),
    );
  }

  /*
  /// Old refund confirmation popup.
  ///
  /// Kept as comment in case we need to restore the popup later.
  Future<void> _confirmRefund(MemberInvoiceSummaryEntity invoice) async {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c = tokens.colors;

    final reasonController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: c.surface,
          title: Text(
            l10n.memberInvoicesRefundTitle,
            style: tokens.typography.titleMedium.copyWith(
              color: c.label,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.memberInvoicesRefundMessage,
                style: tokens.typography.bodyMedium.copyWith(
                  color: c.body,
                ),
              ),
              const SizedBox(height: 12),

              // Optional reason sent to backend.
              TextField(
                controller: reasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: l10n.memberInvoicesRefundReason,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.general_cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l10n.memberInvoicesRefundSend),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    context.read<MemberInvoicesListBloc>().add(
          RequestMemberRefundEvent(
            invoiceId: invoice.invoiceId,
            reason: reasonController.text.trim().isEmpty
                ? null
                : reasonController.text.trim(),
            status: _selectedStatus,
            type: _selectedType,
          ),
        );
  }
  */

  /// Navigate to full invoice details.
  void _openDetails(MemberInvoiceSummaryEntity invoice) {
    Navigator.of(context).pushNamed(
      '/member/invoices/detail',
      arguments: invoice.invoiceId,
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
        title: Text(
          l10n.memberInvoicesTitle,
          style: tokens.typography.titleMedium.copyWith(
            color: c.label,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          _buildStatusFilters(tokens, l10n),
          const SizedBox(height: 6),
          _buildTypeFilters(tokens, l10n),
          const SizedBox(height: 4),
          Expanded(
            child: BlocConsumer<MemberInvoicesListBloc,
                MemberInvoicesListState>(
              listener: (context, state) {
                if (state is MemberInvoicesListError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.error_somethingWentWrong),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is MemberInvoicesListInitial ||
                    state is MemberInvoicesListLoading) {
                  return Center(
                    child: CircularProgressIndicator(color: c.primary),
                  );
                }

                if (state is MemberRefundRequesting) {
                  return _buildList(
                    tokens: tokens,
                    l10n: l10n,
                    invoices: state.invoices,
                    requestingInvoiceId: state.invoiceId,
                  );
                }

                if (state is MemberInvoicesListLoaded) {
                  if (state.invoices.isEmpty) {
                    return MemberInvoiceEmptyView(
                      tokens: tokens,
                      title: l10n.memberInvoicesEmptyTitle,
                      subtitle: l10n.memberInvoicesEmptySubtitle,
                    );
                  }

                  return RefreshIndicator(
                    color: c.primary,
                    onRefresh: () async => _reload(),
                    child: _buildList(
                      tokens: tokens,
                      l10n: l10n,
                      invoices: state.invoices,
                    ),
                  );
                }

                if (state is MemberInvoicesListError) {
                  return Center(
                    child: ElevatedButton(
                      onPressed: _reload,
                      child: Text(l10n.memberInvoicesRetry),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  /// First filter row: invoice status.
  Widget _buildStatusFilters(dynamic tokens, AppLocalizations l10n) {
    final filters = [
      MemberInvoiceFilterItem(
        label: l10n.memberInvoicesAll,
        value: null,
        icon: Icons.receipt_long_outlined,
      ),
      MemberInvoiceFilterItem(
        label: l10n.memberInvoicesStatusPaid,
        value: 'paid',
        icon: Icons.check_circle_outline,
      ),
      MemberInvoiceFilterItem(
        label: l10n.memberInvoicesStatusPending,
        value: 'pending',
        icon: Icons.hourglass_top_rounded,
      ),
      MemberInvoiceFilterItem(
        label: l10n.memberInvoicesStatusRefunded,
        value: 'refunded',
        icon: Icons.assignment_return_outlined,
      ),
      MemberInvoiceFilterItem(
        label: l10n.memberInvoicesStatusCancelled,
        value: 'cancelled',
        icon: Icons.cancel_outlined,
      ),
    ];

    return MemberInvoiceFilterChips(
      filters: filters,
      selectedValue: _selectedStatus,
      tokens: tokens,
      activeColor: tokens.colors.primary,
      onSelect: (value) {
        setState(() => _selectedStatus = value);
        _reload();
      },
    );
  }

  /// Second filter row: invoice item type.
  Widget _buildTypeFilters(dynamic tokens, AppLocalizations l10n) {
    final filters = [
      MemberInvoiceFilterItem(
        label: l10n.memberInvoicesAllTypes,
        value: null,
        icon: Icons.all_inbox_outlined,
      ),
      MemberInvoiceFilterItem(
        label: l10n.memberInvoicesTypePlans,
        value: 'PLAN',
        icon: Icons.card_membership_outlined,
      ),
      MemberInvoiceFilterItem(
        label: l10n.memberInvoicesTypeClasses,
        value: 'CLASS',
        icon: Icons.fitness_center_outlined,
      ),
      MemberInvoiceFilterItem(
        label: l10n.memberInvoicesTypePt,
        value: 'PT',
        icon: Icons.sports_outlined,
      ),
      MemberInvoiceFilterItem(
        label: l10n.memberInvoicesTypePtPackage,
        value: 'PT_PACKAGE',
        icon: Icons.inventory_2_outlined,
      ),
      MemberInvoiceFilterItem(
        label: l10n.memberInvoicesTypeDailyPass,
        value: 'DAILY_PASS',
        icon: Icons.confirmation_number_outlined,
      ),
    ];

    return MemberInvoiceFilterChips(
      filters: filters,
      selectedValue: _selectedType,
      tokens: tokens,
      activeColor: tokens.colors.success,
      onSelect: (value) {
        setState(() => _selectedType = value);
        _reload();
      },
    );
  }

  bool _isCancelledSessionBooking(MemberInvoiceSummaryEntity invoice) {
    if (invoice.status.toLowerCase() != 'cancelled') return false;
    final type = invoice.type?.toLowerCase() ?? '';
    return type == 'class' || type == 'pt' || type == 'pt_package';
  }

  /// Builds the list of invoice cards.
  Widget _buildList({
    required dynamic tokens,
    required AppLocalizations l10n,
    required List<MemberInvoiceSummaryEntity> invoices,
    int? requestingInvoiceId,
  }) {
    final localeName = Localizations.localeOf(context).toLanguageTag();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      itemCount: invoices.length,
      itemBuilder: (context, index) {
        final invoice = invoices[index];

        return MemberInvoiceSummaryCard(
          invoice: invoice,
          tokens: tokens,
          l10n: l10n,
          localeName: localeName,
          isRequestingRefund: requestingInvoiceId == invoice.invoiceId,
          onDetails: () => _openDetails(invoice),
          onRefund: invoice.canRequestRefund && !_isCancelledSessionBooking(invoice)
              ? () => _confirmRefund(invoice)
              : null,
        );
      },
    );
  }
}