// features/admin/training_videos/presentation/bloc/training_videos_state.dart

part of 'training_videos_bloc.dart';

// ── What are States? ──────────────────────────────────────────────────────────
// States describe what the UI should LOOK LIKE right now.
// The UI listens to the BLoC stream and rebuilds whenever the state changes.
//
// States here:
//   Initial  → nothing happened yet (before first event)
//   Loading  → HTTP request in progress → show spinner
//   Loaded   → data arrived → show the list
//   Error    → something went wrong → show error message
// ─────────────────────────────────────────────────────────────────────────────

/// Base class — all states for this BLoC extend this.
abstract class TrainingVideosState {
  const TrainingVideosState();
}

/// Starting state — emitted before the first event is fired.
class TrainingVideosInitial extends TrainingVideosState {
  const TrainingVideosInitial();
}

/// Emitted while the HTTP request is in progress.
/// UI shows a loading spinner/skeleton.
class TrainingVideosLoading extends TrainingVideosState {
  const TrainingVideosLoading();
}

/// Emitted when data successfully arrives from the backend.
/// UI renders stat cards, dropdown, and video list.
class TrainingVideosLoaded extends TrainingVideosState {
  /// Aggregate stat counts (total videos, total views).
  final VideoStatsEntity stats;

  /// All categories for this tenant — keeps the dropdown populated.
  final List<VideoCategoryEntity> categories;

  /// The video list (already filtered if a category was selected).
  final List<TrainingVideoEntity> videos;

  /// Which category is currently selected (null = "All Categories").
  /// Stored here so the dropdown highlights the correct option after rebuild.
  final int? selectedCategoryId;

  const TrainingVideosLoaded({
    required this.stats,
    required this.categories,
    required this.videos,
    this.selectedCategoryId,
  });
}

/// Emitted when the HTTP call fails.
/// UI shows an error message and a retry button.
class TrainingVideosError extends TrainingVideosState {
  final String message;

  const TrainingVideosError(this.message);
}
