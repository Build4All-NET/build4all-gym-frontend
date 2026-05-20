import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/trainer_option.dart';
import '../../domain/entities/video_category_entity.dart';
import '../../domain/usecases/CreateCategoryUseCase.dart';
import '../../domain/usecases/get_training_videos_usecase.dart';
import '../../domain/usecases/get_video_categories_usecase.dart';
import '../../domain/usecases/create_training_video_use_case.dart';
import '../../domain/usecases/update_training_video_usecase.dart';
import '../../domain/usecases/delete_video_usecase.dart';
import 'training_videos_event.dart';
import 'training_videos_state.dart';
import '../../domain/usecases/GetTrainersUseCase.dart';

class TrainingVideosBloc extends Bloc<TrainingVideosEvent, TrainingVideosState> {
  final GetTrainingVideosUseCase    _getTrainingVideosUseCase;
  final GetVideoCategoriesUseCase   _getVideoCategoriesUseCase;
  final CreateTrainingVideoUseCase  _createTrainingVideoUseCase;
  final UpdateTrainingVideoUseCase  _updateTrainingVideoUseCase;
  final DeleteVideoUseCase          _deleteVideoUseCase;
  final GetTrainersUseCase          _getTrainersUseCase;
  final CreateCategoryUseCase       _createCategoryUseCase;

  TrainingVideosBloc({
    required GetTrainingVideosUseCase getTrainingVideosUseCase,
    required GetVideoCategoriesUseCase getVideoCategoriesUseCase,
    required CreateTrainingVideoUseCase createTrainingVideoUseCase,
    required UpdateTrainingVideoUseCase updateTrainingVideoUseCase,
    required DeleteVideoUseCase deleteVideoUseCase,
    required GetTrainersUseCase getTrainersUseCase,
    required CreateCategoryUseCase createCategoryUseCase,
  })  : _getTrainingVideosUseCase = getTrainingVideosUseCase,
        _getVideoCategoriesUseCase = getVideoCategoriesUseCase,
        _createTrainingVideoUseCase = createTrainingVideoUseCase,
        _updateTrainingVideoUseCase = updateTrainingVideoUseCase,
        _deleteVideoUseCase = deleteVideoUseCase,
        _getTrainersUseCase = getTrainersUseCase,
        _createCategoryUseCase = createCategoryUseCase,
        super(TrainingVideosInitial()) {
    on<LoadTrainingVideos>(_onLoad);
    on<FilterByCategory>(_onFilter);
    on<LoadVideoFormOptions>(_onLoadFormOptions);
    on<SubmitCreateVideo>(_onSubmitCreate);
    on<SubmitUpdateVideo>(_onSubmitUpdate);
    on<DeleteVideo>(_onDeleteVideo);
    on<AddNewCategory>(_onAddNewCategory);
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
      // Load both in parallel
      final results = await Future.wait([
        _getTrainersUseCase(),
        _getVideoCategoriesUseCase(),
      ]);
      emit(VideoFormOptionsLoaded(
        trainers: results[0] as List<TrainerOption>,
        categories: results[1] as List<VideoCategoryEntity>,
      ));
    } catch (e) {
      emit(CreateVideoError(e.toString()));
    }
  }

  Future<void> _onAddNewCategory(AddNewCategory event, Emitter emit) async {
    emit(CategoryCreating());
    try {
      final newCategory = await _createCategoryUseCase(event.name);
      emit(CategoryCreated(newCategory));
    } catch (e) {
      emit(CategoryCreateError(e.toString()));
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

  Future<void> _onSubmitUpdate(SubmitUpdateVideo event, Emitter emit) async {
    emit(UpdateVideoLoading());
    try {
      await _updateTrainingVideoUseCase(event.request);
      emit(UpdateVideoSuccess());
    } catch (e) {
      emit(UpdateVideoError(e.toString()));
    }
  }

  Future<void> _onDeleteVideo(DeleteVideo event, Emitter emit) async {
    emit(DeleteVideoLoading());
    try {
      await _deleteVideoUseCase(event.videoId);
      emit(DeleteVideoSuccess(event.videoId));
    } catch (e) {
      emit(DeleteVideoError(e.toString()));
    }
  }
}