class TrainerCardEntity {
  final int trainerId;
  final String fullName;
  final String? profileFileId;

  final int? branchId;
  final String? branchName;

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