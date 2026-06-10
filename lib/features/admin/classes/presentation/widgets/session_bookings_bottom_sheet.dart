import 'package:build4allgym/common/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/session_booking_item_entity.dart';
import '../bloc/admin_classes_bloc.dart';
import '../bloc/admin_classes_event.dart';
import '../bloc/admin_classes_state.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';

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
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BlocProvider.value(
        value: context.read<AdminClassesBloc>(),
        child: BlocListener<AdminClassesBloc, AdminClassesState>(
          listener: (lCtx, state) {
            if (state is SessionBookingsLoaded && state.sessionId == sessionId) {
              final l10n = AppLocalizations.of(lCtx)!;
            if (state.wasPaymentConfirmed) {
                AppToast.success(lCtx, l10n.admin_classes_paymentConfirmed);
              } else if (state.wasBookingRejected) {
                AppToast.success(lCtx, l10n.admin_classes_bookingRejected);
              }
            }
          },
          child: SessionBookingsBottomSheet(
            sessionId: sessionId,
            className: className,
          ),
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
                color:        c.border.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── Header ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.admin_classes_sessionBookingsTitle,
                  style: TextStyle(
                    fontSize:   18,
                    fontWeight: FontWeight.w700,
                    color:      c.label,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon:      Icon(Icons.close, color: c.muted),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: c.border.withValues(alpha: 0.15)),

          // ── Body ─────────────────────────────────────────────────────────
          Expanded(
            child: BlocBuilder<AdminClassesBloc, AdminClassesState>(
              buildWhen: (previous, current) =>
              (current is SessionBookingsLoading && current.sessionId == sessionId) ||
                  (current is SessionBookingsLoaded  && current.sessionId == sessionId) ||
                  (current is SessionBookingsError   && current.sessionId == sessionId),
              builder: (context, state) {

                if (state is SessionBookingsLoaded && state.sessionId != sessionId) {
                  return Center(child: CircularProgressIndicator(color: c.primary));
                }
                if (state is SessionBookingsError && state.sessionId != sessionId) {
                  return Center(child: CircularProgressIndicator(color: c.primary));
                }

                if (state is SessionBookingsLoading) {
                  return Center(child: CircularProgressIndicator(color: c.primary));
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
                          child: Text(
                            AppLocalizations.of(context)!.admin_classes_noBookings,
                            style: TextStyle(color: c.muted, fontSize: 15),
                          ),
                        )
                            : ListView.separated(
                          padding:          EdgeInsets.zero,
                          itemCount:        bookings.length,
                          separatorBuilder: (_, __) => Divider(
                            height: 1,
                            indent: 72,
                            color:  c.border.withValues(alpha: 0.15),
                          ),
                          itemBuilder: (context, index) => _MemberRow(
                            booking:   bookings[index],
                            sessionId: sessionId,
                          ),
                        ),
                      ),
                    ],
                  );
                }

                if (state is SessionBookingsError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: TextStyle(color: c.danger, fontSize: 14),
                    ),
                  );
                }

                return Center(child: CircularProgressIndicator(color: c.primary));
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
    final tokens = context
        .read<ThemeCubit>()
        .state
        .tokens;
    final c = tokens.colors;

    final name = booking.fullName;
    final phone = booking.phone;

    final initials = name
        .split(' ')
        .take(2)
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
        .join();

    final isWaitlisted = booking.status == 'WAITLISTED';
    final isPending = booking.status == 'PENDING';

    final chipBg = isPending
        ? Colors.orange.withValues(alpha: 0.12)
        : isWaitlisted
        ? c.danger.withValues(alpha: 0.12)
        : c.success.withValues(alpha: 0.12);

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
            radius: 22,
            backgroundColor: c.primary.withValues(alpha: 0.1),
            child: Text(
              initials,
              style: TextStyle(
                color: c.primary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // ── Name + phone ─────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: c.label,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  phone.isNotEmpty ? phone : AppLocalizations.of(context)!.admin_classes_noPhone,
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

              // Status chip
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: chipBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Builder(builder: (ctx) {
                  final l10n = AppLocalizations.of(ctx)!;
                  return Text(
                    isPending
                        ? l10n.admin_classes_statusPending
                        : isWaitlisted
                        ? 'Waitlist ${booking.waitlistPosition ?? ''}'
                        : l10n.admin_classes_statusBooked,
                    style: TextStyle(
                      color: chipText,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                }),
              ),

              // Payment method chip
              if (booking.paymentMethod case final pm?) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
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

              // Confirm + Reject buttons (cash pending only)
              if (booking.isCashPending) ...[
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 30,
                      width: 72,
                      child: OutlinedButton(
                        onPressed: () =>
                            context.read<AdminClassesBloc>().add(
                              RejectBookingRequested(
                                bookingId: booking.bookingId,
                                sessionId: sessionId,
                              ),
                            ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: c.danger,
                          side: BorderSide(color: c.danger),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.admin_classes_rejectBooking,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    SizedBox(
                      height: 30,
                      width: 96,
                      child: ElevatedButton(
                        onPressed: () =>
                            context.read<AdminClassesBloc>().add(
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
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.admin_classes_confirmPayment,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Color _paymentChipBg(String method, String? status, dynamic c) {
    if (status?.toUpperCase() == 'PAID')
      return c.success.withValues(alpha: 0.12);
    if (method.toUpperCase() == 'CASH')
      return Colors.orange.withValues(alpha: 0.12);
    if (method.toUpperCase() == 'STRIPE')
      return Colors.indigo.withValues(alpha: 0.12);
    return c.muted.withValues(alpha: 0.12);
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