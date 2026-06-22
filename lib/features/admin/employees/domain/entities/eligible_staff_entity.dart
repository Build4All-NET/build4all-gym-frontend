/// One entry in the "pick an existing trainer/reception" list when adding an
/// employee — see EligibleStaffService on the backend.
class EligibleStaffEntity {
  final int userId;
  final String fullName;
  final String? phone;
  final String? email;
  final int? profileFileId;

  /// "TRAINER" or "RECEPTION".
  final String gymRole;

  const EligibleStaffEntity({
    required this.userId,
    required this.fullName,
    this.phone,
    this.email,
    this.profileFileId,
    required this.gymRole,
  });
}
