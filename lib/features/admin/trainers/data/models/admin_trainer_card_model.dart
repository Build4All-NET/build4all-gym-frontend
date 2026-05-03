
// ─────────────────────────────────────────────────────────────────────────────
// admin_trainer_card_model.dart
// ─────────────────────────────────────────────────────────────────────────────
class AdminTrainerCardModel {
  final int     trainerId;
  final String  fullName;
  final String? email;  // ← ADD
  final String? phone;
  final String? profileFileId;       // nullable — avatar
  final List<String> specialties;
  final double  avgRating;
  final List<String> branches;
  final String  availabilityDisplay; // pre-formatted by BE e.g. "Mon-Sat 6AM-2PM"
  final String  status;              // ACTIVE | BLOCKED

  const AdminTrainerCardModel({
    required this.trainerId,
    required this.fullName,
    this.profileFileId,
    required this.specialties,
    required this.avgRating,
    required this.branches,
    required this.availabilityDisplay,
    required this.status,
    this.email,
    this.phone,
  });

  factory AdminTrainerCardModel.fromJson(Map<String, dynamic> json) =>
      AdminTrainerCardModel(
        trainerId:           json['trainerId']           as int,
        fullName:            json['fullName']            as String,
        email:               json['email']               as String?,  // ← ADD
        phone:               json['phone']               as String?,  // ← ADD
        profileFileId:       json['profileFileId']?.toString(),
        specialties:         List<String>.from(json['specialties'] ?? []),
        avgRating:           (json['avgRating'] as num?)?.toDouble() ?? 0.0,
        branches:            List<String>.from(json['branchNames'] ?? []),
        availabilityDisplay: json['availabilityDisplay'] as String? ?? '',
        status:              json['status']              as String?   ?? 'ACTIVE',
      );
}
