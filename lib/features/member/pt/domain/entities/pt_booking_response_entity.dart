/// Domain entity returned after a PT booking is created.
///
/// Keep this file clean.
/// No JSON parsing here.
/// No API-specific logic here.
/// This is the object the app uses internally.
class PtBookingResponseEntity {
  final int ptSessionId;
  final int trainerId;
  final int userId;
  final int? branchId;
  final String startTime;
  final String endTime;
  final String status;
  final String? notes;
  final String? createdAt;
  final String? trainerName;
  final String? trainerPhotoUrl;

  const PtBookingResponseEntity({
    required this.ptSessionId,
    required this.trainerId,
    required this.userId,
    this.branchId,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.notes,
    this.createdAt,
    this.trainerName,
    this.trainerPhotoUrl,
  });
}