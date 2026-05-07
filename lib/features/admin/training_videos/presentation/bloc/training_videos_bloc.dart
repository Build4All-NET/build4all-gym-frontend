import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_training_videos_usecase.dart';
import '../../domain/usecases/get_video_categories_usecase.dart';
import '../../domain/usecases/create_training_video_use_case.dart';
import 'training_videos_event.dart';
import 'training_videos_state.dart';
import '../../domain/usecases/GetTrainersUseCase.dart';

class TrainingVideosBloc extends Bloc<TrainingVideosEvent, TrainingVideosState> {
  final GetTrainingVideosUseCase _getTrainingVideosUseCase;
  final GetVideoCategoriesUseCase _getVideoCategoriesUseCase;
  final CreateTrainingVideoUseCase _createTrainingVideoUseCase;
  final GetTrainersUseCase _getTrainersUseCase;
  TrainingVideosBloc({
    required GetTrainingVideosUseCase getTrainingVideosUseCase,
    required GetVideoCategoriesUseCase getVideoCategoriesUseCase,
    required CreateTrainingVideoUseCase createTrainingVideoUseCase,
    required GetTrainersUseCase getTrainersUseCase,
  })  : _getTrainingVideosUseCase = getTrainingVideosUseCase,
        _getVideoCategoriesUseCase = getVideoCategoriesUseCase,
        _createTrainingVideoUseCase = createTrainingVideoUseCase,
        _getTrainersUseCase = getTrainersUseCase,
        super(TrainingVideosInitial()) {
    on<LoadTrainingVideos>(_onLoad);
    on<FilterByCategory>(_onFilter);
    on<LoadVideoFormOptions>(_onLoadFormOptions);
    on<SubmitCreateVideo>(_onSubmitCreate);
  }

  Future<void> _onLoad(LoadTrainingVideos event, Emitter emit) async {
    emit(TrainingVideosLoading());
    try {
      final (stats, videos) = await _getTrainingVideosUseCase(
        categoryId: event.categoryId,
      );
      final categories = await _getVideoCategoriesUseCase();
      emit(TrainingVideosLoaded(
        stats: stats,
        categories: categories,
        videos: videos,
        selectedCategoryId: event.categoryId,
      ));
    } catch (e) {
      emit(TrainingVideosError(e.toString()));
    }
  }

  Future<void> _onFilter(FilterByCategory event, Emitter emit) async {
    final current = state;
    // Keep categories cached, only reload videos
    List categories = current is TrainingVideosLoaded ? current.categories : [];
    emit(TrainingVideosLoading());
    try {
      final (stats, videos) = await _getTrainingVideosUseCase(
        categoryId: event.categoryId,
      );
      if (categories.isEmpty) categories = await _getVideoCategoriesUseCase();
      emit(TrainingVideosLoaded(
        stats: stats,
        categories: categories.cast(),
        videos: videos,
        selectedCategoryId: event.categoryId,
      ));
    } catch (e) {
      emit(TrainingVideosError(e.toString()));
    }
  }

  Future<void> _onLoadFormOptions(LoadVideoFormOptions event, Emitter emit) async {
    try {
      // getTrainersUseCase now returns List<TrainerOption> directly (already unwrapped)
      final trainers = await _getTrainersUseCase();
      emit(VideoFormOptionsLoaded(trainers: trainers));
    } catch (e) {
      emit(CreateVideoError(e.toString()));
    }
  }

  Future<void> _onSubmitCreate(SubmitCreateVideo event, Emitter emit) async {
    emit(CreateVideoLoading());
    try {
      await _createTrainingVideoUseCase(event.request);
      emit(CreateVideoSuccess());
    } catch (e) {
      emit(CreateVideoError(e.toString()));
    }
  }
}