class SessionCardModel {
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

  const SessionCardModel({
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
  });

  factory SessionCardModel.fromJson(Map<String, dynamic> json) {
    return SessionCardModel(
      sessionId: json['sessionId'] as int,
      className: json['className'] as String,
      trainerName: json['trainerName'] as String,
      roomName: json['roomName'] as String?,
      startTime: DateTime.parse(json['startTime'] as String),
      durationMinutes: json['durationMinutes'] as int,
      price: (json['price'] as num).toDouble(),
      difficultyLevel: json['difficultyLevel'] as String,
      availableSeats: json['availableSeats'] as int,
      totalCapacity: json['totalCapacity'] as int,
      memberBookingStatus: json['memberBookingStatus'] as String?,
      imageFileId: json['imageFileId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'className': className,
      'trainerName': trainerName,
      'roomName': roomName,
      'startTime': startTime.toIso8601String(),
      'durationMinutes': durationMinutes,
      'price': price,
      'difficultyLevel': difficultyLevel,
      'availableSeats': availableSeats,
      'totalCapacity': totalCapacity,
      'memberBookingStatus': memberBookingStatus,
      'imageFileId': imageFileId,
    };
  }
}