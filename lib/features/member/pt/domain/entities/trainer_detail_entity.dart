import 'trainer_video_entity.dart';
import 'pt_package_entity.dart';

class TrainerDetailEntity {
  final int id;
  final String fullName;
  final String? specialty;
  final String? photoUrl;
  final double rating;
  final int reviewCount;
  final double pricePerSession;
  final String currency;
  final bool isFavorite;
  final List<String> certifications;
  final List<TrainerVideoEntity> assignedVideos;
  final int? branchId;
  final String? branchName;

  final List<PtPackageEntity> packages;

  // Weekday codes where trainer has set availability.
  // e.g. ['MONDAY', 'WEDNESDAY', 'FRIDAY']
  // Empty when trainer has no availability configured.
  final List<String> availableDays;

  const TrainerDetailEntity({
    required this.id,
    required this.fullName,
    this.specialty,
    this.photoUrl,
    required this.rating,
    required this.reviewCount,
    required this.pricePerSession,
    required this.currency,
    required this.isFavorite,
    required this.certifications,
    required this.assignedVideos,
    this.branchId,
    this.branchName,
    required this.packages,
    this.availableDays = const [],
  });

  TrainerDetailEntity copyWith({
    int? id,
    String? fullName,
    String? specialty,
    String? photoUrl,
    double? rating,
    int? reviewCount,
    double? pricePerSession,
    String? currency,
    bool? isFavorite,
    List<String>? certifications,
    List<TrainerVideoEntity>? assignedVideos,
    int? branchId,
    String? branchName,
    List<PtPackageEntity>? packages,
    List<String>? availableDays,
  }) {
    return TrainerDetailEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      specialty: specialty ?? this.specialty,
      photoUrl: photoUrl ?? this.photoUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      pricePerSession: pricePerSession ?? this.pricePerSession,
      currency: currency ?? this.currency,
      isFavorite: isFavorite ?? this.isFavorite,
      certifications: certifications ?? this.certifications,
      assignedVideos: assignedVideos ?? this.assignedVideos,
      branchId: branchId ?? this.branchId,
      branchName: branchName ?? this.branchName,
      packages: packages ?? this.packages,
      availableDays: availableDays ?? this.availableDays,
    );
  }
}