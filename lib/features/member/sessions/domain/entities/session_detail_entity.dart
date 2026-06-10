class SessionDetailEntity {
  final int sessionId;
  final int classTypeId;
  final int trainerId;
  final String className;
  final String trainerName;
  final int? trainerProfileFileId;
  final double trainerRating;
  final String difficultyLevel;
  final double price;
  final DateTime startTime;
  final DateTime endTime;
  final String roomName;
  final int availableSeats;
  final String? memberBookingStatus;
  final String description;
  final List<String> benefits;
  final List<String> equipment;
  final int? branchId;
  final String? branchName;
  final bool requiresMembership;
  final bool memberHasActiveMembership;

  const SessionDetailEntity({
    required this.sessionId,
    required this.classTypeId,
    required this.trainerId,
    required this.className,
    required this.trainerName,
    this.trainerProfileFileId,
    required this.trainerRating,
    required this.difficultyLevel,
    required this.price,
    required this.startTime,
    required this.endTime,
    required this.roomName,
    required this.availableSeats,
    this.memberBookingStatus,
    required this.description,
    required this.benefits,
    this.branchId,
    this.branchName,
    required this.equipment,
    this.requiresMembership = false,
    this.memberHasActiveMembership = true,
  });
}