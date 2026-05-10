/// Request body sent to POST /api/pt-sessions.
///
/// This model belongs to the data layer because it knows the exact JSON
/// expected by the backend.
class PtBookingRequestModel {
  final int trainerId;
  final String startTime;
  final String endTime;
  final String? notes;

  const PtBookingRequestModel({
    required this.trainerId,
    required this.startTime,
    required this.endTime,
    this.notes,
  });

  /// Converts Dart object to JSON for the backend.
  Map<String, dynamic> toJson() {
    return {
      'trainerId': trainerId,
      'startTime': startTime,
      'endTime': endTime,

      // Send notes only if it exists and is not empty.
      if (notes != null && notes!.trim().isNotEmpty) 'notes': notes,
    };
  }
}