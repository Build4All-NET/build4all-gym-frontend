// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/widgets/session_card_widget.dart
//
// CHANGES:
//   1. Added isAdmin param (defaults to false) - shows a trainer badge when true
//      and session.trainerName is set.
//   2. Fixed compile error - previously called with isAdmin+trainers but widget
//      didn't declare them; now properly declared.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../domain/entities/pt_session_entity.dart';
import '../bloc/sessions/trainer_pt_sessions_bloc.dart';
import '../bloc/sessions/trainer_pt_sessions_event.dart';

class SessionCardWidget extends StatelessWidget {
  final PtSessionEntity session;

  /// True when the logged-in user is ADMIN / OWNER.
  /// Causes a "By <TrainerName>" badge to appear on the card.
  final bool isAdmin;

  const SessionCardWidget({
    super.key,
    required this.session,
    this.isAdmin = false,
  });

  /// Standalone (non-package) sessions don't get paid automatically the way
  /// package sessions do — Admin/Owner/Manager can record payment manually.
  /// Uses the real JWT role (not the loose "admin-mode view" flag, which also
  /// covers reception) since the backend endpoint is Admin/Owner/Manager only.
  bool _canMarkPaid(BuildContext context) =>
      context.read<AdminProfileCubit>().state.isAdminRole &&
      session.serviceId != null &&
      session.memberPtPackageId == null &&
      !session.isPaid;

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final cs     = tokens.colors;
    final l10n   = AppLocalizations.of(context)!;

    return BlocBuilder<TrainerPtSessionsBloc, TrainerPtSessionsState>(
      buildWhen: (prev, curr) {
        if (curr is PtSessionActionLoading) {
          return curr.sessionId == session.ptSessionId;
        }
        return true;
      },
      builder: (context, state) {
        final isLoading = state is PtSessionActionLoading &&
            state.sessionId == session.ptSessionId;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color:        Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color:     Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset:    const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top row: avatar + info + status badge ───────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _AvatarBadge(initials: session.initials),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(session.displayName,
                              style: const TextStyle(
                                  fontSize:   16,
                                  fontWeight: FontWeight.w600,
                                  color:      Color(0xFF1A1A2E))),
                          const SizedBox(height: 2),
                          Text(
                            session.isClass
                                ? (session.notes ?? l10n.trainer_gymClass)
                                : (session.serviceName ??
                                    (session.notes ?? l10n.trainer_ptSession)),
                            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                          ),
                          // Gym class badge
                          if (session.isClass) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF2FF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.fitness_center_rounded,
                                      size: 11, color: Color(0xFF4F46E5)),
                                  const SizedBox(width: 4),
                                  Text(
                                    l10n.trainer_gymClass,
                                    style: const TextStyle(
                                        fontSize:   11,
                                        fontWeight: FontWeight.w600,
                                        color:      Color(0xFF4F46E5)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          // Trainer attribution badge (admin only, PT sessions)
                          if (!session.isClass &&
                              isAdmin &&
                              session.trainerName != null &&
                              session.trainerName!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color:        cs.primary.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.person_rounded,
                                      size: 11, color: cs.primary),
                                  const SizedBox(width: 4),
                                  Text(
                                    l10n.trainer_byName(session.trainerName!),
                                    style: TextStyle(
                                        fontSize:   11,
                                        fontWeight: FontWeight.w600,
                                        color:      cs.primary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    _StatusBadge(status: session.status),
                  ],
                ),

                const SizedBox(height: 12),

                // ── Time + duration ─────────────────────────────────────────
                Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      _formatTime(session.startTime),
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey[700], fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '  ·  ${l10n.memberHomeDurationMinutes(session.durationMinutes)}',
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    ),
                  ],
                ),

                // ── Notes ───────────────────────────────────────────────────
                if (session.notes != null && session.notes!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    width:   double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color:        const Color(0xFFF0F4FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(session.notes!,
                        style: const TextStyle(fontSize: 13, color: Color(0xFF4B5563))),
                  ),
                ],

                // ── Package progress ─────────────────────────────────────────
                if (session.sessionIndex != null &&
                    session.totalPackageSessions != null) ...[
                  const SizedBox(height: 10),
                  _PackageProgress(
                    current:      session.sessionIndex!,
                    total:        session.totalPackageSessions!,
                    primaryColor: cs.primary,
                  ),
                ],

