import 'package:build4allgym/common/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../../AppBar/presentation/admin_app_bar.dart';
import '../../../navigation/presentation/widgets/admin_navigation_drawer.dart';
import '../../domain/entities/admin_refund_request_entity.dart';
import '../../domain/entities/membership_request_entity.dart';
import '../bloc/admin_membership_requests_bloc.dart';

class AdminMembershipRequestsScreen extends StatefulWidget {
  const AdminMembershipRequestsScreen({super.key});

  @override
  State<AdminMembershipRequestsScreen> createState() =>
      _AdminMembershipRequestsScreenState();
}

class _AdminMembershipRequestsScreenState
    extends State<AdminMembershipRequestsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<AdminMembershipRequestsBloc>().add(LoadMembershipRequestsEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final profile = context.watch<AdminProfileCubit>().state;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: c.background,
      drawer: SafeArea(
        child: AdminNavigationDrawer(
          gymName: profile.gymName,
          branchName: profile.branchName,
          adminName: profile.adminName,
          adminEmail: profile.adminEmail,
          avatarUrl: profile.avatarUrl,
          initialActiveId: 'membership_requests',
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<AdminMembershipRequestsBloc,
            AdminMembershipRequestsState>(
          listener: (context, state) {
            if (state is AdminMembershipRequestsActionSuccess) {
              AppToast.success(context, state.message);
              if (state.invoiceId != null) {
                Navigator.of(context).pushNamed(
                  '/admin/invoices/detail',
                  arguments: state.invoiceId,
                );
              }
            } else if (state is AdminMembershipRequestsActionFailure) {
              AppToast.error(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is AdminMembershipRequestsLoading) {
              return Column(
                children: [
                  AdminAppBar(title: l10n.navMembershipRequests),
                  Expanded(
                    child: Center(
                        child: CircularProgressIndicator(color: c.primary)),
                  ),
                ],
              );
            }

            if (state is AdminMembershipRequestsError) {
              return Column(
                children: [
                  AdminAppBar(title: l10n.navMembershipRequests),
                  Expanded(
                    child: Center(
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
                            onPressed: () => context
                                .read<AdminMembershipRequestsBloc>()
                                .add(LoadMembershipRequestsEvent()),
                            child: Text(l10n.retry),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            final requests = switch (state) {
              AdminMembershipRequestsLoaded s => s.requests,
              AdminMembershipRequestsActionSuccess s => s.requests,
              AdminMembershipRequestsActionFailure s => s.requests,
              _ => <MembershipRequestEntity>[],
            };
            final refundRequests = switch (state) {
              AdminMembershipRequestsLoaded s => s.refundRequests,
              AdminMembershipRequestsActionSuccess s => s.refundRequests,
              AdminMembershipRequestsActionFailure s => s.refundRequests,
              _ => <AdminRefundRequestEntity>[],
            };
            final actingOnId = state is AdminMembershipRequestsLoaded
                ? state.actingOnId
                : null;
            final actingOnRefundId = state is AdminMembershipRequestsLoaded
                ? state.actingOnRefundId
                : null;

            return Column(
              children: [
                AdminAppBar(title: l10n.navMembershipRequests),
                _TabBar(
                  controller: _tabController,
                  tokens: tokens,
                  membershipCount: requests.length,
                  refundCount: refundRequests.length,
                  l10n: l10n,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _MembershipRequestsTab(
                        requests: requests,
                        actingOnId: actingOnId,
                        tokens: tokens,
                        onApprove: (req) =>
                            _showApproveSheet(context, req, tokens),
                        onReject: (req) =>
                            _showRejectSheet(context, req, tokens),
                        onRefresh: () async => context
                            .read<AdminMembershipRequestsBloc>()
                            .add(LoadMembershipRequestsEvent()),
                      ),
                      _RefundRequestsTab(
                        refundRequests: refundRequests,
                        actingOnRefundId: actingOnRefundId,
                        tokens: tokens,
                        onProcess: (req) =>
                            _showProcessRefundSheet(context, req, tokens),
                        onReject: (req) =>
                            _showRejectRefundSheet(context, req, tokens),
                        onRefresh: () async => context
                            .read<AdminMembershipRequestsBloc>()
                            .add(LoadMembershipRequestsEvent()),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ── Membership approve sheet ─────────────────────────────────────────────

  void _showApproveSheet(BuildContext context,
      MembershipRequestEntity req, dynamic tokens) {
    final notesController = TextEditingController();
    final amountController =
        TextEditingController(text: req.totalAmount.toStringAsFixed(2));
    final formKey = GlobalKey<FormState>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetCtx) => Padding(
        padding: EdgeInsetsDirectional.only(
          start: 24,
          end: 24,
          top: 24,
          bottom: MediaQuery.of(sheetCtx).viewInsets.bottom +
              MediaQuery.of(sheetCtx).padding.bottom +
              24,
        ),
        child: StatefulBuilder(
            builder: (ctx, setState) {
              final l10n = AppLocalizations.of(ctx)!;
              final typedAmount =
                  double.tryParse(amountController.text.trim()) ?? req.totalAmount;
              return Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(l10n.admin_membershipRequests_approveTitle,
                        style: tokens.typography.headlineSmall.copyWith(
                            color: tokens.colors.label,
                            fontWeight: FontWeight.w900)),
                    const SizedBox(height: 8),
                    Text(
                      l10n.admin_membershipRequests_subscriptionInfo(
                          req.planName, req.totalAmount.toStringAsFixed(2)),
                      style: tokens.typography.bodyMedium
                          .copyWith(color: tokens.colors.muted),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.trainer_partialPaymentHint,
                      textAlign: TextAlign.end,
                      style: tokens.typography.bodySmall
                          .copyWith(color: tokens.colors.muted),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: amountController,
                      textAlign: TextAlign.end,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        labelText: l10n.trainer_amountToCollectLabel,
                        filled: true,
                        fillColor: tokens.colors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (v) {
                        final amount = double.tryParse(v?.trim() ?? '');
                        if (amount == null || amount <= 0) {
                          return l10n.trainer_invalidAmount;
                        }
                        if (amount > req.totalAmount) {
                          return l10n.trainer_amountExceedsTotal;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: notesController,
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                        hintText: l10n.admin_membershipRequests_notesHint,
                        filled: true,
                        fillColor: tokens.colors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (!formKey.currentState!.validate()) return;
                        final amountPaid = double.parse(amountController.text.trim());
                        Navigator.pop(sheetCtx);
                        context.read<AdminMembershipRequestsBloc>().add(
                              ApproveMembershipRequestEvent(
                                requestId: req.requestId,
                                amountPaid: amountPaid,
                                notes: notesController.text.trim().isEmpty
                                    ? null
                                    : notesController.text.trim(),
                              ),
                            );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tokens.colors.success,
                        foregroundColor: tokens.colors.onPrimary,
                        elevation: 0,
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                          l10n.admin_membershipRequests_approveButton(
                              typedAmount.toStringAsFixed(2)),
                          style: tokens.typography.bodyMedium.copyWith(
                              color: tokens.colors.onPrimary,
                              fontWeight: FontWeight.w900)),
                    ),
                  ],
                ),
              );
            },
          ),
      ),
    );
  }

  // ── Membership reject sheet ──────────────────────────────────────────────

  void _showRejectSheet(BuildContext context,
      MembershipRequestEntity req, dynamic tokens) {
    final reasonController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetCtx) => Padding(
        padding: EdgeInsetsDirectional.only(
          start: 24,
          end: 24,
          top: 24,
          bottom: MediaQuery.of(sheetCtx).viewInsets.bottom +
              MediaQuery.of(sheetCtx).padding.bottom +
              24,
        ),
        child: Builder(
            builder: (ctx) {
              final l10n = AppLocalizations.of(ctx)!;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l10n.admin_membershipRequests_rejectTitle,
                      style: tokens.typography.headlineSmall.copyWith(
                          color: tokens.colors.label,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  Text('${req.memberName} — ${req.planName}',
                      style: tokens.typography.bodyMedium
                          .copyWith(color: tokens.colors.muted)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: reasonController,
                    textAlign: TextAlign.end,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: l10n.admin_membershipRequests_rejectHint,
                      filled: true,
                      fillColor: tokens.colors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      final reason = reasonController.text.trim();
                      if (reason.isEmpty) {
                        AppToast.info(
                            sheetCtx, l10n.admin_membershipRequests_enterReason);
                        return;
                      }
                      Navigator.pop(sheetCtx);
                      context.read<AdminMembershipRequestsBloc>().add(
                            RejectMembershipRequestEvent(
                              requestId: req.requestId,
                              reason: reason,
                            ),
                          );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tokens.colors.danger,
                      foregroundColor: tokens.colors.onPrimary,
                      elevation: 0,
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(l10n.admin_membershipRequests_rejectButton,
                        style: tokens.typography.bodyMedium.copyWith(
                            color: tokens.colors.onPrimary,
                            fontWeight: FontWeight.w900)),
                  ),
                ],
              );
            },
          ),
      ),
    );
  }

  // ── Refund process sheet ─────────────────────────────────────────────────

  void _showProcessRefundSheet(BuildContext context,
      AdminRefundRequestEntity req, dynamic tokens) {
    final amountController = TextEditingController(
        text: req.requestedAmount.toStringAsFixed(2));
    final deductionController = TextEditingController(text: '0.00');
    final noteController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetCtx) => Padding(
        padding: EdgeInsetsDirectional.only(
          start: 24,
          end: 24,
          top: 24,
          bottom: MediaQuery.of(sheetCtx).viewInsets.bottom +
              MediaQuery.of(sheetCtx).padding.bottom +
              24,
        ),
        child: SingleChildScrollView(
            child: Builder(
              builder: (ctx) {
                final l10n = AppLocalizations.of(ctx)!;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(l10n.admin_refundRequests_processTitle,
                        style: tokens.typography.headlineSmall.copyWith(
                            color: tokens.colors.label,
                            fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text('${req.memberName} — ${req.planName}',
                        style: tokens.typography.bodyMedium
                            .copyWith(color: tokens.colors.muted)),
                    const SizedBox(height: 4),
                    Text(
                      '${l10n.admin_refundRequests_requestedAmount}: \$ ${req.requestedAmount.toStringAsFixed(2)}',
                      style: tokens.typography.bodySmall
                          .copyWith(color: tokens.colors.primary, fontWeight: FontWeight.w700),
                    ),
                    if (req.reason != null && req.reason!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${l10n.admin_refundRequests_reason}: ${req.reason}',
                        style: tokens.typography.bodySmall
                            .copyWith(color: tokens.colors.muted),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Text(l10n.admin_refundRequests_refundAmount,
                        style: tokens.typography.bodyMedium.copyWith(
                            color: tokens.colors.label,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                        hintText: l10n.admin_refundRequests_refundAmountHint,
                        filled: true,
                        fillColor: tokens.colors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        prefixText: '\$ ',
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(l10n.admin_refundRequests_deductionAmount,
                        style: tokens.typography.bodyMedium.copyWith(
                            color: tokens.colors.label,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: deductionController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                        hintText: l10n.admin_refundRequests_deductionHint,
                        filled: true,
                        fillColor: tokens.colors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        prefixText: '\$ ',
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: noteController,
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                        hintText: l10n.admin_refundRequests_adminNoteHint,
                        filled: true,
                        fillColor: tokens.colors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        final refundAmount =
                            double.tryParse(amountController.text.trim());
                        if (refundAmount == null || refundAmount <= 0) {
                          AppToast.info(
                              sheetCtx, l10n.admin_refundRequests_enterAmount);
                          return;
                        }
                        final deduction =
                            double.tryParse(deductionController.text.trim()) ??
                                0.0;
                        Navigator.pop(sheetCtx);
                        context.read<AdminMembershipRequestsBloc>().add(
                              ApproveRefundRequestEvent(
                                refundId: req.refundId,
                                refundAmount: refundAmount,
                                deductionAmount: deduction > 0 ? deduction : null,
                                adminNote: noteController.text.trim().isEmpty
                                    ? null
                                    : noteController.text.trim(),
                              ),
                            );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tokens.colors.success,
                        foregroundColor: tokens.colors.onPrimary,
                        elevation: 0,
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                          l10n.admin_refundRequests_approveButton(
                              amountController.text.trim()),
                          style: tokens.typography.bodyMedium.copyWith(
                              color: tokens.colors.onPrimary,
                              fontWeight: FontWeight.w900)),
                    ),
                  ],
                );
              },
            ),
          ),
      ),
    );
  }

  // ── Refund reject sheet ──────────────────────────────────────────────────

  void _showRejectRefundSheet(BuildContext context,
      AdminRefundRequestEntity req, dynamic tokens) {
    final reasonController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetCtx) => Padding(
        padding: EdgeInsetsDirectional.only(
          start: 24,
          end: 24,
          top: 24,
          bottom: MediaQuery.of(sheetCtx).viewInsets.bottom +
              MediaQuery.of(sheetCtx).padding.bottom +
              24,
        ),
        child: Builder(
            builder: (ctx) {
              final l10n = AppLocalizations.of(ctx)!;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l10n.admin_refundRequests_rejectTitle,
                      style: tokens.typography.headlineSmall.copyWith(
                          color: tokens.colors.label,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  Text('${req.memberName} — ${req.planName}',
                      style: tokens.typography.bodyMedium
                          .copyWith(color: tokens.colors.muted)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: reasonController,
                    textAlign: TextAlign.end,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: l10n.admin_refundRequests_rejectHint,
                      filled: true,
                      fillColor: tokens.colors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      final reason = reasonController.text.trim();
                      if (reason.isEmpty) {
                        AppToast.info(
                            sheetCtx, l10n.admin_refundRequests_enterReason);
                        return;
                      }
                      Navigator.pop(sheetCtx);
                      context.read<AdminMembershipRequestsBloc>().add(
                            RejectRefundRequestEvent(
                              refundId: req.refundId,
                              reason: reason,
                            ),
                          );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tokens.colors.danger,
                      foregroundColor: tokens.colors.onPrimary,
                      elevation: 0,
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(l10n.admin_refundRequests_rejectButton,
                        style: tokens.typography.bodyMedium.copyWith(
                            color: tokens.colors.onPrimary,
                            fontWeight: FontWeight.w900)),
                  ),
                ],
              );
            },
          ),
      ),
    );
  }
}

// ── Tab bar ──────────────────────────────────────────────────────────────────

class _TabBar extends StatelessWidget {
  final TabController controller;
  final dynamic tokens;
  final int membershipCount;
  final int refundCount;
  final AppLocalizations l10n;

  const _TabBar({
    required this.controller,
    required this.tokens,
    required this.membershipCount,
    required this.refundCount,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    return Container(
      color: c.surface,
      child: TabBar(
        controller: controller,
        labelColor: c.primary,
        unselectedLabelColor: c.muted,
        indicatorColor: c.primary,
        indicatorWeight: 2.5,
        labelStyle: tokens.typography.bodyMedium
            .copyWith(fontWeight: FontWeight.w700),
        unselectedLabelStyle: tokens.typography.bodyMedium,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    l10n.admin_membershipRequests_tab,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
                if (membershipCount > 0) ...[
                  const SizedBox(width: 6),
                  _CountBadge(count: membershipCount, color: const Color(0xFFD97706)),
                ],
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    l10n.admin_refundRequests_tab,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
                if (refundCount > 0) ...[
                  const SizedBox(width: 6),
                  _CountBadge(count: refundCount, color: c.danger),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  final int count;
  final Color color;
  const _CountBadge({required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$count',
        style: const TextStyle(
            color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
      ),
    );
  }
}

// ── Membership requests tab ──────────────────────────────────────────────────

class _MembershipRequestsTab extends StatelessWidget {
  final List<MembershipRequestEntity> requests;
  final int? actingOnId;
  final dynamic tokens;
  final void Function(MembershipRequestEntity) onApprove;
  final void Function(MembershipRequestEntity) onReject;
  final Future<void> Function() onRefresh;

  const _MembershipRequestsTab({
    required this.requests,
    required this.actingOnId,
    required this.tokens,
    required this.onApprove,
    required this.onReject,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    final l10n = AppLocalizations.of(context)!;

    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline, color: c.success, size: 56),
            const SizedBox(height: 16),
            Text(l10n.admin_membershipRequests_noPending,
                style:
                    tokens.typography.titleMedium.copyWith(color: c.label)),
            const SizedBox(height: 8),
            Text(l10n.admin_membershipRequests_noPendingDesc,
                style:
                    tokens.typography.bodyMedium.copyWith(color: c.muted)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: c.primary,
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final req = requests[index];
          return _RequestCard(
            request: req,
            isActing: actingOnId == req.requestId,
            tokens: tokens,
            onApprove: () => onApprove(req),
            onReject: () => onReject(req),
          );
        },
      ),
    );
  }
}

// ── Refund requests tab ──────────────────────────────────────────────────────

class _RefundRequestsTab extends StatelessWidget {
  final List<AdminRefundRequestEntity> refundRequests;
  final int? actingOnRefundId;
  final dynamic tokens;
  final void Function(AdminRefundRequestEntity) onProcess;
  final void Function(AdminRefundRequestEntity) onReject;
  final Future<void> Function() onRefresh;

  const _RefundRequestsTab({
    required this.refundRequests,
    required this.actingOnRefundId,
    required this.tokens,
    required this.onProcess,
    required this.onReject,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    final l10n = AppLocalizations.of(context)!;

    if (refundRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.money_off_outlined, color: c.muted, size: 56),
            const SizedBox(height: 16),
            Text(l10n.admin_refundRequests_noPending,
                style:
                    tokens.typography.titleMedium.copyWith(color: c.label)),
            const SizedBox(height: 8),
            Text(l10n.admin_refundRequests_noPendingDesc,
                style:
                    tokens.typography.bodyMedium.copyWith(color: c.muted)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: c.primary,
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        itemCount: refundRequests.length,
        itemBuilder: (context, index) {
          final req = refundRequests[index];
          return _RefundCard(
            request: req,
            isActing: actingOnRefundId == req.refundId,
            tokens: tokens,
            onProcess: () => onProcess(req),
            onReject: () => onReject(req),
          );
        },
      ),
    );
  }
}

// ── Membership request card ──────────────────────────────────────────────────

class _RequestCard extends StatelessWidget {
  final MembershipRequestEntity request;
  final bool isActing;
  final dynamic tokens;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _RequestCard({
    required this.request,
    required this.isActing,
    required this.tokens,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.border.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
              color: c.label.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: isActing
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child:
                    CircularProgressIndicator(strokeWidth: 2, color: c.primary),
              ),
            )
          : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: c.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.person_outline,
                            color: c.primary, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(request.memberName,
                                style: tokens.typography.titleMedium.copyWith(
                                    color: c.label,
                                    fontWeight: FontWeight.w800)),
                            Text(request.memberEmail,
                                style: tokens.typography.bodySmall
                                    .copyWith(color: c.muted)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3CD),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                            l10n.admin_membershipRequests_pendingBadge,
                            style: tokens.typography.bodySmall.copyWith(
                                color: const Color(0xFF856404),
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _InfoRow(
                      label: l10n.admin_membershipRequests_plan,
                      value: request.planName,
                      tokens: tokens),
                  _InfoRow(
                      label: l10n.admin_membershipRequests_branch,
                      value: request.branchName,
                      tokens: tokens),
                  _InfoRow(
                      label: l10n.admin_membershipRequests_amount,
                      value: '\$ ${request.totalAmount.toStringAsFixed(2)}',
                      tokens: tokens,
                      valueColor: c.primary),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onReject,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: c.danger,
                            side: BorderSide(color: c.danger.withOpacity(0.5)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(l10n.admin_membershipRequests_reject,
                              style: tokens.typography.bodyMedium.copyWith(
                                  color: c.danger,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onApprove,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: c.success,
                            foregroundColor: c.onPrimary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(l10n.admin_membershipRequests_approve,
                              style: tokens.typography.bodyMedium.copyWith(
                                  color: c.onPrimary,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
    );
  }
}

// ── Refund request card ──────────────────────────────────────────────────────

class _RefundCard extends StatelessWidget {
  final AdminRefundRequestEntity request;
  final bool isActing;
  final dynamic tokens;
  final VoidCallback onProcess;
  final VoidCallback onReject;

  const _RefundCard({
    required this.request,
    required this.isActing,
    required this.tokens,
    required this.onProcess,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: c.danger.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
              color: c.label.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: isActing
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child:
                    CircularProgressIndicator(strokeWidth: 2, color: c.primary),
              ),
            )
          : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: c.danger.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.money_off_outlined,
                            color: c.danger, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(request.memberName,
                                style: tokens.typography.titleMedium.copyWith(
                                    color: c.label,
                                    fontWeight: FontWeight.w800)),
                            Text(request.memberEmail,
                                style: tokens.typography.bodySmall
                                    .copyWith(color: c.muted)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: c.danger.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(l10n.admin_refundRequests_pendingBadge,
                            style: tokens.typography.bodySmall.copyWith(
                                color: c.danger,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _InfoRow(
                      label: l10n.admin_membershipRequests_plan,
                      value: request.planName,
                      tokens: tokens),
                  _InfoRow(
                      label: l10n.admin_refundRequests_requestedAmount,
                      value: '\$ ${request.requestedAmount.toStringAsFixed(2)}',
                      tokens: tokens,
                      valueColor: c.danger),
                  if (request.reason != null && request.reason!.isNotEmpty)
                    _InfoRow(
                        label: l10n.admin_refundRequests_reason,
                        value: request.reason!,
                        tokens: tokens),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onReject,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: c.danger,
                            side: BorderSide(color: c.danger.withOpacity(0.5)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(l10n.admin_refundRequests_reject,
                              style: tokens.typography.bodyMedium.copyWith(
                                  color: c.danger,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onProcess,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: c.primary,
                            foregroundColor: c.onPrimary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(l10n.admin_refundRequests_process,
                              style: tokens.typography.bodyMedium.copyWith(
                                  color: c.onPrimary,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
    );
  }
}

// ── Shared helpers ───────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final dynamic tokens;
  final Color? valueColor;

  const _InfoRow(
      {required this.label,
      required this.value,
      required this.tokens,
      this.valueColor});

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(label,
              style: tokens.typography.bodyMedium
                  .copyWith(color: c.muted, fontWeight: FontWeight.w500)),
          const Spacer(),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.end,
                style: tokens.typography.bodyMedium.copyWith(
                    color: valueColor ?? c.label, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
