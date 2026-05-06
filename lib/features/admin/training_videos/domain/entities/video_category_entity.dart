// features/admin/training_videos/domain/entities/video_category_entity.dart

// Represents one option in the "All Categories" filter dropdown.
// Comes from the "categories" field of the backend list response,
// or from GET /api/admin/training-videos/categories.

class VideoCategoryEntity {
  final int categoryId;

  /// Human-readable label shown in the dropdown, e.g. "Cardio".
  final String name;

  const VideoCategoryEntity({
    required this.categoryId,
    required this.name,
  });
}