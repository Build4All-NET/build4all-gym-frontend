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
      trainerId: (json['trainerId'] as num?)?.toInt() ?? 0,
      fullName: json['fullName'] as String? ?? '',
      profileFileId: json['profileFileId'] as String?,

      specialties: (json['specialties'] as List<dynamic>? ?? [])
          .map((item) => item.toString())
          .toList(),

      certifications: (json['certifications'] as List<dynamic>? ?? [])
          .map((item) => item.toString())
          .toList(),

      // Backend can return null here, so fallback to 0.0.
      pricePerSession: (json['pricePerSession'] as num?)?.toDouble() ?? 0.0,

      yearsOfExperience: (json['yearsOfExperience'] as num?)?.toInt(),

      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,

      avgRating: (json['avgRating'] as num?)?.toDouble() ?? 0.0,

      isFavorited:
      json['favorited'] as bool? ?? json['isFavorited'] as bool? ?? false,

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