                // ── Cancel request info + action buttons ─────────────────────
                if (session.isCancelRequested) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFDBA74), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.info_outline_rounded,
                                size: 14, color: Color(0xFFEA580C)),
                            const SizedBox(width: 6),
                            Text(
                              AppLocalizations.of(context)!.trainer_statusCancelRequested,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFEA580C),
                              ),
                            ),
                          ],
                        ),
                        if (session.requestedNewDate != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            AppLocalizations.of(context)!.trainer_memberRequestedDate(
                              DateFormat('EEE, MMM d, yyyy').format(session.requestedNewDate!),
                            ),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF78350F),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (isLoading)
                        const SizedBox(
                          width: 24, height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else ...[
                        _ActionButton(
                          label: AppLocalizations.of(context)!.trainer_keepSessionButton,
                          icon: Icons.event_available_rounded,
                          color: const Color(0xFF4F46E5),
                          outlined: true,
                          onTap: () => _confirmDeclineCancel(context),
                        ),
                        const SizedBox(width: 8),
                        _ActionButton(
                          label: AppLocalizations.of(context)!.trainer_approveCancelButton,
                          icon: Icons.check_circle_outline,
                          color: const Color(0xFFEF4444),
                          onTap: () => _confirmApproveCancel(context),
                        ),
                      ],
                    ],
                  ),
                ],

                // ── Accept / Decline buttons (REQUESTED only) ───────────────
                if (session.isRequested) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (isLoading)
                        const SizedBox(
                          width: 24, height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else ...[
                        _ActionButton(
                          label:    l10n.trainer_declineButton,
                          icon:     Icons.close_rounded,
                          color:    const Color(0xFFEF4444),
                          outlined: true,
                          onTap:    () => _confirmDecline(context),
                        ),
                        const SizedBox(width: 8),
                        _ActionButton(
                          label: l10n.trainer_acceptButton,
                          icon:  Icons.check_rounded,
                          color: const Color(0xFF22C55E),
                          onTap: () => context.read<TrainerPtSessionsBloc>().add(
                            PtSessionAcceptRequested(sessionId: session.ptSessionId),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],

                // ── Payment badge + action buttons (SCHEDULED only) ─────────
                if (session.isScheduled) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (session.paymentStatus != null)
                        _PaymentBadge(paymentStatus: session.paymentStatus!),
                      const Spacer(),
                      if (isLoading)
                        const SizedBox(
                          width: 24, height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else ...[
                        if (_canMarkPaid(context)) ...[
                          _ActionButton(
                            label: l10n.trainer_markAsPaidButton,
                            icon:  Icons.attach_money_rounded,
                            color: const Color(0xFF059669),
                            outlined: true,
                            onTap: () => context.read<TrainerPtSessionsBloc>().add(
                                PtSessionMarkPaidRequested(sessionId: session.ptSessionId)),
                          ),
                          const SizedBox(width: 8),
                        ],
                        _ActionButton(
                          label: l10n.trainer_checkInButton,
                          icon:  Icons.how_to_reg_rounded,
                          color: const Color(0xFF4F46E5),
                          outlined: true,
                          onTap: () => context.read<TrainerPtSessionsBloc>().add(
                              PtSessionCheckInRequested(sessionId: session.ptSessionId)),
                        ),
                        const SizedBox(width: 8),
                        _ActionButton(
                          label: l10n.trainer_completeButton,
                          icon:  Icons.check_circle_outline,
                          color: const Color(0xFF22C55E),
                          onTap: () => _updateStatus(
                              context, session.ptSessionId, 'COMPLETED'),
                        ),
                        const SizedBox(width: 8),
                        _ActionButton(
                          label:    l10n.trainer_cancelSessionButton,
                          icon:     Icons.cancel_outlined,
                          color:    const Color(0xFFEF4444),
                          outlined: true,
                          onTap:    () => _confirmCancel(context),
                        ),
                      ],
                    ],
                  ),
                ],

                // ── Payment badge + Mark Paid (COMPLETED standalone sessions) ─
                if (session.isCompleted &&
                    session.serviceId != null &&
                    session.memberPtPackageId == null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (session.paymentStatus != null)
                        _PaymentBadge(paymentStatus: session.paymentStatus!),
                      const Spacer(),
                      if (isLoading)
                        const SizedBox(
                          width: 24, height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else if (_canMarkPaid(context))
                        _ActionButton(
                          label: l10n.trainer_markAsPaidButton,
                          icon:  Icons.attach_money_rounded,
                          color: const Color(0xFF059669),
                          outlined: true,
                          onTap: () => context.read<TrainerPtSessionsBloc>().add(
                              PtSessionMarkPaidRequested(sessionId: session.ptSessionId)),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _formatTime(DateTime dt) => DateFormat('hh:mm a').format(dt);

  void _updateStatus(BuildContext context, int sessionId, String status) {
    context.read<TrainerPtSessionsBloc>().add(
        PtSessionStatusUpdateRequested(sessionId: sessionId, status: status));
  }

  void _confirmDecline(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title:   Text(l10n.trainer_declineRequestTitle),
        content: Text(l10n.trainer_declineRequestMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.trainer_keepButton),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(context);
              context.read<TrainerPtSessionsBloc>().add(
                PtSessionDeclineRequested(sessionId: session.ptSessionId),
              );
            },
            child: Text(l10n.trainer_declineButton),
          ),
        ],
      ),
    );
  }

  void _confirmApproveCancel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.trainer_approveCancelTitle),
        content: Text(l10n.trainer_approveCancelMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.trainer_keepButton),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(context);
              context.read<TrainerPtSessionsBloc>().add(
                PtSessionCancelApproved(sessionId: session.ptSessionId),
              );
            },
            child: Text(l10n.trainer_approveCancelButton),
          ),
        ],
      ),
    );
  }

  void _confirmDeclineCancel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.trainer_declineCancelTitle),
        content: Text(l10n.trainer_declineCancelMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.trainer_keepButton),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(context);
              context.read<TrainerPtSessionsBloc>().add(
                PtSessionCancelDeclined(sessionId: session.ptSessionId),
              );
            },
            child: Text(l10n.trainer_keepSessionButton),
          ),
        ],
      ),
    );
  }

  void _confirmCancel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title:   Text(l10n.trainer_cancelSessionTitle),
        content: Text(l10n.trainer_cancelSessionMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.trainer_keepButton),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(context);
              _updateStatus(context, session.ptSessionId, 'CANCELLED');
            },
            child: Text(l10n.trainer_cancelSessionConfirm),
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _AvatarBadge extends StatelessWidget {
  final String initials;
  const _AvatarBadge({required this.initials});

  Color _avatarColor() {
    const colors = [
      Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFEC4899),
      Color(0xFFF59E0B), Color(0xFF10B981), Color(0xFF3B82F6),
    ];
    final code = initials.codeUnits.fold(0, (a, b) => a + b);
    return colors[code % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width:  44, height: 44,
      decoration: BoxDecoration(color: _avatarColor(), shape: BoxShape.circle),
      child: Center(
        child: Text(initials,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Color  bg;
    Color  fg;
    String label;
    switch (status) {
      case 'REQUESTED':
        bg = const Color(0xFFFFF7ED); fg = const Color(0xFFEA580C); label = l10n.trainer_statusRequested; break;
      case 'CANCEL_REQUESTED':
        bg = const Color(0xFFFEF3C7); fg = const Color(0xFFB45309); label = l10n.trainer_statusCancelRequested; break;
      case 'COMPLETED':
        bg = const Color(0xFFD1FAE5); fg = const Color(0xFF059669); label = l10n.trainer_statusCompleted; break;
      case 'CANCELLED':
        bg = const Color(0xFFFEE2E2); fg = const Color(0xFFDC2626); label = l10n.trainer_statusCancelled; break;
      case 'NO_SHOW':
        bg = const Color(0xFFFEF3C7); fg = const Color(0xFFD97706); label = l10n.trainer_statusNoShow;   break;
      case 'DECLINED':
        bg = const Color(0xFFFEE2E2); fg = const Color(0xFFDC2626); label = l10n.trainer_statusDeclined; break;
      case 'CHECKED_IN':
        bg = const Color(0xFFD1FAE5); fg = const Color(0xFF059669); label = l10n.trainer_statusCheckedIn; break;
      default:
        bg = const Color(0xFFEEF2FF); fg = const Color(0xFF4F46E5); label = l10n.trainer_statusScheduled;
    }
    return Container(
      padding:    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg)),
    );
  }
}

