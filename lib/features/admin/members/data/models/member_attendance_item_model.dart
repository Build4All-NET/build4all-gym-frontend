class MemberAttendanceItemModel {
  final int     checkinId;
  final String  date;
  final String  checkinTime;
  final String? checkoutTime;
  final int?    durationMinutes;
  final String  status;
  final String? checkinType;

  const MemberAttendanceItemModel({
    required this.checkinId,
    required this.date,
    required this.checkinTime,
    this.checkoutTime,
    this.durationMinutes,
    required this.status,
    this.checkinType,
  });

  factory MemberAttendanceItemModel.fromJson(Map<String, dynamic> json) {
    return MemberAttendanceItemModel(
      checkinId:       json['checkinId']       as int,
      date:            json['date']            as String? ?? '',
      checkinTime:     json['checkinTime']     as String? ?? '',
      checkoutTime:    json['checkoutTime']    as String?,
      durationMinutes: json['durationMinutes'] as int?,
      status:          json['status']          as String? ?? 'UNKNOWN',
      checkinType:     json['checkinType']     as String?,
    );
  }
}
