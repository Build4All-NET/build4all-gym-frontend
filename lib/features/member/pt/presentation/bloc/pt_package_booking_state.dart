import '../../domain/entities/pt_package_booking_response_entity.dart';
import '../../domain/entities/pt_package_entity.dart';
import '../../domain/entities/time_slot_entity.dart';

/// Base class for all PT package booking states.
abstract class PtPackageBookingState {
  const PtPackageBookingState();
}

/// Initial state before packages are loaded into the bloc.
class PtPackageBookingInitial extends PtPackageBookingState {
  const PtPackageBookingInitial();
}

/// Main loaded state.
///
/// Holds:
/// - trainerId
/// - available packages
/// - selected package
/// - selected weekly schedule
/// - weekly available slots per selected day
///
/// weeklySchedule example:
/// [
///   {
///     "day": "MONDAY",
///     "time": "09:00"
///   },
///   {
///     "day": "THURSDAY",
///     "time": "18:00"
///   }
/// ]
///
/// weeklySlotsByDay example:
/// {
///   "MONDAY": [TimeSlotEntity(...), TimeSlotEntity(...)],
///   "THURSDAY": [TimeSlotEntity(...)]
/// }
class PtPackageBookingLoaded extends PtPackageBookingState {
  /// Needed to call:
  /// GET /api/member/trainers/{trainerId}/weekly-slots?day=MONDAY
  final int trainerId;

  final List<PtPackageEntity> packages;
  final PtPackageEntity? selectedPackage;

  /// Weekday codes where trainer has set availability.
  /// e.g. ['MONDAY', 'WEDNESDAY', 'FRIDAY']
  final List<String> availableDays;

  /// Source of truth for the booking request.
  ///
  /// No dates.
  /// Each selected weekday owns its selected time.
  final List<Map<String, dynamic>> weeklySchedule;

  /// Available trainer/PT slots grouped by stable weekday code.
  ///
  /// Key examples:
  /// MONDAY, TUESDAY, WEDNESDAY...
  final Map<String, List<TimeSlotEntity>> weeklySlotsByDay;

  /// Days currently loading slots.
  ///
  /// Example:
  /// {"MONDAY", "THURSDAY"}
  final Set<String> loadingSlotDays;

  /// Slot loading error per weekday.
  ///
  /// Keep message as key/string. UI decides how to display/translate.
  final Map<String, String> slotErrorsByDay;

  /// The weekday currently being time-requested (POST /api/pt-sessions/request).
  /// null = no request in progress.
  /// "MONDAY" = Monday request is submitting.
  final String? requestingDay;

  const PtPackageBookingLoaded({
    required this.trainerId,
    required this.packages,
    this.selectedPackage,
    this.availableDays = const [],
    required this.weeklySchedule,
    this.weeklySlotsByDay = const {},
    this.loadingSlotDays = const {},
    this.slotErrorsByDay = const {},
    this.requestingDay,
  });

  /// Number of selected weekdays.
  int get selectedDaysCount => weeklySchedule.length;

  /// Checks if a weekday is already selected.
  bool isDaySelected(String day) {
    final normalizedDay = day.trim().toUpperCase();

    return weeklySchedule.any(
          (item) => item['day']?.toString().toUpperCase() == normalizedDay,
    );
  }

  /// Returns selected time for one weekday.
  ///
  /// Returns null when:
  /// - day is not selected
  /// - time is empty
  String? selectedTimeForDay(String day) {
    final normalizedDay = day.trim().toUpperCase();

    for (final item in weeklySchedule) {
      final itemDay = item['day']?.toString().toUpperCase();

      if (itemDay == normalizedDay) {
        final time = item['time']?.toString();

        if (time == null || time.trim().isEmpty) {
          return null;
        }

        return time;
      }
    }

    return null;
  }

  /// Returns available slots for one weekday.
  List<TimeSlotEntity> availableSlotsForDay(String day) {
    final normalizedDay = day.trim().toUpperCase();

    return weeklySlotsByDay[normalizedDay] ?? const [];
  }

  /// Returns true if slots are loading for one weekday.
  bool isLoadingSlotsForDay(String day) {
    final normalizedDay = day.trim().toUpperCase();

    return loadingSlotDays.contains(normalizedDay);
  }

  /// Returns slot loading error for one weekday.
  String? slotErrorForDay(String day) {
    final normalizedDay = day.trim().toUpperCase();

    return slotErrorsByDay[normalizedDay];
  }

  /// Confirm button should be enabled only when:
  /// - package exists
  /// - selected days count is between minDaysPerWeek and maxDaysPerWeek
  /// - every selected day has a selected time
  bool get canConfirm {
    final package = selectedPackage;

    if (package == null) return false;

    final count = weeklySchedule.length;

    if (count < package.minDaysPerWeek) return false;
    if (count > package.maxDaysPerWeek) return false;

    return weeklySchedule.every((item) {
      final day = item['day']?.toString().trim();
      final time = item['time']?.toString().trim();

      return day != null &&
          day.isNotEmpty &&
          time != null &&
          time.isNotEmpty;
    });
  }

