import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/member_booking_entity.dart';
import '../../domain/usecases/get_member_bookings_usecase.dart';
import '../../domain/usecases/request_member_booking_cancel_usecase.dart';
import '../../domain/usecases/submit_member_booking_review_usecase.dart';
import 'member_bookings_event.dart';
import 'member_bookings_state.dart';

/*
 * Bloc for My Bookings screen.
 *
 * Responsibilities:
 * - load upcoming/previous bookings
 * - switch tabs
 * - send cancel request
 * - submit review
 *
 * Important:
 * After review success, we do NOT refresh from backend.
 * We hide the review button locally to avoid showing
 * "Failed to load bookings" after a successful rating.
 */
class MemberBookingsBloc extends Bloc<MemberBookingsEvent, MemberBookingsState> {
  final GetMemberBookingsUseCase getMemberBookingsUseCase;
  final RequestMemberBookingCancelUseCase requestCancelUseCase;
  final SubmitMemberBookingReviewUseCase submitReviewUseCase;

  String _currentTab = 'UPCOMING';

  MemberBookingsBloc({
    required this.getMemberBookingsUseCase,
    required this.requestCancelUseCase,
    required this.submitReviewUseCase,
  }) : super(const MemberBookingsInitial()) {
    on<MemberBookingsStarted>(_onStarted);
    on<MemberBookingsTabChanged>(_onTabChanged);
    on<MemberBookingsRefreshRequested>(_onRefreshRequested);
    on<MemberBookingCancelRequested>(_onCancelRequested);
    on<MemberBookingReviewSubmitted>(_onReviewSubmitted);
  }

  Future<void> _onStarted(
      MemberBookingsStarted event,
      Emitter<MemberBookingsState> emit,
      ) async {
    await _loadBookings(emit);
  }

  Future<void> _onTabChanged(
      MemberBookingsTabChanged event,
      Emitter<MemberBookingsState> emit,
      ) async {
    if (_currentTab == event.tab) return;

    _currentTab = event.tab;
    await _loadBookings(emit);
  }

  Future<void> _onRefreshRequested(
      MemberBookingsRefreshRequested event,
      Emitter<MemberBookingsState> emit,
      ) async {
    await _loadBookings(emit);
  }

  Future<void> _onCancelRequested(
      MemberBookingCancelRequested event,
      Emitter<MemberBookingsState> emit,
      ) async {
    final currentBookings = _readCurrentBookings();

    emit(
      MemberBookingsActionLoading(
        bookings: currentBookings,
        tab: _currentTab,
      ),
    );

    try {
      await requestCancelUseCase(event.booking);

      final refreshed = await getMemberBookingsUseCase(tab: _currentTab);

      emit(
        MemberBookingsLoaded(
          bookings: refreshed,
          tab: _currentTab,
          messageKey: 'memberBookingsCancelRequestSent',
        ),
      );
    } catch (_) {
      emit(
        MemberBookingsError(
          tab: _currentTab,
          messageKey: 'memberBookingsCancelRequestFailed',
        ),
      );

      emit(
        MemberBookingsLoaded(
          bookings: currentBookings,
          tab: _currentTab,
        ),
      );
    }
  }

  Future<void> _onReviewSubmitted(
      MemberBookingReviewSubmitted event,
      Emitter<MemberBookingsState> emit,
      ) async {
    final currentBookings = _readCurrentBookings();

    emit(
      MemberBookingsActionLoading(
        bookings: currentBookings,
        tab: _currentTab,
      ),
    );

    try {
      await submitReviewUseCase(
        booking: event.booking,
        rating: event.rating,
        comment: event.comment,
      );

      /*
       * Rating succeeded.
       * Hide review button locally without refreshing.
       */
      final updatedBookings = currentBookings.map((booking) {
        final sameBooking =
            booking.bookingType == event.booking.bookingType &&
                booking.bookingId == event.booking.bookingId;

        if (!sameBooking) {
          return booking;
        }

        return booking.copyWith(canReview: false);
      }).toList();

      emit(
        MemberBookingsLoaded(
          bookings: updatedBookings,
          tab: _currentTab,
          messageKey: 'memberBookingsReviewSubmitted',
        ),
      );
    } catch (_) {
      /*
       * Rating failed.
       * Show error, then restore the same bookings list.
       */
      emit(
        MemberBookingsError(
          tab: _currentTab,
          messageKey: 'memberBookingsReviewFailed',
        ),
      );

      emit(
        MemberBookingsLoaded(
          bookings: currentBookings,
          tab: _currentTab,
        ),
      );
    }
  }

  Future<void> _loadBookings(
      Emitter<MemberBookingsState> emit,
      ) async {
    emit(MemberBookingsLoading(tab: _currentTab));

    try {
      final bookings = await getMemberBookingsUseCase(tab: _currentTab);

      emit(
        MemberBookingsLoaded(
          bookings: bookings,
          tab: _currentTab,
        ),
      );
    } catch (_) {
      emit(
        MemberBookingsError(
          tab: _currentTab,
          messageKey: 'memberBookingsLoadFailed',
        ),
      );
    }
  }

  List<MemberBookingEntity> _readCurrentBookings() {
    final current = state;

    if (current is MemberBookingsLoaded) {
      return current.bookings;
    }

    if (current is MemberBookingsActionLoading) {
      return current.bookings;
    }

    return const [];
  }
}