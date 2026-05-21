// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/classes/presentation/widgets/session_bookings_bottom_sheet.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'package:build4allgym/common/widgets/app_toast.dart';
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
      builder: (ctx) => BlocProvider.value(
        value: context.read<AdminClassesBloc>(),
        child: BlocListener<AdminClassesBloc, AdminClassesState>(
          listener: (lCtx, state) {
            if (state is SessionBookingsLoaded &&
                state.sessionId == sessionId &&
                state.wasPaymentConfirmed) {
              AppToast.success(lCtx, 'Payment confirmed');
            }
          },
          child: SessionBookingsBottomSheet(sessionId: sessionId, className: className),
        ),
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
                              _MemberRow(booking: bookings[index], sessionId: sessionId),
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
  final int sessionId;

  const _MemberRow({required this.booking, required this.sessionId});

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
    final isPending    = booking.status == 'PENDING';

    final chipBg = isPending
        ? Colors.orange.withOpacity(0.12)
        : isWaitlisted
            ? c.danger.withOpacity(0.12)
            : c.success.withOpacity(0.12);
    final chipText = isPending
        ? Colors.orange.shade800
        : isWaitlisted
            ? c.danger
            : c.success;

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
                  booking.phone.isNotEmpty ? booking.phone : 'No phone',
                  style: TextStyle(fontSize: 12, color: c.muted),
                ),
              ],
            ),
          ),

          // ── Status chip + payment info ───────────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color:        chipBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isPending
                      ? 'Pending'
                      : isWaitlisted
                          ? 'Waitlist ${booking.waitlistPosition ?? ''}'
                          : 'Booked',
                  style: TextStyle(
                    color:      chipText,
                    fontSize:   11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (booking.paymentMethod case final pm?) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _paymentChipBg(pm, booking.paymentStatus, c),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _paymentLabel(pm, booking.paymentStatus),
                    style: TextStyle(
                      color: _paymentChipText(pm, booking.paymentStatus, c),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
              if (booking.isCashPending) ...[
                const SizedBox(height: 6),
                SizedBox(
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () => context.read<AdminClassesBloc>().add(
                      ConfirmBookingPaymentRequested(
                        bookingId: booking.bookingId,
                        sessionId: sessionId,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: c.success,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Confirm Pay', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Color _paymentChipBg(String method, String? status, dynamic c) {
    if (status?.toUpperCase() == 'PAID') return c.success.withOpacity(0.12);
    if (method.toUpperCase() == 'CASH') return Colors.orange.withOpacity(0.12);
    if (method.toUpperCase() == 'STRIPE') return Colors.indigo.withOpacity(0.12);
    return c.muted.withOpacity(0.12);
  }

  Color _paymentChipText(String method, String? status, dynamic c) {
    if (status?.toUpperCase() == 'PAID') return c.success;
    if (method.toUpperCase() == 'CASH') return Colors.orange.shade800;
    if (method.toUpperCase() == 'STRIPE') return Colors.indigo;
    return c.muted;
  }

  String _paymentLabel(String method, String? status) {
    final m = method.toUpperCase();
    final s = status?.toUpperCase() ?? '';
    if (s == 'PAID') return '$m · Paid';
    if (s == 'PENDING' || s == 'UNPAID') return '$m · Pending';
    return m;
  }
}