// =============================================================================
// FILE: lib/features/trainer/pt_sessions/presentation/widgets/session_card_widget.dart
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../domain/entities/pt_session_entity.dart';
import '../bloc/trainer_pt_sessions_bloc.dart';
import '../bloc/trainer_pt_sessions_event.dart';
import '../bloc/trainer_pt_sessions_state.dart';

class SessionCardWidget extends StatelessWidget {
  final PtSessionEntity session;

  const SessionCardWidget({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final cs = tokens.colors;

    return BlocBuilder<TrainerPtSessionsBloc, TrainerPtSessionsState>(
      buildWhen: (prev, curr) {
        // Only rebuild if this specific card's action state changes.
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top row: avatar + info + status badge ──────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    _AvatarBadge(initials: session.initials),
                    const SizedBox(width: 12),

                    // Member name + service + trainer
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            session.displayName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            session.serviceName ?? (session.notes ?? 'PT Session'),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          if (session.trainerName != null &&
                              session.trainerName!.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              session.trainerName!,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4F46E5),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Status badge
                    _StatusBadge(status: session.status),
                  ],
                ),

                const SizedBox(height: 12),

                // ── Time + duration row ────────────────────────────────────
                Row(
                  children: [
                    Icon(Icons.access_time_rounded,
                        size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      _formatTime(session.startTime),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '  ·  ${session.durationMinutes} min',
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    ),
                  ],
                ),

                // ── Notes ─────────────────────────────────────────────────
                if (session.notes != null && session.notes!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F4FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      session.notes!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF4B5563),
                      ),
                    ),
                  ),
                ],

                // ── Package progress (sessionIndex / totalPackageSessions) ──
                if (session.sessionIndex != null &&
                    session.totalPackageSessions != null) ...[
                  const SizedBox(height: 10),
                  _PackageProgress(
                    current: session.sessionIndex!,
                    total: session.totalPackageSessions!,
                    primaryColor: cs.primary,
                  ),
                ],

                // ── Payment badge + action buttons (SCHEDULED only) ────────
                if (session.isScheduled) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // Payment badge
                      if (session.paymentStatus != null)
                        _PaymentBadge(paymentStatus: session.paymentStatus!),
                      const Spacer(),
                      // Action buttons
                      if (isLoading)
                        const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else ...[
                        _ActionButton(
                          label: 'Complete',
                          icon: Icons.check_circle_outline,
                          color: const Color(0xFF22C55E),
                          onTap: () => _updateStatus(
                              context, session.ptSessionId, 'COMPLETED'),
                        ),
                        const SizedBox(width: 8),
                        _ActionButton(
                          label: 'Cancel',
                          icon: Icons.cancel_outlined,
                          color: const Color(0xFFEF4444),
                          outlined: true,
                          onTap: () => _confirmCancel(context),
                        ),
                      ],
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

  // ── Helpers ──────────────────────────────────────────────────────────────

  String _formatTime(DateTime dt) {
    return DateFormat('hh:mm a').format(dt);
  }

  void _updateStatus(
      BuildContext context, int sessionId, String status) {
    context.read<TrainerPtSessionsBloc>().add(
          PtSessionStatusUpdateRequested(
            sessionId: sessionId,
            status: status,
          ),
        );
  }

  void _confirmCancel(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text('Cancel Session'),
        content: const Text(
            'Are you sure you want to cancel this session?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(context);
              _updateStatus(context, session.ptSessionId, 'CANCELLED');
            },
            child: const Text('Cancel Session'),
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

  // Deterministic color from initials.
  Color _avatarColor() {
    const colors = [
      Color(0xFF6366F1),
      Color(0xFF8B5CF6),
      Color(0xFFEC4899),
      Color(0xFFF59E0B),
      Color(0xFF10B981),
      Color(0xFF3B82F6),
    ];
    final code = initials.codeUnits.fold(0, (a, b) => a + b);
    return colors[code % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: _avatarColor(),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case 'COMPLETED':
        bg = const Color(0xFFD1FAE5);
        fg = const Color(0xFF059669);
        label = 'completed';
        break;
      case 'CANCELLED':
        bg = const Color(0xFFFEE2E2);
        fg = const Color(0xFFDC2626);
        label = 'cancelled';
        break;
      case 'NO_SHOW':
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFFD97706);
        label = 'no-show';
        break;
      default: // SCHEDULED
        bg = const Color(0xFFEEF2FF);
        fg = const Color(0xFF4F46E5);
        label = 'scheduled';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

class _PaymentBadge extends StatelessWidget {
  final String paymentStatus;
  const _PaymentBadge({required this.paymentStatus});

  @override
  Widget build(BuildContext context) {
    final isPaid = paymentStatus == 'PAID';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPaid
            ? const Color(0xFFD1FAE5)
            : const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        paymentStatus,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isPaid
              ? const Color(0xFF059669)
              : const Color(0xFFD97706),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool outlined;
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
        icon: Icon(icon, size: 16, color: color),
        label: Text(label,
            style: TextStyle(color: color, fontSize: 13)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color.withOpacity(0.6)),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(
              horizontal: 12, vertical: 6),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 13)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

class _PackageProgress extends StatelessWidget {
  final int current;
  final int total;
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
            Text('Session Progress',
                style: TextStyle(
                    fontSize: 12, color: Colors.grey[500])),
            Text('$current/$total',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primaryColor)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct.clamp(0.0, 1.0),
            minHeight: 6,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
          ),
        ),
      ],
    );
  }
}
