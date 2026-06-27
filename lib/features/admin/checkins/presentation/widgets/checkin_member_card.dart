// =============================================================================
// FILE: checkin_member_card.dart
// PATH: lib/features/admin/checkins/presentation/widgets/checkin_member_card.dart
// LAYER: Presentation Layer → Widgets
//
// PURPOSE:
//   One member row in Today's check-in list.
//   Shows: avatar initials | name + time | status badge | action buttons
//
// ENTRY TYPE BADGE:
//   Shows why the member was let in today — Plan / Class / PT Session —
//   derived from the backend's `entryType` (GYM/CLASS/PT). Older check-ins
//   created before this field existed simply omit the badge.
//
// ACTION BUTTONS:
//   ACTIVE member:      Out | Block | Call
//   CHECKED_OUT member:  Block | Call  (no Out button)
//
// The block confirmation dialog is defined in this file to keep all
// checkin-card-related UI together.
// =============================================================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../domain/entities/checkin.dart';
import '../bloc/checkins_bloc.dart';

class CheckinMemberCard extends StatelessWidget {
  const CheckinMemberCard({super.key, required this.checkin});

  final Checkin checkin;

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;
    final l10n   = AppLocalizations.of(context)!;
    final isActive = checkin.isActive;

    final entryMeta = _entryTypeMeta(checkin.entryType, l10n);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color:        c.surface,
        borderRadius: BorderRadius.circular(tokens.card.radius),
        boxShadow: tokens.card.showShadow
            ? [
          BoxShadow(
            color:      Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset:     const Offset(0, 2),
          )
        ]
            : null,
        border: tokens.card.showBorder
            ? Border.all(color: c.border.withOpacity(0.15))
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Status accent bar ────────────────────────────────────────────
          Container(
            width: 4,
            color: isActive ? c.success : c.border.withOpacity(0.5),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Top row: avatar | name + time | status badge ────────
                  Row(
                    children: [
                      _Avatar(initials: checkin.avatarInitials, color: c.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              checkin.fullName,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize:   15,
                                color:      c.label,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Wrap(
                              spacing:   8,
                              runSpacing: 2,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.access_time_rounded,
                                        size: 13, color: c.muted),
                                    const SizedBox(width: 4),
                                    Text(
                                      checkin.checkinTime,
                                      style: TextStyle(fontSize: 12, color: c.muted),
                                    ),
                                  ],
                                ),
                                if (!isActive && checkin.durationMinutes != null)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.timelapse_rounded,
                                          size: 13, color: c.muted),
                                      const SizedBox(width: 4),
                                      Text(
                                        l10n.checkins_durationMinutes(checkin.durationMinutes!),
                                        style: TextStyle(fontSize: 12, color: c.muted),
                                      ),
                                    ],
                                  ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.repeat_rounded, size: 13, color: c.muted),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${l10n.checkins_visits}: ${checkin.visitCount}',
                                      style: TextStyle(fontSize: 12, color: c.muted),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      _StatusBadge(isActive: isActive, colors: c, l10n: l10n),
                    ],
                  ),

                  // ── Entry-type badge: why this member was let in today ──
                  if (entryMeta != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color:        entryMeta.color.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(entryMeta.icon, size: 13, color: entryMeta.color),
                          const SizedBox(width: 4),
                          Text(
                            entryMeta.label,
                            style: TextStyle(
                              fontSize:   11,
                              fontWeight: FontWeight.w600,
                              color:      entryMeta.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 12),

                  // ── Action buttons ──────────────────────────────────────
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // Out — manual checkout, only while ACTIVE
                        if (isActive) ...[
                          _ActionButton(
                            icon:  Icons.logout_rounded,
                            label: l10n.checkins_out,
                            color: c.success,
                            onTap: () => context
                                .read<CheckinsBloc>()
                                .add(CheckOutMember(checkin.checkinId)),
                          ),
                          const SizedBox(width: 8),
                        ],

                        // Block
                        _ActionButton(
                          icon:  Icons.block_rounded,
                          label: l10n.checkins_block,
                          color: c.error,
                          onTap: () => _showBlockDialog(context, l10n),
                        ),
                        const SizedBox(width: 8),

                        // Call
                        _ActionButton(
                          icon:  Icons.phone_rounded,
                          label: l10n.checkins_call,
                          color: c.muted,
                          onTap: () => _call(context, checkin.phone, l10n),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Entry-type badge metadata ─────────────────────────────────────────────
  _EntryTypeMeta? _entryTypeMeta(String? entryType, AppLocalizations l10n) {
    switch (entryType) {
      case 'PT':
        return _EntryTypeMeta(Icons.fitness_center_rounded, l10n.checkins_entryPt, const Color(0xFF7C3AED));
      case 'CLASS':
        return _EntryTypeMeta(Icons.event_available_rounded, l10n.checkins_entryClass, const Color(0xFF1D4ED8));
      case 'GYM':
        return _EntryTypeMeta(Icons.card_membership_rounded, l10n.checkins_entryPlan, const Color(0xFF059669));
      default:
        return null;
    }
  }

  // ── Block confirmation dialog ──────────────────────────────────────────────
  void _showBlockDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<CheckinsBloc>(),
        child: _BlockDialog(userId: checkin.userId, l10n: l10n),
      ),
    );
  }

  // ── Phone call ─────────────────────────────────────────────────────────────
  Future<void> _call(BuildContext context, String phone, AppLocalizations l10n) async {
    if (phone.trim().isEmpty) {
      _showCallError(context, l10n.checkins_noPhoneNumber);
      return;
    }
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (context.mounted) {
      _showCallError(context, l10n.checkins_callFailed);
    }
  }

  void _showCallError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:         Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red[700],
        duration:        const Duration(seconds: 3),
        behavior:        SnackBarBehavior.floating,
      ),
    );
  }
}

