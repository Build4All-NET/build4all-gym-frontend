// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/classes/presentation/widgets/session_bookings_bottom_sheet.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/session_booking_item_entity.dart';
import '../bloc/admin_classes_bloc.dart';
import '../bloc/admin_classes_event.dart';
import '../bloc/admin_classes_state.dart';
import '../../../../../core/theme/theme_cubit.dart';

class SessionBookingsBottomSheet extends StatelessWidget {
  final int    sessionId;
  final String className;

  const SessionBookingsBottomSheet({
    super.key,
    required this.sessionId,
    required this.className,
  });

  static void show(BuildContext context,
      {required int sessionId, required String className}) {
    context.read<AdminClassesBloc>().add(SessionBookingsRequested(sessionId));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<AdminClassesBloc>(),
        child: SessionBookingsBottomSheet(
            sessionId: sessionId, className: className),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;
    final card   = tokens.card;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color:        c.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(card.radius + 8)),
      ),
      child: Column(
        children: [

          // ── Handle ───────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                  color:        c.border.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),

          // ── Header ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Text(
                  'Session Bookings',
                  style: TextStyle(
                      fontSize:   18,
                      fontWeight: FontWeight.w700,
                      color:      c.label),
                ),
                const Spacer(),
                IconButton(
                  icon:      Icon(Icons.close, color: c.muted),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: c.border.withOpacity(0.15)),

          // ── Body ─────────────────────────────────────────────────────────
          // session_bookings_bottom_sheet.dart  ── Body section only

          Expanded(
            child: BlocBuilder<AdminClassesBloc, AdminClassesState>(
              // ✅ Only rebuild for booking states that belong to THIS session
              buildWhen: (previous, current) =>
              (current is SessionBookingsLoading && current.sessionId == sessionId) ||
                  (current is SessionBookingsLoaded  && current.sessionId == sessionId) ||
                  (current is SessionBookingsError   && current.sessionId == sessionId),
              builder: (context, state) {

                if (state is SessionBookingsLoading) {
                  return Center(
                      child: CircularProgressIndicator(color: c.primary));
                }

                if (state is SessionBookingsLoaded) {
                  final bookings = state.bookings;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
                        child: Text(
                          '$className — ${bookings.length} booked',
                          style: TextStyle(
                            fontSize:   13,
                            color:      c.muted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: bookings.isEmpty
                            ? Center(
                          child: Text('No bookings yet',
                              style: TextStyle(color: c.muted, fontSize: 15)),
                        )
                            : ListView.separated(
                          padding:          EdgeInsets.zero,
                          itemCount:        bookings.length,
                          separatorBuilder: (_, __) => Divider(
                              height: 1,
                              indent: 72,
                              color:  c.border.withOpacity(0.15)),
                          itemBuilder: (context, index) =>
                              _MemberRow(booking: bookings[index]),
                        ),
                      ),
                    ],
                  );
                }

                // SessionBookingsError or initial state before first event lands
                if (state is SessionBookingsError) {
                  return Center(
                    child: Text(state.message,
                        style: TextStyle(color: c.danger, fontSize: 14)),
                  );
                }

                return Center(
                    child: CircularProgressIndicator(color: c.primary)); // safe fallback
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Single member row ─────────────────────────────────────────────────────────
class _MemberRow extends StatelessWidget {
  final SessionBookingItemEntity booking;

  const _MemberRow({required this.booking});

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;

    final initials = booking.fullName
        .split(' ')
        .take(2)
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
        .join();

    final isWaitlisted = booking.status == 'WAITLISTED';

    // Derive waitlist/booked colors from theme tokens
    final chipBg    = isWaitlisted
        ? c.danger.withOpacity(0.12)
        : c.success.withOpacity(0.12);
    final chipText  = isWaitlisted ? c.danger : c.success;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [

          // ── Avatar ──────────────────────────────────────────────────────
          CircleAvatar(
            radius:          22,
            backgroundColor: c.primary.withOpacity(0.1),
            backgroundImage: booking.profileFileId != null
                ? NetworkImage('YOUR_BASE_URL/files/${booking.profileFileId}')
                : null,
            child: booking.profileFileId == null
                ? Text(initials,
                style: TextStyle(
                    color:      c.primary,
                    fontWeight: FontWeight.w700,
                    fontSize:   13))
                : null,
          ),

          const SizedBox(width: 12),

          // ── Name + phone ─────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.fullName,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize:   14,
                      color:      c.label),
                ),
                const SizedBox(height: 2),
                Text(
                  booking.phone?.isNotEmpty == true ? booking.phone! : 'No phone',
                  style: TextStyle(fontSize: 12, color: c.muted),
                ),
              ],
            ),
          ),

          // ── Status chip ──────────────────────────────────────────────────
          Container(
            padding:    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color:        chipBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isWaitlisted
                  ? 'Waitlist ${booking.waitlistPosition ?? ''}'
                  : 'Booked',
              style: TextStyle(
                color:      chipText,
                fontSize:   11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}