import '../../domain/entities/trainer_detail_entity.dart';
import 'trainer_video_model.dart';
import 'pt_package_model.dart';

class TrainerDetailModel {
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
  final List<TrainerVideoModel> assignedVideos;
  final int? branchId;
  final String? branchName;

  final List<PtPackageModel> packages;

  const TrainerDetailModel({
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
  });

  factory TrainerDetailModel.fromJson(Map<String, dynamic> json) {
    final videosJson = json['assignedVideos'];
    final packagesJson = json['packages'];

    return TrainerDetailModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      fullName: json['fullName'] as String? ?? '',
      specialty: json['specialty'] as String?,
      photoUrl: json['photoUrl'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      pricePerSession: (json['pricePerSession'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'USD',
      isFavorite: json['isFavorite'] as bool? ??
          json['favorite'] as bool? ??
          false,
      certifications: List<String>.from(json['certifications'] ?? []),
      assignedVideos: videosJson is List
          ? videosJson
          .map(
            (item) => TrainerVideoModel.fromJson(
          item as Map<String, dynamic>,
        ),
      )
          .toList()
          : const [],
      branchId: json['branchId'] != null
          ? (json['branchId'] as num).toInt()
          : null,
      branchName: json['branchName'] as String?,
      packages: packagesJson is List
          ? packagesJson
          .map(
            (item) => PtPackageModel.fromJson(
          item as Map<String, dynamic>,
        ),
      )
          .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'specialty': specialty,
      'photoUrl': photoUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'pricePerSession': pricePerSession,
      'currency': currency,
      'isFavorite': isFavorite,
      'certifications': certifications,
      'assignedVideos': assignedVideos.map((video) => video.toJson()).toList(),
      'branchId': branchId,
      'branchName': branchName,
      'packages': packages.map((ptPackage) => ptPackage.toJson()).toList(),
    };
  }

  TrainerDetailEntity toEntity() {
    return TrainerDetailEntity(
      id: id,
      fullName: fullName,
      specialty: specialty,
      photoUrl: photoUrl,
      rating: rating,
      reviewCount: reviewCount,
      pricePerSession: pricePerSession,
      currency: currency,
      isFavorite: isFavorite,
      certifications: certifications,
      assignedVideos: assignedVideos.map((video) => video.toEntity()).toList(),
      branchId: branchId,
      branchName: branchName,
      packages: packages.map((ptPackage) => ptPackage.toEntity()).toList(),
    );
  }
}