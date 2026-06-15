import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../../AppBar/presentation/branch_cubit.dart';
import '../../../membership_requests/domain/entities/admin_refund_request_entity.dart';
import '../../../navigation/presentation/widgets/admin_navigation_drawer.dart';
import '../../data/services/admin_pt_package_booking_service.dart';

class AdminPtPackageBookingsScreen extends StatefulWidget {
  const AdminPtPackageBookingsScreen({super.key});

  @override
  State<AdminPtPackageBookingsScreen> createState() =>
      _AdminPtPackageBookingsScreenState();
}

class _AdminPtPackageBookingsScreenState
    extends State<AdminPtPackageBookingsScreen>
    with SingleTickerProviderStateMixin {
  final _service = AdminPtPackageBookingService();
  late final TabController _tabController;

  // ── Cash tab state ────────────────────────────────────────────────────────
  List<Map<String, dynamic>> _bookings = [];
  bool _cashLoading = true;
  String? _cashError;
  final Set<int> _confirming = {};
  final Set<int> _rejecting = {};

  // ── Refund tab state ──────────────────────────────────────────────────────
  List<AdminRefundRequestEntity> _refunds = [];
  bool _refundLoading = true;
  String? _refundError;
  final Set<int> _approvingRefund = {};
  final Set<int> _rejectingRefund = {};

  int? _selectedBranchId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadCash();
    _loadRefunds();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── Loaders ───────────────────────────────────────────────────────────────

  Future<void> _loadCash() async {
    setState(() {
      _cashLoading = true;
      _cashError = null;
    });
    try {
      final data = await _service.getPendingCash();
      if (mounted) {
        setState(() {
          _bookings = data;
          _cashLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _cashError = e.toString();
          _cashLoading = false;
        });
      }
    }
  }

  Future<void> _loadRefunds() async {
    setState(() {
      _refundLoading = true;
      _refundError = null;
    });
    try {
      final data = await _service.getPtPackageRefunds();
      if (mounted) {
        setState(() {
          _refunds = data;
          _refundLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _refundError = e.toString();
          _refundLoading = false;
        });
      }
    }
  }

  // ── Cash actions ──────────────────────────────────────────────────────────

  Future<void> _confirmCash(int bookingId) async {
    setState(() => _confirming.add(bookingId));
    try {
      await _service.confirmCash(bookingId);
      if (mounted) {
        setState(() {
          _bookings.removeWhere((b) => (b['id'] as num?)?.toInt() == bookingId);
          _confirming.remove(bookingId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.trainer_cashPaymentConfirmed)),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _confirming.remove(bookingId));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showRejectCashDialog(int bookingId) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.read<ThemeCubit>().state.tokens;
    final reasonCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: tokens.colors.surface,
        title: Text(
          l10n.trainer_rejectPaymentTitle,
          style: TextStyle(color: tokens.colors.label, fontWeight: FontWeight.w700),
        ),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: reasonCtrl,
            decoration: InputDecoration(
              labelText: l10n.trainer_rejectPaymentHint,
              labelStyle: TextStyle(color: tokens.colors.muted),
            ),
            style: TextStyle(color: tokens.colors.label),
            maxLines: 3,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? l10n.trainer_rejectPaymentReasonRequired
                : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.general_cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: tokens.colors.danger,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              Navigator.pop(ctx);
              _rejectCash(bookingId, reasonCtrl.text.trim());
            },
            child: Text(l10n.trainer_rejectCashPayment),
          ),
        ],
      ),
    );
  }

  Future<void> _rejectCash(int bookingId, String reason) async {
    setState(() => _rejecting.add(bookingId));
    try {
      await _service.rejectCash(bookingId, reason);
      if (mounted) {
        setState(() {
          _bookings.removeWhere((b) => (b['id'] as num?)?.toInt() == bookingId);
          _rejecting.remove(bookingId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.trainer_cashPaymentRejected)),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _rejecting.remove(bookingId));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  // ── Refund actions ────────────────────────────────────────────────────────

  void _showApproveRefundSheet(AdminRefundRequestEntity req) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final amountCtrl =
        TextEditingController(text: req.requestedAmount.toStringAsFixed(2));
    final deductionCtrl = TextEditingController(text: '0.00');
    final noteCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(sheetCtx).viewInsets.bottom +
              MediaQuery.of(sheetCtx).padding.bottom +
              24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.admin_refundRequests_processTitle,
                style: tokens.typography.headlineSmall.copyWith(
                    color: tokens.colors.label, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              Text(
                '${req.memberName} — ${req.planName}',
                style: tokens.typography.bodyMedium
                    .copyWith(color: tokens.colors.muted),
              ),
              const SizedBox(height: 4),
              Text(
                '${l10n.admin_refundRequests_requestedAmount}: \$ ${req.requestedAmount.toStringAsFixed(2)}',
                style: tokens.typography.bodySmall.copyWith(
                    color: tokens.colors.primary, fontWeight: FontWeight.w700),
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
                      color: tokens.colors.label, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextField(
                controller: amountCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
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
                      color: tokens.colors.label, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextField(
                controller: deductionCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
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
                controller: noteCtrl,
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
                      double.tryParse(amountCtrl.text.trim());
                  if (refundAmount == null || refundAmount <= 0) {
                    ScaffoldMessenger.of(sheetCtx).showSnackBar(SnackBar(
                        content:
                            Text(l10n.admin_refundRequests_enterAmount)));
                    return;
                  }
                  final deduction =
                      double.tryParse(deductionCtrl.text.trim()) ?? 0.0;
                  Navigator.pop(sheetCtx);
                  _approveRefund(
                    req.refundId,
                    refundAmount,
                    deductionAmount: deduction > 0 ? deduction : null,
                    adminNote: noteCtrl.text.trim().isEmpty
                        ? null
                        : noteCtrl.text.trim(),
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
                      amountCtrl.text.trim()),
                  style: tokens.typography.bodyMedium.copyWith(
                      color: tokens.colors.onPrimary,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRejectRefundDialog(AdminRefundRequestEntity req) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final reasonCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: tokens.colors.surface,
        title: Text(
          l10n.admin_refundRequests_rejectTitle,
          style: TextStyle(
              color: tokens.colors.label, fontWeight: FontWeight.w700),
        ),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: reasonCtrl,
            decoration: InputDecoration(
              labelText: l10n.admin_refundRequests_rejectHint,
              labelStyle: TextStyle(color: tokens.colors.muted),
            ),
            style: TextStyle(color: tokens.colors.label),
            maxLines: 3,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? l10n.admin_refundRequests_enterReason
                : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.general_cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: tokens.colors.danger,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              Navigator.pop(ctx);
              _rejectRefund(req.refundId, reasonCtrl.text.trim());
            },
            child: Text(l10n.admin_refundRequests_rejectButton),
          ),
        ],
      ),
    );
  }

  Future<void> _approveRefund(
    int refundId,
    double refundAmount, {
    double? deductionAmount,
    String? adminNote,
  }) async {
    setState(() => _approvingRefund.add(refundId));
    try {
      await _service.approvePtPackageRefund(
        refundId,
        refundAmount,
        deductionAmount: deductionAmount,
        adminNote: adminNote,
      );
      if (mounted) {
        setState(() {
          _refunds.removeWhere((r) => r.refundId == refundId);
          _approvingRefund.remove(refundId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!
                .admin_refundRequests_approveButton(
                    refundAmount.toStringAsFixed(2))),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _approvingRefund.remove(refundId));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _rejectRefund(int refundId, String reason) async {
    setState(() => _rejectingRefund.add(refundId));
    try {
      await _service.rejectPtPackageRefund(refundId, reason);
      if (mounted) {
        setState(() {
          _refunds.removeWhere((r) => r.refundId == refundId);
          _rejectingRefund.remove(refundId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!
                .admin_refundRequests_rejectButton),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _rejectingRefund.remove(refundId));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final l10n = AppLocalizations.of(context)!;
    final profile = context.watch<AdminProfileCubit>().state;

    return Scaffold(
      backgroundColor: c.background,
      drawer: AdminNavigationDrawer(
        gymName: profile.gymName,
        branchName: profile.branchName,
        adminName: profile.adminName,
        adminEmail: profile.adminEmail,
        avatarUrl: profile.avatarUrl,
        initialActiveId: 'pt-package-bookings',
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context, c, tokens: tokens, l10n: l10n),
            _buildTabBar(c, tokens, l10n),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCashTab(context, c, tokens),
                  _buildRefundTab(context, c, tokens),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(dynamic c, dynamic tokens, AppLocalizations l10n) {
    return Container(
      color: c.surface,
      child: TabBar(
        controller: _tabController,
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
                    l10n.ptPkgPayments_cashTab,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
                if (_bookings.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  _CountBadge(
                      count: _bookings.length,
                      color: const Color(0xFFD97706)),
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
                    l10n.ptPkgPayments_refundTab,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
                if (_refunds.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  _CountBadge(count: _refunds.length, color: c.danger),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCashTab(BuildContext context, dynamic c, dynamic tokens) {
    if (_cashLoading) {
      return Center(child: CircularProgressIndicator(color: c.primary));
    }
    if (_cashError != null) {
      return _ErrorView(error: _cashError!, onRetry: _loadCash, tokens: tokens);
    }
    if (_bookings.isEmpty) {
      return _CashEmptyView(tokens: tokens);
    }
    return RefreshIndicator(
      onRefresh: _loadCash,
      color: c.primary,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _bookings.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, index) {
          final b = _bookings[index];
          final id = (b['id'] as num?)?.toInt() ?? 0;
          return _BookingCard(
            booking: b,
            isConfirming: _confirming.contains(id),
            isRejecting: _rejecting.contains(id),
            tokens: tokens,
            onConfirm: () => _confirmCash(id),
            onReject: () => _showRejectCashDialog(id),
          );
        },
      ),
    );
  }

  Widget _buildRefundTab(BuildContext context, dynamic c, dynamic tokens) {
    final l10n = AppLocalizations.of(context)!;
    if (_refundLoading) {
      return Center(child: CircularProgressIndicator(color: c.primary));
    }
    if (_refundError != null) {
      return _ErrorView(
          error: _refundError!, onRetry: _loadRefunds, tokens: tokens);
    }
    if (_refunds.isEmpty) {
      return _RefundEmptyView(tokens: tokens);
    }
    return RefreshIndicator(
      onRefresh: _loadRefunds,
      color: c.primary,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _refunds.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, index) {
          final r = _refunds[index];
          return _RefundCard(
            refund: r,
            isApproving: _approvingRefund.contains(r.refundId),
            isRejecting: _rejectingRefund.contains(r.refundId),
            tokens: tokens,
            l10n: l10n,
            onApprove: () => _showApproveRefundSheet(r),
            onReject: () => _showRejectRefundDialog(r),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, dynamic c,
      {required dynamic tokens, required AppLocalizations l10n}) {
    final card = tokens.card;
    return Container(
      color: c.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Builder(
            builder: (ctx) => IconButton(
              icon: Icon(Icons.menu_rounded, color: c.label),
              onPressed: () => Scaffold.of(ctx).openDrawer(),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: BlocBuilder<BranchCubit, BranchState>(
              builder: (context, branchState) {
                if (branchState is BranchLoading || branchState is BranchInitial) {
                  return _branchPillPlaceholder(c, isLoading: true);
                }
                if (branchState is! BranchLoaded) {
                  return _branchPillPlaceholder(c, isLoading: false);
                }
                final branches = branchState.branches;
                final selectedName = _selectedBranchId == null
                    ? l10n.admin_dashboard_allBranches
                    : branches
                            .where((b) => b.id == _selectedBranchId)
                            .map((b) => b.name)
                            .firstOrNull ??
                        l10n.admin_dashboard_allBranches;
                return PopupMenuButton<int?>(
                  offset: const Offset(0, 44),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(card.radius)),
                  color: c.surface,
                  elevation: 8,
                  onSelected: (int? id) =>
                      setState(() => _selectedBranchId = id),
                  itemBuilder: (context) => [
                    PopupMenuItem<int?>(
                      value: null,
                      child: _branchMenuItem(
                          c: c,
                          icon: Icons.business_rounded,
                          name: l10n.admin_dashboard_allBranches,
                          isSelected: _selectedBranchId == null),
                    ),
                    ...branches.map(
                      (b) => PopupMenuItem<int?>(
                        value: b.id,
                        child: _branchMenuItem(
                            c: c,
                            icon: Icons.location_on_rounded,
                            name: b.name,
                            isSelected: b.id == _selectedBranchId),
                      ),
                    ),
                  ],
                  child: _branchPill(c, selectedName),
                );
              },
            ),
          ),
          Flexible(
            child: Text(
              l10n.navPtPackageBookings,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: c.label),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Stack(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: c.border.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.notifications_none_rounded,
                    color: c.body, size: 18),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                      color: c.danger, shape: BoxShape.circle),
                  child: const Center(
                    child: Text('3',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _branchPill(dynamic c, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: c.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on_rounded, size: 14, color: c.primary),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: c.primary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 3),
          Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: c.primary),
        ],
      ),
    );
  }

  Widget _branchPillPlaceholder(dynamic c, {required bool isLoading}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: c.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: isLoading
          ? SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                  strokeWidth: 1.5, color: c.primary),
            )
          : Text('—',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: c.primary)),
    );
  }

  Widget _branchMenuItem(
      {required dynamic c,
      required IconData icon,
      required String name,
      required bool isSelected}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: c.primary),
        const SizedBox(width: 10),
        Text(
          name,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: c.body,
          ),
        ),
        const Spacer(),
        if (isSelected) Icon(Icons.check_rounded, size: 16, color: c.primary),
      ],
    );
  }
}

// ── Count badge ───────────────────────────────────────────────────────────────

class _CountBadge extends StatelessWidget {
  final int count;
  final Color color;
  const _CountBadge({required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: Text(
        '$count',
        style: const TextStyle(
            color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
      ),
    );
  }
}

// ── Cash booking card ─────────────────────────────────────────────────────────

class _BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  final bool isConfirming;
  final bool isRejecting;
  final dynamic tokens;
  final VoidCallback onConfirm;
  final VoidCallback onReject;

  const _BookingCard({
    required this.booking,
    required this.isConfirming,
    required this.isRejecting,
    required this.tokens,
    required this.onConfirm,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    final l10n = AppLocalizations.of(context)!;

    final id = (booking['id'] as num?)?.toInt() ?? 0;
    final totalAmount = (booking['totalAmount'] as num?)?.toDouble() ?? 0.0;
    final status = booking['status'] as String? ?? '';
    final paymentStatus = booking['paymentStatus'] as String? ?? '';
    final createdAt = booking['createdAt'] as String?;

    String formattedDate = '';
    if (createdAt != null) {
      try {
        formattedDate =
            DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(createdAt));
      } catch (_) {
        formattedDate = createdAt;
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.border.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3CD),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'CASH',
                  style: tokens.typography.bodySmall.copyWith(
                    color: const Color(0xFF856404),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: c.primary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: tokens.typography.bodySmall.copyWith(
                    color: c.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '\$ ${totalAmount.toStringAsFixed(2)}',
                style: tokens.typography.headlineSmall.copyWith(
                  color: c.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _Row(label: l10n.trainer_bookingId, value: '#$id', tokens: tokens),
          if (formattedDate.isNotEmpty)
            _Row(label: l10n.trainer_dateLabel, value: formattedDate, tokens: tokens),
          _Row(
              label: l10n.trainer_paymentStatusLabel,
              value: paymentStatus,
              tokens: tokens),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed:
                        (isConfirming || isRejecting) ? null : onConfirm,
                    icon: isConfirming
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.check_circle_outline, size: 18),
                    label: Text(isConfirming
                        ? l10n.trainer_confirming
                        : l10n.trainer_confirmCashPayment),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: c.success,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: c.success.withOpacity(0.5),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed:
                        (isConfirming || isRejecting) ? null : onReject,
                    icon: isRejecting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.cancel_outlined, size: 18),
                    label: Text(isRejecting
                        ? l10n.trainer_rejecting
                        : l10n.trainer_rejectCashPayment),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: c.danger,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: c.danger.withOpacity(0.5),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
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

// ── Refund request card ───────────────────────────────────────────────────────

class _RefundCard extends StatelessWidget {
  final AdminRefundRequestEntity refund;
  final bool isApproving;
  final bool isRejecting;
  final dynamic tokens;
  final AppLocalizations l10n;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _RefundCard({
    required this.refund,
    required this.isApproving,
    required this.isRejecting,
    required this.tokens,
    required this.l10n,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.danger.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
              color: c.label.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: (isApproving || isRejecting)
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: c.primary),
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
                          Text(refund.memberName,
                              style: tokens.typography.titleMedium.copyWith(
                                  color: c.label,
                                  fontWeight: FontWeight.w800)),
                          Text(refund.memberEmail,
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
                      child: Text(
                        l10n.ptPkgPayments_refundBadge,
                        style: tokens.typography.bodySmall.copyWith(
                            color: c.danger, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _Row(
                    label: l10n.admin_membershipRequests_plan,
                    value: refund.planName,
                    tokens: tokens),
                _Row(
                    label: l10n.admin_refundRequests_requestedAmount,
                    value: '\$ ${refund.requestedAmount.toStringAsFixed(2)}',
                    tokens: tokens,
                    valueColor: c.danger),
                if (refund.reason != null && refund.reason!.isNotEmpty)
                  _Row(
                      label: l10n.admin_refundRequests_reason,
                      value: refund.reason!,
                      tokens: tokens),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 46,
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
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 46,
                        child: ElevatedButton(
                          onPressed: onApprove,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: c.success,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(l10n.admin_refundRequests_process,
                              style: tokens.typography.bodyMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700)),
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

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final dynamic tokens;
  final Color? valueColor;

  const _Row(
      {required this.label,
      required this.value,
      required this.tokens,
      this.valueColor});

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: tokens.typography.bodySmall.copyWith(color: c.muted),
          ),
          Expanded(
            child: Text(
              value,
              style: tokens.typography.bodySmall.copyWith(
                color: valueColor ?? c.label,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty / Error views ───────────────────────────────────────────────────────

class _CashEmptyView extends StatelessWidget {
  final dynamic tokens;
  const _CashEmptyView({required this.tokens});

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline, size: 56, color: c.success),
          const SizedBox(height: 16),
          Text(
            l10n.trainer_noPendingCashPayments,
            style: tokens.typography.titleMedium
                .copyWith(color: c.label, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.trainer_allPtPackagesConfirmed,
            style: tokens.typography.bodyMedium.copyWith(color: c.muted),
          ),
        ],
      ),
    );
  }
}

class _RefundEmptyView extends StatelessWidget {
  final dynamic tokens;
  const _RefundEmptyView({required this.tokens});

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.money_off_outlined, size: 56, color: c.muted),
          const SizedBox(height: 16),
          Text(
            l10n.ptPkgPayments_noPendingRefunds,
            style: tokens.typography.titleMedium
                .copyWith(color: c.label, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.ptPkgPayments_noPendingRefundsDesc,
            style: tokens.typography.bodyMedium.copyWith(color: c.muted),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  final dynamic tokens;

  const _ErrorView({
    required this.error,
    required this.onRetry,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: c.danger),
          const SizedBox(height: 12),
          Text(error,
              style: tokens.typography.bodyMedium.copyWith(color: c.muted)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(AppLocalizations.of(context)!.retry),
          ),
        ],
      ),
    );
  }
}
