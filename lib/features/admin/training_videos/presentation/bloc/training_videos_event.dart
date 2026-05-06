// features/admin/training_videos/presentation/bloc/training_videos_event.dart

part of 'training_videos_bloc.dart';

// ── What are Events? ──────────────────────────────────────────────────────────
// Events are things that HAPPEN — user actions or lifecycle triggers.
// The UI dispatches events; the BLoC reacts to them and emits new States.
//
// Think of it as:
//   UI fires an Event → BLoC handles it → BLoC emits a State → UI rebuilds
// ─────────────────────────────────────────────────────────────────────────────

/// Base class — all events for this BLoC extend this.
abstract class TrainingVideosEvent {
  const TrainingVideosEvent();
}

/// Fired when the screen first loads (initState or BlocProvider creation).
/// Loads all videos with no category filter.
class LoadTrainingVideos extends TrainingVideosEvent {
  const LoadTrainingVideos();
}

/// Fired when the user picks a category from the dropdown.
///
/// [categoryId] = null means "All Categories" (the default option).
/// [categoryId] = an int means filter to that specific category.
class FilterByCategory extends TrainingVideosEvent {
  final int? categoryId;

  const FilterByCategory(this.categoryId);
}