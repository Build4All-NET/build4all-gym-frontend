class SessionDetailModel {
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
  final String? description;
  final List<String> benefits;
  final List<String> equipment;

  SessionDetailModel({
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
    this.description,
    required this.benefits,
    required this.equipment,
  });

  factory SessionDetailModel.fromJson(Map<String, dynamic> json) {
    return SessionDetailModel(
      sessionId: (json['sessionId'] as num).toInt(),
      classTypeId: (json['classTypeId'] as num).toInt(),
      trainerId: (json['trainerId'] as num).toInt(),
      className: json['className'] as String,
      trainerName: json['trainerName'] as String,
      trainerProfileFileId: json['trainerProfileFileId'] == null
          ? null
          : (json['trainerProfileFileId'] as num).toInt(),
      trainerRating: (json['trainerRating'] as num).toDouble(),
      difficultyLevel: json['difficultyLevel'] as String,
      price: (json['price'] as num).toDouble(),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      roomName: json['roomName'] as String,
      availableSeats: (json['availableSeats'] as num).toInt(),
      memberBookingStatus: json['memberBookingStatus'] as String?,
      description: json['description'] as String?,
      benefits: List<String>.from(json['benefits'] ?? []),
      equipment: List<String>.from(json['equipment'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'classTypeId': classTypeId,
      'trainerId': trainerId,
      'className': className,
      'trainerName': trainerName,
      'trainerProfileFileId': trainerProfileFileId,
      'trainerRating': trainerRating,
      'difficultyLevel': difficultyLevel,
      'price': price,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'roomName': roomName,
      'availableSeats': availableSeats,
      'memberBookingStatus': memberBookingStatus,
      'description': description,
      'benefits': benefits,
      'equipment': equipment,
    };
  }
}