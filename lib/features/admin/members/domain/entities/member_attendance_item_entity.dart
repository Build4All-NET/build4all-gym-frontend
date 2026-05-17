class MemberAttendanceItemEntity {
  final int     checkinId;
  final String  date;
  final String  checkinTime;
  final String? checkoutTime;
  final int?    durationMinutes;
  final String  status;
  final String? checkinType;

  const MemberAttendanceItemEntity({
    required this.checkinId,
    required this.date,
    required this.checkinTime,
    this.checkoutTime,
    this.durationMinutes,
    required this.status,
    this.checkinType,
  });

  bool get isActive => status == 'ACTIVE';
}
