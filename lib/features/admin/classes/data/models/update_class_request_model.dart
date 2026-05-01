// PURPOSE:
//   Request body sent to PUT /api/admin/classes/{sessionId}.
//   ALL fields nullable — only non-null fields are included in toJson()
//   so the BE applies only the fields that were actually changed.
// ─────────────────────────────────────────────────────────────────────────────

class UpdateClassRequestModel {
  final String? className;
  final int?    classTypeId;
  final int?    trainerId;
  final int?    branchId;
  final String? date;
  final String? time;
  final int?    durationMinutes;
  final int?    capacity;
  final String? roomName;
  final String? notes;

  const UpdateClassRequestModel({
    this.className,
    this.classTypeId,
    this.trainerId,
    this.branchId,
    this.date,
    this.time,
    this.durationMinutes,
    this.capacity,
    this.roomName,
    this.notes,
  });

  // Only include non-null fields — null means "don't change this"
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (className       != null) map['className']       = className;
    if (classTypeId     != null) map['classTypeId']     = classTypeId;
    if (trainerId       != null) map['trainerId']       = trainerId;
    if (branchId        != null) map['branchId']        = branchId;
    if (date            != null) map['date']            = date;
    if (time            != null) map['time']            = time;
    if (durationMinutes != null) map['durationMinutes'] = durationMinutes;
    if (capacity        != null) map['capacity']        = capacity;
    if (roomName        != null) map['roomName']        = roomName;
    if (notes           != null) map['notes']           = notes;
    return map;
  }
}

