// PURPOSE:
//   Request body sent to PUT /api/admin/classes/{sessionId}.
//   ALL fields nullable — only non-null fields are included in toJson()
//   so the BE applies only the fields that were actually changed.
// ─────────────────────────────────────────────────────────────────────────────

class UpdateClassRequestModel {
  final String? className;
  final int?    ptServiceId;
  final int?    trainerId;
  final int?    branchId;
  final String? date;
  final String? time;
  final int?    durationMinutes;
  final int?    capacity;
  final String? roomName;
  final String? notes;
  final String? difficultyLevel;
  final double? price;
  final double? commissionPercentage;
  final bool clearCommissionPercentage;

  const UpdateClassRequestModel({
    this.className,
    this.ptServiceId,
    this.trainerId,
    this.branchId,
    this.date,
    this.time,
    this.durationMinutes,
    this.capacity,
    this.roomName,
    this.notes,
    this.difficultyLevel,
    this.price,
    this.commissionPercentage,
    this.clearCommissionPercentage = false,
  });

  // Only include non-null fields — null means "don't change this"
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (className       != null) map['className']       = className;
    if (ptServiceId     != null) map['ptServiceId']     = ptServiceId;
    if (trainerId       != null) map['trainerId']       = trainerId;
    if (branchId        != null) map['branchId']        = branchId;
    if (date            != null) map['date']            = date;
    if (time            != null) map['time']            = time;
    if (durationMinutes != null) map['durationMinutes'] = durationMinutes;
    if (capacity        != null) map['capacity']        = capacity;
    if (roomName        != null) map['roomName']        = roomName;
    if (notes           != null) map['notes']           = notes;
    if (difficultyLevel != null) map['difficultyLevel'] = difficultyLevel;
    if (price           != null) map['price']           = price;
    if (clearCommissionPercentage) {
      map['clearCommissionPercentage'] = true;
    } else if (commissionPercentage != null) {
      map['commissionPercentage'] = commissionPercentage;
    }
    return map;
  }
}

