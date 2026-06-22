import 'package:build4allgym/common/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/member_detail_entity.dart';
import '../../../../../l10n/app_localizations.dart';
import '../bloc/admin_members_bloc.dart';
import 'attendance_history_bottom_sheet.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key, required this.member});

  final MemberDetailEntity member;

  bool get _hasPhone => member.phone?.isNotEmpty == true;

  @override
  Widget build(BuildContext context) {
    final cs   = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final bloc = context.read<AdminMembersBloc>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.admin_dashboard_quickActions,
            style: TextStyle(
              color:      cs.onSurface,
              fontSize:   16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount:   3,
            shrinkWrap:       true,
            physics:          const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing:  12,
            childAspectRatio: 1.1,
            children: [
              _ActionButton(
                icon:     Icons.phone_outlined,
                label:    l10n.admin_members_actionCall,
                color:    cs.primary,
                disabled: !_hasPhone,
                onTap:    () => _launchPhone(context),
              ),
              _ActionButton(
                icon:     Icons.chat_bubble_outline,
                label:    l10n.admin_members_actionWhatsApp,
                color:    const Color(0xFF25D366),
                disabled: !_hasPhone,
                onTap:    () => _launchWhatsApp(context),
              ),
              _ActionButton(
                icon:     Icons.sms_outlined,
                label:    l10n.admin_members_actionSms,
                color:    cs.tertiary,
                disabled: !_hasPhone,
                onTap:    () => _launchSms(context),
              ),
              _ActionButton(
                icon:  Icons.calendar_today_outlined,
                label: l10n.admin_members_actionAttendance,
                color: cs.primary,
                onTap: () => AttendanceHistoryBottomSheet.show(
                  context,
                  userId:     member.userId,
                  memberName: member.fullName ?? l10n.admin_members_defaultMemberName,
                ),
              ),
              _ActionButton(
                icon:  Icons.refresh_rounded,
                label: l10n.admin_members_actionRenew,
                color: const Color(0xFFF97316),
                onTap: () => _showComingSoon(context, l10n.admin_members_renewFeatureName),
              ),
              _ActionButton(
                icon:  member.isBlocked
                    ? Icons.lock_open_outlined
                    : Icons.block_outlined,
                label: member.isBlocked ? l10n.admin_members_actionUnblock : l10n.admin_members_actionBlock,
                color: member.isBlocked
                    ? const Color(0xFF10B981)
                    : cs.error,
                onTap: () => member.isBlocked
                    ? bloc.add(MemberUnblockRequested(member.userId))
                    : _showBlockDialog(context, bloc),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _launchPhone(BuildContext context) async {
    final uri = Uri.parse('tel:${member.phone}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (context.mounted) {
      _showError(context, AppLocalizations.of(context)!.admin_members_couldNotOpenDialler);
    }
  }

  Future<void> _launchWhatsApp(BuildContext context) async {
    final digits = member.phone!.replaceAll(RegExp(r'[^\d+]'), '');
    final uri    = Uri.parse('https://wa.me/$digits');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      _showError(context, AppLocalizations.of(context)!.admin_members_whatsAppNotInstalled);
    }
  }

  Future<void> _launchSms(BuildContext context) async {
    final uri = Uri.parse('sms:${member.phone}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (context.mounted) {
      _showError(context, AppLocalizations.of(context)!.admin_members_couldNotOpenSms);
    }
  }

  void _showBlockDialog(BuildContext context, AdminMembersBloc bloc) {
    final cs   = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cs.surface,
        title: Text(l10n.admin_members_blockTitle, style: TextStyle(color: cs.onSurface)),
        content: TextField(
          controller: reasonController,
          style: TextStyle(color: cs.onSurface),
          decoration: InputDecoration(
            hintText: l10n.admin_members_blockHint,
            hintStyle: TextStyle(color: cs.onSurface.withOpacity(0.4)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: cs.outline)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.general_cancel,
                style: TextStyle(color: cs.onSurface.withOpacity(0.5))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              bloc.add(MemberBlockRequested(
                userId: member.userId,
                reason: reasonController.text.trim(),
              ));
            },
            child: Text(l10n.admin_members_actionBlock, style: TextStyle(color: cs.error)),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    AppToast.info(context, AppLocalizations.of(context)!.admin_members_featureComingSoon(feature));
  }

  void _showError(BuildContext context, String msg) {
    AppToast.error(context, msg);
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.disabled = false,
  });

  final IconData     icon;
  final String       label;
  final Color        color;
  final VoidCallback onTap;
  final bool         disabled;

  @override
  Widget build(BuildContext context) {
    final cs             = Theme.of(context).colorScheme;
    final effectiveColor = disabled ? cs.onSurface.withOpacity(0.25) : color;

    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Opacity(
        opacity: disabled ? 0.5 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            color:        cs.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: effectiveColor, size: 26),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color:      cs.onSurface.withOpacity(0.7),
                  fontSize:   11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
