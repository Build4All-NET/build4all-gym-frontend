// FILE: lib/features/admin/trainers/domain/entities/admin_trainer_card_entity.dart

class AdminTrainerCardEntity {
  final int          trainerId;
  final String       fullName;
  final String?      email;       // ← ADD
  final String?      phone;       // ← ADD
  final String?      profileFileId;
  final List<String> specialties;
  final double       avgRating;
  final List<String> branchNames; // ← ADD (was called 'branches' before)
  final String       availabilityDisplay;
  final String       status;

  const AdminTrainerCardEntity({
    required this.trainerId,
    required this.fullName,
    this.email,                   // ← ADD
    this.phone,                   // ← ADD
    this.profileFileId,
    required this.specialties,
    required this.avgRating,
    required this.branchNames,    // ← ADD
    required this.availabilityDisplay,
    required this.status,
  });

  bool get isBlocked => status == 'BLOCKED';
  bool get isActive  => status == 'ACTIVE';

  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }
}