  /// Returns true when trainer has availability on this weekday.
  bool isTrainerAvailableOnDay(String day) {
    if (availableDays.isEmpty) return true; // unknown → assume available
    return availableDays.contains(day.trim().toUpperCase());
  }

  PtPackageBookingLoaded copyWith({
    int? trainerId,
    List<PtPackageEntity>? packages,
    PtPackageEntity? selectedPackage,
    List<String>? availableDays,
    List<Map<String, dynamic>>? weeklySchedule,
    Map<String, List<TimeSlotEntity>>? weeklySlotsByDay,
    Set<String>? loadingSlotDays,
    Map<String, String>? slotErrorsByDay,
    String? requestingDay,
    bool clearSelectedPackage = false,
    bool clearRequestingDay = false,
  }) {
    return PtPackageBookingLoaded(
      trainerId: trainerId ?? this.trainerId,
      packages: packages ?? this.packages,
      selectedPackage:
      clearSelectedPackage ? null : selectedPackage ?? this.selectedPackage,
      availableDays: availableDays ?? this.availableDays,
      weeklySchedule: weeklySchedule ?? this.weeklySchedule,
      weeklySlotsByDay: weeklySlotsByDay ?? this.weeklySlotsByDay,
      loadingSlotDays: loadingSlotDays ?? this.loadingSlotDays,
      slotErrorsByDay: slotErrorsByDay ?? this.slotErrorsByDay,
      requestingDay: clearRequestingDay ? null : requestingDay ?? this.requestingDay,
    );
  }
}

/// State emitted while POST /api/member/pt-package-bookings is running.
class PtPackageBookingSubmitting extends PtPackageBookingLoaded {
  const PtPackageBookingSubmitting({
    required super.trainerId,
    required super.packages,
    required super.selectedPackage,
    super.availableDays,
    required super.weeklySchedule,
    required super.weeklySlotsByDay,
    required super.loadingSlotDays,
    required super.slotErrorsByDay,
  });
}

/// State emitted when booking succeeds.
class PtPackageBookingSuccess extends PtPackageBookingLoaded {
  final PtPackageBookingResponseEntity booking;

  const PtPackageBookingSuccess({
    required super.trainerId,
    required super.packages,
    required super.selectedPackage,
    super.availableDays,
    required super.weeklySchedule,
    required super.weeklySlotsByDay,
    required super.loadingSlotDays,
    required super.slotErrorsByDay,
    required this.booking,
  });
}

/// State emitted when booking fails.
class PtPackageBookingError extends PtPackageBookingLoaded {
  final String message;

  const PtPackageBookingError({
    required super.trainerId,
    required super.packages,
    required super.selectedPackage,
    super.availableDays,
    required super.weeklySchedule,
    required super.weeklySlotsByDay,
    required super.loadingSlotDays,
    required super.slotErrorsByDay,
    required this.message,
  });
}

/// State emitted when POST /api/pt-sessions/request succeeds.
class PtPackageTimeRequestSuccess extends PtPackageBookingLoaded {
  final String requestedDay;

  const PtPackageTimeRequestSuccess({
    required super.trainerId,
    required super.packages,
    super.selectedPackage,
    super.availableDays,
    required super.weeklySchedule,
    required super.weeklySlotsByDay,
    required super.loadingSlotDays,
    required super.slotErrorsByDay,
    required this.requestedDay,
  });
}

/// State emitted when POST /api/pt-sessions/request fails.
class PtPackageTimeRequestError extends PtPackageBookingLoaded {
  final String message;

  const PtPackageTimeRequestError({
    required super.trainerId,
    required super.packages,
    super.selectedPackage,
    super.availableDays,
    required super.weeklySchedule,
    required super.weeklySlotsByDay,
    required super.loadingSlotDays,
    required super.slotErrorsByDay,
    required this.message,
  });
}

/// State emitted after booking is created with a payment method.
///
/// The payment sheet uses this to drive Stripe or redirect flow.
/// isPending = true  → cash or waiting
/// isStripe  = true  → present Stripe sheet
/// isRedirect = true → launch browser redirect
class PtPackageBookingPaymentReady extends PtPackageBookingLoaded {
  final PtPackageBookingResponseEntity booking;

  const PtPackageBookingPaymentReady({
    required super.trainerId,
    required super.packages,
    super.selectedPackage,
    super.availableDays,
    required super.weeklySchedule,
    required super.weeklySlotsByDay,
    required super.loadingSlotDays,
    required super.slotErrorsByDay,
    required this.booking,
  });
}