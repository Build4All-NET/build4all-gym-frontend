import 'trainer_branch_entity.dart';

class TrainerCardEntity {
  final int trainerId;
  final String fullName;
  final String? profileFileId;

  /// @deprecated Use [branches] — a trainer can be assigned to more than one
  /// branch; this field only ever reflected an arbitrary single branch.
  final int? branchId;

  /// @deprecated Use [branches].
  final String? branchName;

  /// Every branch this trainer is assigned to.
  final List<TrainerBranchEntity> branches;

  /// Whether the current member can book this trainer at all right now.
  final bool bookable;

  /// The branch a booking should be created against when [bookable] is true.
  final int? bookableBranchId;

  /// Machine-stable reason code when [bookable] is false (e.g.
  /// "NO_ACTIVE_MEMBERSHIP", "TRAINER_NOT_AVAILABLE_AT_MEMBERSHIP_BRANCH").
  final String? restrictionCode;

  final List<String> specialties;
  final List<String> certifications;
  final double pricePerSession;
  final int? yearsOfExperience;
  final int reviewCount;
  final double avgRating;
  final bool isFavorited;
  final bool isOnline;

  const TrainerCardEntity({
    required this.trainerId,
    required this.fullName,
    this.profileFileId,
    this.branchId,
    this.branchName,
    this.branches = const [],
    this.bookable = true,
    this.bookableBranchId,
    this.restrictionCode,
    required this.specialties,
    required this.certifications,
    required this.pricePerSession,
    this.yearsOfExperience,
    required this.reviewCount,
    required this.avgRating,
    required this.isFavorited,
    required this.isOnline,
  });

  TrainerCardEntity copyWith({
    int? trainerId,
    String? fullName,
    String? profileFileId,
    int? branchId,
    String? branchName,
    List<TrainerBranchEntity>? branches,
    bool? bookable,
    int? bookableBranchId,
    String? restrictionCode,
    List<String>? specialties,
    List<String>? certifications,
    double? pricePerSession,
    int? yearsOfExperience,
    int? reviewCount,
    double? avgRating,
    bool? isFavorited,
    bool? isOnline,
  }) {
    return TrainerCardEntity(
      trainerId: trainerId ?? this.trainerId,
      fullName: fullName ?? this.fullName,
      profileFileId: profileFileId ?? this.profileFileId,
      branchId: branchId ?? this.branchId,
      branchName: branchName ?? this.branchName,
      branches: branches ?? this.branches,
      bookable: bookable ?? this.bookable,
      bookableBranchId: bookableBranchId ?? this.bookableBranchId,
      restrictionCode: restrictionCode ?? this.restrictionCode,
      specialties: specialties ?? this.specialties,
      certifications: certifications ?? this.certifications,
      pricePerSession: pricePerSession ?? this.pricePerSession,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      reviewCount: reviewCount ?? this.reviewCount,
      avgRating: avgRating ?? this.avgRating,
      isFavorited: isFavorited ?? this.isFavorited,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}