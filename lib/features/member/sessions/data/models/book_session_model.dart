class BookSessionModel {
  final int bookingId;
  final String status;
  final int? waitlistPosition;

  const BookSessionModel({
    required this.bookingId,
    required this.status,
    this.waitlistPosition,
  });

  factory BookSessionModel.fromJson(Map<String, dynamic> json) {
    return BookSessionModel(
      bookingId: json['bookingId'] as int,
      status: json['status'] as String,
      waitlistPosition: json['waitlistPosition'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'status': status,
      'waitlistPosition': waitlistPosition,
    };
  }
}