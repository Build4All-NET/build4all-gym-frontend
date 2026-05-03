import 'package:build4allgym/features/member/pt/domain/entities/trainer_card_entity.dart';

class TrainerCardModel {
  final int trainerId;
  final String fullName;
  final String? profileFileId;
  final List<String> specialties;
  final List<String> certifications;
  final double pricePerSession;
  final int? yearsOfExperience;
  final int reviewCount;
  final double avgRating;
  final bool isFavorited;
  final bool isOnline;

  const TrainerCardModel({
    required this.trainerId,
    required this.fullName,
    this.profileFileId,
    required this.specialties,
    required this.certifications,
    required this.pricePerSession,
    this.yearsOfExperience,
    required this.reviewCount,
    required this.avgRating,
    required this.isFavorited,
    required this.isOnline,
  });

  factory TrainerCardModel.fromJson(Map<String, dynamic> json) {
    return TrainerCardModel(
      trainerId: (json['trainerId'] as num).toInt(),
      fullName: json['fullName'] as String,
      profileFileId: json['profileFileId'] as String?,
      specialties: List<String>.from(json['specialties'] ?? []),
      certifications: List<String>.from(json['certifications'] ?? []),
      pricePerSession: (json['pricePerSession'] as num).toDouble(),
      yearsOfExperience: json['yearsOfExperience'] != null
          ? (json['yearsOfExperience'] as num).toInt()
          : null,
      reviewCount: (json['reviewCount'] as num).toInt(),
      avgRating: (json['avgRating'] as num).toDouble(),
      isFavorited: json['favorited'] as bool? ?? json['isFavorited'] as bool? ?? false,
      isOnline: json['online'] as bool? ?? json['isOnline'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trainerId': trainerId,
      'fullName': fullName,
      'profileFileId': profileFileId,
      'specialties': specialties,
      'certifications': certifications,
      'pricePerSession': pricePerSession,
      'yearsOfExperience': yearsOfExperience,
      'reviewCount': reviewCount,
      'avgRating': avgRating,
      'isFavorited': isFavorited,
      'isOnline': isOnline,
    };
  }

  TrainerCardEntity toEntity() {
    return TrainerCardEntity(
      trainerId: trainerId,
      fullName: fullName,
      profileFileId: profileFileId,
      specialties: specialties,
      certifications: certifications,
      pricePerSession: pricePerSession,
      yearsOfExperience: yearsOfExperience,
      reviewCount: reviewCount,
      avgRating: avgRating,
      isFavorited: isFavorited,
      isOnline: isOnline,
    );
  }
}