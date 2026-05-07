import '../../domain/entities/video_category_entity.dart';

class VideoCategoryModel extends VideoCategoryEntity {
  const VideoCategoryModel({required super.categoryId, required super.name});

  factory VideoCategoryModel.fromJson(Map<String, dynamic> json) =>
      VideoCategoryModel(
        categoryId: (json['categoryId'] as num).toInt(), // ✅ num → int safely
        name: json['name'] as String,
      );
}