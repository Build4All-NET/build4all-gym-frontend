// features/admin/training_videos/presentation/bloc/training_videos_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/training_video_entity.dart';
import '../../domain/entities/video_category_entity.dart';
import '../../domain/entities/video_stats_entity.dart';
import '../../domain/usecases/get_training_videos_usecase.dart';

// These two files are declared as "part of" this file so they can access
// private members and share the same library scope.
part 'training_videos_event.dart';
part 'training_videos_state.dart';

// ── What does this BLoC do? ───────────────────────────────────────────────────
// Listens for Events dispatched by the UI.
// Calls use cases to get data.
// Emits States that the UI rebuilds from.
//
// The UI never calls use cases directly — it only talks to the BLoC.
// ─────────────────────────────────────────────────────────────────────────────

class TrainingVideosBloc extends Bloc<TrainingVideosEvent, TrainingVideosState> {
  final GetTrainingVideosUseCase getTrainingVideosUseCase;

  TrainingVideosBloc({
    required this.getTrainingVideosUseCase,
  }) : super(const TrainingVideosInitial()) {
    // Register event handlers — each event type maps to one handler method
    on<LoadTrainingVideos>(_onLoad);
    on<FilterByCategory>(_onFilterByCategory);
  }

  // ── LoadTrainingVideos handler ─────────────────────────────────────────────
  // Fired on screen init. Loads all videos with no filter.
  Future<void> _onLoad(
      LoadTrainingVideos event,
      Emitter<TrainingVideosState> emit,
      ) async {
    // Tell the UI to show a spinner
    emit(const TrainingVideosLoading());

    // Call the use case — returns Either<AppException, TrainingVideoListResult>
    final result = await getTrainingVideosUseCase(categoryId: null);

    // fold() runs the LEFT function on failure, RIGHT function on success
    result.fold(
      // Left → failure → emit error state with the exception message
          (failure) => emit(TrainingVideosError(failure.message)),

      // Right → success → emit loaded state with all data
          (data) => emit(TrainingVideosLoaded(
        stats:              data.stats,
        categories:         data.categories,
        videos:             data.videos,
        selectedCategoryId: null, // no filter active on initial load
      )),
    );
  }

  // ── FilterByCategory handler ───────────────────────────────────────────────
  // Fired when the user picks a category in the dropdown.
  // Reloads the video list with the new filter applied.
  Future<void> _onFilterByCategory(
      FilterByCategory event,
      Emitter<TrainingVideosState> emit,
      ) async {
    // Show loading while the filtered request is in flight.
    // We could keep showing the old list, but a spinner is simpler for now.
    emit(const TrainingVideosLoading());

    // Call use case with the selected categoryId (null = all categories)
    final result = await getTrainingVideosUseCase(categoryId: event.categoryId);

    result.fold(
          (failure) => emit(TrainingVideosError(failure.message)),
          (data) => emit(TrainingVideosLoaded(
        stats:              data.stats,
        categories:         data.categories,
        videos:             data.videos,
        selectedCategoryId: event.categoryId, // remember which filter is active
      )),
    );
  }
}