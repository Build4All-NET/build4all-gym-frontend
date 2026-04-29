class BookSessionResultEntity {
  final int bookingId;
  final String status;
  final int? waitlistPosition;

  const BookSessionResultEntity({
    required this.bookingId,
    required this.status,
    this.waitlistPosition,
  });
}