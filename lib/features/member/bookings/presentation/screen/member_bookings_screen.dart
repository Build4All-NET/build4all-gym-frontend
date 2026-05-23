import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';

import '../../domain/usecases/get_member_bookings_usecase.dart';
import '../../domain/usecases/request_member_booking_cancel_usecase.dart';
import '../bloc/member_bookings_bloc.dart';
import '../bloc/member_bookings_event.dart';
import '../bloc/member_bookings_state.dart';
import '../widgets/member_booking_card.dart';
import '../widgets/member_booking_tab_button.dart';
import '../../domain/usecases/submit_member_booking_review_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';

/*
 * Rating bottom sheet for My Bookings.
 *
 * Shows:
 * - title
 * - booking title
 * - 5 interactive stars
 * - submit button disabled until rating is selected
 *
 * No hardcoded text.
 * All text comes from ARB.
 * All colors/spacings come from theme tokens.
 */
Future<void> showMemberBookingRatingSheet({
  required BuildContext context,
  required String bookingTitle,
  required void Function(int rating) onSubmit,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: context.read<ThemeCubit>(),
      child: _MemberBookingRatingSheet(
        bookingTitle: bookingTitle,
        onSubmit: onSubmit,
      ),
    ),
  );
}

class _MemberBookingRatingSheet extends StatefulWidget {
  final String bookingTitle;
  final void Function(int rating) onSubmit;

  const _MemberBookingRatingSheet({
    required this.bookingTitle,
    required this.onSubmit,
  });

  @override
  State<_MemberBookingRatingSheet> createState() =>
      _MemberBookingRatingSheetState();
}

class _MemberBookingRatingSheetState extends State<_MemberBookingRatingSheet> {
  int _selected = 0;
  int _pressed = 0;

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final bottomPadding =
        MediaQuery.of(context).viewInsets.bottom +
            MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: tokens.colors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        tokens.spacing.xl,
        tokens.spacing.lg,
        tokens.spacing.xl,
        tokens.spacing.xl + bottomPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /*
           * Small drag handle.
           */
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: tokens.colors.border.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          SizedBox(height: tokens.spacing.xl),

