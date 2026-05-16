class SessionCardEntity {
  final int sessionId;
  final String className;
  final String trainerName;
  final String? roomName;
  final DateTime startTime;
  final int durationMinutes;
  final double price;
  final String difficultyLevel;
  final int availableSeats;
  final int totalCapacity;
  final String? memberBookingStatus;
  final int? imageFileId;
  final int? branchId;
  final String? branchName;

  const SessionCardEntity({
    required this.sessionId,
    required this.className,
    required this.trainerName,
    this.roomName,
    required this.startTime,
    required this.durationMinutes,
    required this.price,
    required this.difficultyLevel,
    required this.availableSeats,
    required this.totalCapacity,
    this.memberBookingStatus,
    this.imageFileId,
    this.branchId,
    this.branchName,
  });
}