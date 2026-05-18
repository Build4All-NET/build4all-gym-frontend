// =============================================================================
// FILE: checkin_member_card.dart
// PATH: lib/features/admin/checkins/presentation/widgets/checkin_member_card.dart
// LAYER: Presentation Layer → Widgets
//
// PURPOSE:
//   One member row in Today's check-in list.
//   Shows: avatar initials | name + time | status badge | action buttons
//
// ACTION BUTTONS:
//   ACTIVE member:     Out | Freeze | Block | Call
//   CHECKED_OUT member: Freeze | Block | Call  (no Out button)
//
// Bottom sheets and dialogs for Freeze and Block are defined in this file
// to keep all checkin-card-related UI together.
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

    return Container(
      margin:  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row: avatar | name + time | status badge ────────────────
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
                    Row(
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
                  ],
                ),
              ),
              _StatusBadge(isActive: isActive, colors: c, l10n: l10n),
            ],
          ),

          const SizedBox(height: 12),

          // ── Action buttons ────────────────────────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Out — only for ACTIVE members
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

                // Freeze
                _ActionButton(
                  icon:  Icons.ac_unit_rounded,
                  label: l10n.checkins_freeze,
                  color: const Color(0xFF1D4ED8),
                  onTap: () => _showFreezeSheet(context, l10n),
                ),
                const SizedBox(width: 8),

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
                  onTap: () => _call(checkin.phone),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Freeze bottom sheet ────────────────────────────────────────────────────
  void _showFreezeSheet(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<CheckinsBloc>(),
        child: _FreezeSheet(userId: checkin.userId, l10n: l10n),
      ),
    );
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
  Future<void> _call(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
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

// ─────────────────────────────────────────────────────────────────────────────
// Freeze bottom sheet
// ─────────────────────────────────────────────────────────────────────────────
class _FreezeSheet extends StatefulWidget {
  final int             userId;
  final AppLocalizations l10n;
  const _FreezeSheet({required this.userId, required this.l10n});

  @override
  State<_FreezeSheet> createState() => _FreezeSheetState();
}

class _FreezeSheetState extends State<_FreezeSheet> {
  DateTime? _fromDate;
  DateTime? _toDate;
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _pickDate(bool isFrom) async {
    final now    = DateTime.now();
    final result = await showDatePicker(
      context:      context,
      initialDate:  isFrom ? (_fromDate ?? now) : (_toDate ?? now.add(const Duration(days: 7))),
      firstDate:    now,
      lastDate:     now.add(const Duration(days: 365)),
    );
    if (result == null) return;
    setState(() {
      if (isFrom) _fromDate = result;
      else        _toDate   = result;
    });
  }

  void _submit() {
    if (_fromDate == null || _toDate == null) return;
    context.read<CheckinsBloc>().add(FreezeMember(
      userId:   widget.userId,
      fromDate: _fmt(_fromDate!),
      toDate:   _fmt(_toDate!),
      reason:   _reasonController.text.trim(),
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    return Padding(
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.checkins_freezeTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 20),

          // From date
          _DateRow(
            label:   l10n.checkins_fromDate,
            date:    _fromDate,
            onTap:   () => _pickDate(true),
          ),
          const SizedBox(height: 12),

          // To date
          _DateRow(
            label:   l10n.checkins_toDate,
            date:    _toDate,
            onTap:   () => _pickDate(false),
          ),
          const SizedBox(height: 12),

          // Reason
          TextField(
            controller: _reasonController,
            decoration: InputDecoration(
              hintText:        l10n.checkins_reasonHint,
              border:          OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding:  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: (_fromDate != null && _toDate != null) ? _submit : null,
            child: Text(l10n.checkins_confirm),
          ),
        ],
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  final String    label;
  final DateTime? date;
  final VoidCallback onTap;
  const _DateRow({required this.label, required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final text = date == null
        ? label
        : '${date!.year}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}';

    return OutlinedButton.icon(
      onPressed: onTap,
      icon:  const Icon(Icons.calendar_today_rounded, size: 16),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
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
