import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../../AppBar/presentation/admin_app_bar.dart';
import '../../../navigation/presentation/widgets/admin_navigation_drawer.dart';
import '../../domain/entities/membership_request_entity.dart';
import '../bloc/admin_membership_requests_bloc.dart';

class AdminMembershipRequestsScreen extends StatefulWidget {
  const AdminMembershipRequestsScreen({super.key});

  @override
  State<AdminMembershipRequestsScreen> createState() =>
      _AdminMembershipRequestsScreenState();
}

class _AdminMembershipRequestsScreenState
    extends State<AdminMembershipRequestsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminMembershipRequestsBloc>().add(LoadMembershipRequestsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final profile = context.watch<AdminProfileCubit>().state;

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
        child: Column(
          children: [
            AdminAppBar(title: 'طلبات الاشتراك'),
            Expanded(
              child: BlocConsumer<AdminMembershipRequestsBloc,
                  AdminMembershipRequestsState>(
                listener: (context, state) {
                  if (state is AdminMembershipRequestsActionSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(state.message),
                      backgroundColor: c.success,
                    ));
                  } else if (state is AdminMembershipRequestsActionFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(state.message),
                      backgroundColor: c.danger,
                    ));
                  }
                },
                builder: (context, state) {
                  if (state is AdminMembershipRequestsLoading) {
                    return Center(
                        child: CircularProgressIndicator(color: c.primary));
                  }
                  if (state is AdminMembershipRequestsError) {
                    return Center(
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
                            child: const Text('إعادة المحاولة'),
                          ),
                        ],
                      ),
                    );
                  }

                  final requests = switch (state) {
                    AdminMembershipRequestsLoaded s => s.requests,
                    AdminMembershipRequestsActionSuccess s => s.requests,
                    AdminMembershipRequestsActionFailure s => s.requests,
                    _ => null,
                  };
                  final actingOnId = state is AdminMembershipRequestsLoaded
                      ? state.actingOnId
                      : null;

                  if (requests == null) return const SizedBox.shrink();

                  if (requests.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_outline,
                              color: c.success, size: 56),
                          const SizedBox(height: 16),
                          Text('لا توجد طلبات معلقة',
                              style: tokens.typography.titleMedium
                                  .copyWith(color: c.label)),
                          const SizedBox(height: 8),
                          Text('سيظهر هنا أي طلب دفع نقدي جديد',
                              style: tokens.typography.bodyMedium
                                  .copyWith(color: c.muted)),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: c.primary,
                    onRefresh: () async => context
                        .read<AdminMembershipRequestsBloc>()
                        .add(LoadMembershipRequestsEvent()),
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final req = requests[index];
                        return _RequestCard(
                          request: req,
                          isActing: actingOnId == req.requestId,
                          tokens: tokens,
                          onApprove: () =>
                              _showApproveSheet(context, req, tokens),
                          onReject: () =>
                              _showRejectSheet(context, req, tokens),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showApproveSheet(BuildContext context,
      MembershipRequestEntity req, dynamic tokens) {
    final notesController = TextEditingController();
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
          bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 32,
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('تأكيد استلام الدفع',
                  style: tokens.typography.headlineSmall.copyWith(
                      color: tokens.colors.label,
                      fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Text(
                'الاشتراك: ${req.planName}\nالمبلغ: \$ ${req.totalAmount.toStringAsFixed(2)}',
                style: tokens.typography.bodyMedium
                    .copyWith(color: tokens.colors.muted),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: notesController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'ملاحظة (اختياري)',
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
                  Navigator.pop(sheetCtx);
                  context.read<AdminMembershipRequestsBloc>().add(
                        ApproveMembershipRequestEvent(
                          requestId: req.requestId,
                          amountPaid: req.totalAmount,
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
                    'موافقة — تم استلام \$ ${req.totalAmount.toStringAsFixed(2)}',
                    style: tokens.typography.bodyMedium.copyWith(
                        color: tokens.colors.onPrimary,
                        fontWeight: FontWeight.w900)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRejectSheet(BuildContext context,
      MembershipRequestEntity req, dynamic tokens) {
    final reasonController = TextEditingController();
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
          bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 32,
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('رفض الطلب',
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
                textAlign: TextAlign.right,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'سبب الرفض (إلزامي)',
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
                    ScaffoldMessenger.of(sheetCtx).showSnackBar(
                        const SnackBar(content: Text('يرجى إدخال سبب الرفض')));
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
                child: Text('رفض الطلب',
                    style: tokens.typography.bodyMedium.copyWith(
                        color: tokens.colors.onPrimary,
                        fontWeight: FontWeight.w900)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: c.primary),
              ),
            )
          : Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
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
                        child: Text('معلق',
                            style: tokens.typography.bodySmall.copyWith(
                                color: const Color(0xFF856404),
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _InfoRow(
                      label: 'الخطة', value: request.planName, tokens: tokens),
                  _InfoRow(
                      label: 'الفرع',
                      value: request.branchName,
                      tokens: tokens),
                  _InfoRow(
                      label: 'المبلغ',
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
                          child: Text('رفض',
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
                          child: Text('موافقة',
                              style: tokens.typography.bodyMedium.copyWith(
                                  color: c.onPrimary,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

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
          Text(value,
              style: tokens.typography.bodyMedium.copyWith(
                  color: valueColor ?? c.label, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
