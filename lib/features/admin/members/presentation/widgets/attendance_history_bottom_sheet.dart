import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/backend_error_code_translator.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../domain/entities/member_attendance_item_entity.dart';
import '../bloc/admin_members_bloc.dart';

class AttendanceHistoryBottomSheet extends StatelessWidget {
  final int    userId;
  final String memberName;

  const AttendanceHistoryBottomSheet({
    super.key,
    required this.userId,
    required this.memberName,
  });

  static void show(BuildContext context,
      {required int userId, required String memberName}) {
    context.read<AdminMembersBloc>().add(MemberAttendanceRequested(userId));
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<AdminMembersBloc>(),
        child: AttendanceHistoryBottomSheet(
            userId: userId, memberName: memberName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs        = Theme.of(context).colorScheme;
    final navHeight = MediaQuery.of(context).viewPadding.bottom;
    final l10n      = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 20, 20, navHeight + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle + title row
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: cs.outline.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.admin_members_attendanceHistoryTitle,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface)),
                  Text(memberName,
                      style: TextStyle(
                          fontSize: 13,
                          color: cs.onSurface.withOpacity(0.5))),
                ],
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.close, color: cs.onSurface),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Content driven by BLoC
          BlocBuilder<AdminMembersBloc, AdminMembersState>(
            buildWhen: (_, curr) =>
                curr is MemberAttendanceLoading ||
                curr is MemberAttendanceLoaded  ||
                curr is MemberAttendanceError,
            builder: (context, state) {
              if (state is MemberAttendanceLoading) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                      child: CircularProgressIndicator(color: cs.primary)),
                );
              }

              if (state is MemberAttendanceError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline, color: cs.error, size: 36),
                        const SizedBox(height: 8),
                        Text(translateBackendErrorCode(l10n, state.errorCode),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: cs.error, fontSize: 13)),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => context
                              .read<AdminMembersBloc>()
                              .add(MemberAttendanceRequested(userId)),
                          child: Text(l10n.retry),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is MemberAttendanceLoaded) {
                if (state.items.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text(
                        l10n.admin_members_noAttendanceRecords,
                        style: TextStyle(
                            color: cs.onSurface.withOpacity(0.4),
                            fontSize: 14),
                      ),
                    ),
                  );
                }

                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: state.items.length,
                    separatorBuilder: (_, __) => Divider(
                        height: 1, color: cs.outline.withOpacity(0.12)),
                    itemBuilder: (_, i) =>
                        _AttendanceRow(item: state.items[i]),
                  ),
                );
              }

              return const SizedBox(height: 40);
            },
          ),
        ],
      ),
    );
  }
}

class _AttendanceRow extends StatelessWidget {
  final MemberAttendanceItemEntity item;
  const _AttendanceRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final statusColor =
        item.isActive ? const Color(0xFF10B981) : cs.onSurface.withOpacity(0.4);
    final statusLabel = item.isActive
        ? l10n.admin_members_inGym
        : l10n.admin_members_checkedOut;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Date column
          Container(
            width: 50,
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  item.date.split(' ').length >= 2
                      ? item.date.split(' ')[0]
                      : item.date,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface),
                ),
                Text(
                  item.date.split(' ').length >= 2
                      ? item.date.split(' ')[1]
                      : '',
                  style: TextStyle(
                      fontSize: 11,
                      color: cs.onSurface.withOpacity(0.5)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // Time + duration
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.login_rounded, size: 13,
                        color: cs.onSurface.withOpacity(0.4)),
                    const SizedBox(width: 4),
                    Text(item.checkinTime,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface)),
                    if (item.checkoutTime != null) ...[
                      Text('  →  ',
                          style: TextStyle(
                              color: cs.onSurface.withOpacity(0.3))),
                      Icon(Icons.logout_rounded, size: 13,
                          color: cs.onSurface.withOpacity(0.4)),
                      const SizedBox(width: 4),
                      Text(item.checkoutTime!,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: cs.onSurface)),
                    ],
                  ],
                ),
                if (item.durationMinutes != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      l10n.memberHomeDurationMinutes(item.durationMinutes!),
                      style: TextStyle(
                          fontSize: 11,
                          color: cs.onSurface.withOpacity(0.5)),
                    ),
                  ),
              ],
            ),
          ),

          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: statusColor),
            ),
          ),
        ],
      ),
    );
  }
}