          /*
           * Header icon.
           */
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: tokens.colors.primary.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.star_rounded,
              color: tokens.colors.primary,
              size: 32,
            ),
          ),

          SizedBox(height: tokens.spacing.lg),

          /*
           * Main title.
           */
          Text(
            l10n.memberBookingsRatingTitle,
            textAlign: TextAlign.center,
            style: tokens.typography.titleMedium.copyWith(
              color: tokens.colors.label,
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),

          SizedBox(height: tokens.spacing.xs),

          /*
           * Booking title.
           */
          Text(
            widget.bookingTitle,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: tokens.typography.bodyMedium.copyWith(
              color: tokens.colors.muted,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: tokens.spacing.xl),

          /*
           * Stars row.
           */
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            children: List.generate(5, (index) {
              final starValue = index + 1;
              final filled = starValue <= _selected;

              return GestureDetector(
                onTapDown: (_) {
                  setState(() => _pressed = starValue);
                },
                onTapCancel: () {
                  setState(() => _pressed = 0);
                },
                onTapUp: (_) {
                  setState(() {
                    _selected = starValue;
                    _pressed = 0;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  padding: EdgeInsets.all(tokens.spacing.sm),
                  child: AnimatedScale(
                    scale: _pressed == starValue ? 1.25 : 1.0,
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeOut,
                    child: Icon(
                      filled
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      size: 40,
                      color: filled
                          ? tokens.colors.primary
                          : tokens.colors.border,
                    ),
                  ),
                ),
              );
            }),
          ),

          SizedBox(height: tokens.spacing.xs),

          /*
           * Low/high labels.
           */
          Padding(
            padding: EdgeInsets.symmetric(horizontal: tokens.spacing.sm),
            child: Row(
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.memberBookingsRatingLabelLow,
                  style: tokens.typography.bodySmall.copyWith(
                    color: tokens.colors.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  l10n.memberBookingsRatingLabelHigh,
                  style: tokens.typography.bodySmall.copyWith(
                    color: tokens.colors.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: tokens.spacing.xl),

          /*
           * Submit button.
           */
          SizedBox(
            width: double.infinity,
            height: 52,
            child: AnimatedOpacity(
              opacity: _selected > 0 ? 1.0 : 0.45,
              duration: const Duration(milliseconds: 200),
              child: ElevatedButton(
                onPressed: _selected > 0
                    ? () {
                  Navigator.of(context).pop();
                  widget.onSubmit(_selected);
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: tokens.colors.primary,
                  foregroundColor: tokens.colors.onPrimary,
                  disabledBackgroundColor: tokens.colors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(tokens.button.radius),
                  ),
                ),
                child: Text(
                  l10n.memberBookingsRateNowButton,
                  style: tokens.typography.bodyMedium.copyWith(
                    color: tokens.colors.onPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*
 * Main screen for member My Bookings.
 *
 * Shows:
 * - upcoming class bookings
 * - upcoming PT sessions
 * - previous class bookings
 * - previous PT sessions
 *
 * Backend sends unified booking objects.
 * UI only renders them.
 */
class MemberBookingsScreen extends StatelessWidget {
  final GetMemberBookingsUseCase getMemberBookingsUseCase;
  final RequestMemberBookingCancelUseCase requestCancelUseCase;
  final SubmitMemberBookingReviewUseCase submitReviewUseCase;

  const MemberBookingsScreen({
    super.key,
    required this.getMemberBookingsUseCase,
    required this.requestCancelUseCase,
    required this.submitReviewUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MemberBookingsBloc(
        getMemberBookingsUseCase: getMemberBookingsUseCase,
        requestCancelUseCase: requestCancelUseCase,
        submitReviewUseCase: submitReviewUseCase,
      )..add(const MemberBookingsStarted()),
      child: const _MemberBookingsView(),
    );
  }
}

class _MemberBookingsView extends StatelessWidget {
  const _MemberBookingsView();

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: tokens.colors.background,
      body: SafeArea(
        top: false,
        child: BlocConsumer<MemberBookingsBloc, MemberBookingsState>(
          listener: (context, state) {
            /*
             * Snackbar text comes from ARB.
             * Bloc sends only messageKey.
             */
            if (state is MemberBookingsLoaded && state.messageKey != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_messageFromKey(l10n, state.messageKey!)),
                  backgroundColor: tokens.colors.success,
                ),
              );
            }

            if (state is MemberBookingsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_messageFromKey(l10n, state.messageKey)),
                  backgroundColor: tokens.colors.danger,
                ),
              );
            }
          },
          builder: (context, state) {
            final currentTab = _currentTab(state);
            final bookings = _currentBookings(state);
            final isLoading = state is MemberBookingsLoading;
            final isActionLoading = state is MemberBookingsActionLoading;

            return CustomScrollView(
              slivers: [
                /*
                 * Gradient header — title + subtitle only.
                 * No back button: this is a bottom-nav screen.
                 * Tabs are placed below on the white background.
                 */
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsetsDirectional.fromSTEB(
                      tokens.spacing.lg,
                      MediaQuery.of(context).padding.top + 22,
                      tokens.spacing.lg,
                      tokens.spacing.xl,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: isRtl
                            ? Alignment.topRight
                            : Alignment.topLeft,
                        end: isRtl
                            ? Alignment.bottomLeft
                            : Alignment.bottomRight,
                        colors: [
                          tokens.colors.primary,
                          tokens.colors.success,
                        ],
                      ),
                      borderRadius: const BorderRadiusDirectional.only(
                        bottomStart: Radius.circular(28),
                        bottomEnd: Radius.circular(28),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: isRtl
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.memberBookingsTitle,
                          textAlign:
                          isRtl ? TextAlign.right : TextAlign.left,
                          style:
                          tokens.typography.headlineSmall.copyWith(
                            color: tokens.colors.onPrimary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: tokens.spacing.xs),
                        Text(
                          l10n.memberBookingsSubtitle,
                          textAlign:
                          isRtl ? TextAlign.right : TextAlign.left,
                          style: tokens.typography.bodyMedium.copyWith(
                            color: tokens.colors.onPrimary
                                .withOpacity(0.88),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /*
                 * Upcoming / Previous tabs — below gradient on white bg.
                 * Selected tab: white pill with shadow.
                 * Unselected tab: transparent, muted text.
                 */
                SliverToBoxAdapter(
                  child: Container(
                    color: tokens.colors.background,
                    padding: EdgeInsets.symmetric(
                      horizontal: tokens.spacing.lg,
                      vertical: tokens.spacing.lg,
                    ),
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: tokens.colors.surface,
                        borderRadius: BorderRadius.circular(
                          tokens.button.radius,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        textDirection: isRtl
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        children: [
                          MemberBookingTabButton(
                            label: l10n.memberBookingsUpcomingTab,
                            selected: currentTab == 'UPCOMING',
                            onTap: () {
                              context.read<MemberBookingsBloc>().add(
                                const MemberBookingsTabChanged(
                                    'UPCOMING'),
                              );
                            },
                          ),
                          MemberBookingTabButton(
                            label: l10n.memberBookingsPreviousTab,
                            selected: currentTab == 'PREVIOUS',
                            onTap: () {
                              context.read<MemberBookingsBloc>().add(
                                const MemberBookingsTabChanged(
                                    'PREVIOUS'),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                if (isLoading)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: tokens.colors.primary,
                      ),
                    ),
                  )
                else if (bookings.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyState(
                      message: currentTab == 'UPCOMING'
                          ? l10n.memberBookingsEmptyUpcoming
                          : l10n.memberBookingsEmptyPrevious,
                    ),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.only(
                      bottom: tokens.spacing.xl,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final booking = bookings[index];

                          return MemberBookingCard(
                            booking: booking,
                            actionLoading: isActionLoading,
                            onCancelTap: () {
                              context.read<MemberBookingsBloc>().add(
                                MemberBookingCancelRequested(booking),
                              );
                            },
                            onReviewTap: () {
                              final title = (booking.title != null && booking.title!.trim().isNotEmpty)
                                  ? booking.title!.trim()
                                  : booking.isPt
                                  ? l10n.memberBookingsPtDefaultTitle
                                  : l10n.memberBookingsClassDefaultTitle;

                              showMemberBookingRatingSheet(
                                context: context,
                                bookingTitle: title,
                                onSubmit: (rating) {
                                  context.read<MemberBookingsBloc>().add(
                                    MemberBookingReviewSubmitted(
                                      booking: booking,
                                      rating: rating,
                                      comment: null,
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        childCount: bookings.length,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _currentTab(MemberBookingsState state) {
    if (state is MemberBookingsLoaded) return state.tab;
    if (state is MemberBookingsLoading) return state.tab;
    if (state is MemberBookingsActionLoading) return state.tab;
    if (state is MemberBookingsError) return state.tab;
    return 'UPCOMING';
  }

  List<dynamic> _currentBookings(MemberBookingsState state) {
    if (state is MemberBookingsLoaded) return state.bookings;
    if (state is MemberBookingsActionLoading) return state.bookings;
    return const [];
  }
  String _messageFromKey(AppLocalizations l10n, String key) {
    switch (key) {
      case 'memberBookingsCancelRequestSent':
        return l10n.memberBookingsCancelRequestSent;

      case 'memberBookingsCancelRequestFailed':
        return l10n.memberBookingsCancelRequestFailed;

      case 'memberBookingsReviewSubmitted':
        return l10n.memberBookingsReviewSubmitted;

      case 'memberBookingsReviewFailed':
        return l10n.memberBookingsReviewFailed;

      case 'memberBookingsLoadFailed':
        return l10n.memberBookingsLoadFailed;

      default:
        return l10n.memberBookingsLoadFailed;
    }
  }
}

class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Padding(
      padding: EdgeInsets.all(tokens.spacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              color: tokens.colors.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.event_busy_rounded,
              color: tokens.colors.primary,
              size: 34,
            ),
          ),
          SizedBox(height: tokens.spacing.md),
          Text(
            message,
            textAlign: isRtl ? TextAlign.right : TextAlign.left,
            style: tokens.typography.bodyMedium.copyWith(
              color: tokens.colors.body,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}