class _PaymentBadge extends StatelessWidget {
  final String paymentStatus;
  const _PaymentBadge({required this.paymentStatus});

  @override
  Widget build(BuildContext context) {
    final isPaid = paymentStatus == 'PAID';
    final isPartial = paymentStatus == 'PARTIAL';
    final bg = isPaid
        ? const Color(0xFFD1FAE5)
        : isPartial
            ? const Color(0xFFFEE2E2)
            : const Color(0xFFFEF3C7);
    final fg = isPaid
        ? const Color(0xFF059669)
        : isPartial
            ? const Color(0xFFDC2626)
            : const Color(0xFFD97706);
    return Container(
      padding:    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color:        bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(paymentStatus,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg)),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String       label;
  final IconData     icon;
  final Color        color;
  final bool         outlined;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    this.outlined = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (outlined) {
      return OutlinedButton.icon(
        onPressed: onTap,
        icon:  Icon(icon, size: 16, color: color),
        label: Text(label, style: TextStyle(color: color, fontSize: 13)),
        style: OutlinedButton.styleFrom(
          side:          BorderSide(color: color.withOpacity(0.6)),
          shape:         RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding:       const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          minimumSize:   Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }
    return ElevatedButton.icon(
      onPressed: onTap,
      icon:  Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 13)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation:  0,
        shape:      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding:    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize:   Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

class _PackageProgress extends StatelessWidget {
  final int   current;
  final int   total;
  final Color primaryColor;

  const _PackageProgress({
    required this.current,
    required this.total,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? current / total : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.trainer_sessionProgress,
                style: TextStyle(fontSize: 12, color: Colors.grey[500])),
            Text('$current/$total',
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600, color: primaryColor)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value:           pct.clamp(0.0, 1.0),
            minHeight:       6,
            backgroundColor: Colors.grey[200],
            valueColor:      AlwaysStoppedAnimation<Color>(primaryColor),
          ),
        ),
      ],
    );
  }
}