// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/classes/presentation/widgets/session_bookings_bottom_sheet.dart
//
// PURPOSE:
//   Read-only modal bottom sheet that lists all BOOKED and WAITLISTED members
//   for a class session. Opened when the Bookings action button is tapped.
//
// STATES handled inside the sheet:
//   SessionBookingsLoading → CircularProgressIndicator
//   SessionBookingsLoaded  → member list (or "No bookings yet" if empty)
//   Other states           → ignored (sheet is read-only, no mutations here)
//
// MEMBER ROW:
//   Left: circular avatar (initials if no profileFileId, network image if present)
//   Center: fullName (bold) + phone (grey)
//   Right: status chip — green "BOOKED" or orange "Waitlist N"
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/session_booking_item_entity.dart';
import '../bloc/admin_classes_bloc.dart';
import '../bloc/admin_classes_event.dart';
import '../bloc/admin_classes_state.dart';

class SessionBookingsBottomSheet extends StatelessWidget {
  final int    sessionId;
  final String className; // shown in the header e.g. "Morning Yoga Flow — 15 booked"

  const SessionBookingsBottomSheet({
    super.key,
    required this.sessionId,
    required this.className,
  });

  static void show(BuildContext context,
      {required int sessionId, required String className}) {
    // Dispatch the event BEFORE opening the sheet so loading starts immediately
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
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [

          // ── Handle ───────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),

          // ── Header row: title + close button ─────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                const Text(
                  'Session Bookings',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E)),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF0F0F0)),

          // ── Body: driven by BLoC state ────────────────────────────────────
          Expanded(
            child: BlocBuilder<AdminClassesBloc, AdminClassesState>(
              builder: (context, state) {

                // Loading spinner
                if (state is SessionBookingsLoading &&
                    state.sessionId == sessionId) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Loaded — show list
                if (state is SessionBookingsLoaded &&
                    state.sessionId == sessionId) {
                  final bookings = state.bookings;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sub-header: class name + count
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
                        child: Text(
                          '$className — ${bookings.length} booked',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF757575),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      Expanded(
                        child: bookings.isEmpty
                        // Empty state
                            ? const Center(
                          child: Text(
                            'No bookings yet',
                            style: TextStyle(
                                color: Color(0xFF9E9E9E), fontSize: 15),
                          ),
                        )
                        // Member list
                            : ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: bookings.length,
                          separatorBuilder: (_, __) => const Divider(
                              height: 1,
                              indent: 72,
                              color: Color(0xFFF0F0F0)),
                          itemBuilder: (context, index) =>
                              _MemberRow(booking: bookings[index]),
                        ),
                      ),
                    ],
                  );
                }

                // Default / other states — show nothing special
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Single member row in the bookings list ────────────────────────────────────
class _MemberRow extends StatelessWidget {
  final SessionBookingItemEntity booking;

  const _MemberRow({required this.booking});

  @override
  Widget build(BuildContext context) {
    final initials = booking.fullName
        .split(' ')
        .take(2)
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
        .join();

    final isWaitlisted = booking.status == 'WAITLISTED';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [

          // ── Avatar: network image if profileFileId exists, else initials ──
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFF1A1A2E).withOpacity(0.1),
            backgroundImage: booking.profileFileId != null
                ? NetworkImage(
                'YOUR_BASE_URL/files/${booking.profileFileId}')
                : null,
            child: booking.profileFileId == null
                ? Text(initials,
                style: const TextStyle(
                    color: Color(0xFF1A1A2E),
                    fontWeight: FontWeight.w700,
                    fontSize: 13))
                : null,
          ),

          const SizedBox(width: 12),

          // ── Name + phone ──────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.fullName,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF1A1A2E)),
                ),
                const SizedBox(height: 2),
                Text(
                  booking.phone,
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xFF9E9E9E)),
                ),
              ],
            ),
          ),

          // ── Status chip ───────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isWaitlisted
                  ? const Color(0xFFFF9800).withOpacity(0.12)
                  : const Color(0xFF4CAF50).withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isWaitlisted
                  ? 'Waitlist ${booking.waitlistPosition ?? ''}'
                  : 'Booked',
              style: TextStyle(
                color: isWaitlisted
                    ? const Color(0xFFE65100)
                    : const Color(0xFF2E7D32),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}