// ── Avatar circle ─────────────────────────────────────────────────────────────
class _Avatar extends StatelessWidget {
  final String initials;
  final Color  color;
  const _Avatar({required this.initials, required this.color});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius:          22,
      backgroundColor: color.withOpacity(0.15),
      child: Text(
        initials,
        style: TextStyle(
          color:      color,
          fontWeight: FontWeight.w700,
          fontSize:   15,
        ),
      ),
    );
  }
}

// ── Status badge chip ─────────────────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final bool isActive;
  final dynamic colors;
  final AppLocalizations l10n;
  const _StatusBadge(
      {required this.isActive, required this.colors, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final color = isActive ? colors.success : colors.muted;
    final label = isActive ? l10n.checkins_active : l10n.checkins_checkedOut;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color:        color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border:       Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color:      color,
          fontSize:   11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── Outlined action button ────────────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final IconData     icon;
  final String       label;
  final Color        color;
  final VoidCallback onTap;
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon:  Icon(icon, size: 14, color: color),
      label: Text(label,
          style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
      style: OutlinedButton.styleFrom(
        side:    BorderSide(color: color.withOpacity(0.6)),
        shape:   RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

// ── Entry-type badge data ─────────────────────────────────────────────────────
class _EntryTypeMeta {
  final IconData icon;
  final String   label;
  final Color    color;
  const _EntryTypeMeta(this.icon, this.label, this.color);
}

// ─────────────────────────────────────────────────────────────────────────────
// Block confirmation dialog
// ─────────────────────────────────────────────────────────────────────────────
class _BlockDialog extends StatefulWidget {
  final int             userId;
  final AppLocalizations l10n;
  const _BlockDialog({required this.userId, required this.l10n});

  @override
  State<_BlockDialog> createState() => _BlockDialogState();
}

class _BlockDialogState extends State<_BlockDialog> {
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<CheckinsBloc>().add(BlockMember(
      userId: widget.userId,
      reason: _reasonController.text.trim(),
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    return AlertDialog(
      title: Text(l10n.checkins_blockTitle),
      content: TextField(
        controller:  _reasonController,
        decoration:  InputDecoration(
          hintText: l10n.checkins_reasonHint,
          border:   OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        maxLines: 2,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.checkins_cancel),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700]),
          child: Text(l10n.checkins_blockConfirm,
              style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
