/// Request body sent to:
/// POST /api/member/pt-package-bookings
///
/// Backend expects:
/// {
///   "packageId": 1,
///   "weeklySchedule": [
///     {
///       "day": "MONDAY",
///       "time": "09:00"
///     },
///     {
///       "day": "THURSDAY",
///       "time": "18:00"
///     }
///   ]
/// }
///
/// Important:
/// - Do NOT send selectedDays anymore.
/// - Do NOT send selectedTime anymore.
/// - Do NOT send dates.
/// - Each selected weekday has its own time.
/// - Backend calculates totalAmount.
/// - Backend validates minDaysPerWeek / maxDaysPerWeek.
class PtPackageBookingRequestModel {
  final int packageId;

  /// Stable weekly schedule selected by the member.
  ///
  /// Example:
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
  /// Day must be one of:
  /// MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY.
  final List<Map<String, dynamic>> weeklySchedule;

  const PtPackageBookingRequestModel({
    required this.packageId,
    required this.weeklySchedule,
  });

  Map<String, dynamic> toJson() {
    return {
      'packageId': packageId,
      'weeklySchedule': weeklySchedule,
    };
  }
}