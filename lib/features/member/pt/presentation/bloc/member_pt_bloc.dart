import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/trainer_card_entity.dart';
import '../../domain/entities/trainer_detail_entity.dart';
import '../../domain/usecases/get_trainers_usecase.dart';
import '../../domain/usecases/get_filter_options_usecase.dart';
import '../../domain/usecases/toggle_favorite_trainer_usecase.dart';
import '../../domain/usecases/get_trainer_detail_usecase.dart';

part 'member_pt_event.dart';
part 'member_pt_state.dart';

class MemberPtBloc extends Bloc<MemberPtEvent, MemberPtState> {
  final GetTrainersUseCase _getTrainersUseCase;
  final GetFilterOptionsUseCase _getFilterOptionsUseCase;
  final ToggleFavoriteTrainerUseCase _toggleFavoriteTrainerUseCase;
  final GetTrainerDetailUseCase _getTrainerDetailUseCase;

  // Internal fields — reused after toggle reload to maintain active filters.
  String? _activeSpecialtyFilter;
  bool _favoritesOnly = false;

  // Cache specialties so they persist across filter changes.
  List<String> _cachedSpecialties = [];
  List<TrainerCardEntity> _allTrainers = [];
  int _favoriteCount = 0;

  MemberPtBloc({
    required GetTrainersUseCase getTrainersUseCase,
    required GetFilterOptionsUseCase getFilterOptionsUseCase,
    required ToggleFavoriteTrainerUseCase toggleFavoriteTrainerUseCase,
    required GetTrainerDetailUseCase getTrainerDetailUseCase,
  })  : _getTrainersUseCase = getTrainersUseCase,
        _getFilterOptionsUseCase = getFilterOptionsUseCase,
        _toggleFavoriteTrainerUseCase = toggleFavoriteTrainerUseCase,
        _getTrainerDetailUseCase = getTrainerDetailUseCase,
        super(const TrainersInitial()) {
    on<TrainersStarted>(_onStarted);
    on<TrainersSpecialtyFilterChanged>(_onSpecialtyFilterChanged);
    on<TrainersFavoritesFilterToggled>(_onFavoritesFilterToggled);
    on<TrainerFavoriteToggleRequested>(_onFavoriteToggleRequested);
    on<TrainerDetailRequested>(_onTrainerDetailRequested);
  }

  // ── TrainersStarted ───────────────────────────────────────────────────────
  Future<void> _onStarted(
      TrainersStarted event,
      Emitter<MemberPtState> emit,
      ) async {
    emit(const TrainersLoading());

    // Call both use cases concurrently.
    final results = await Future.wait([
      _getFilterOptionsUseCase(),
      _getTrainersUseCase(
        specialtyFilter: _activeSpecialtyFilter,
        favoritesOnly: _favoritesOnly,
      ),
    ]);

    final filterResult = results[0] as ({dynamic data, dynamic failure});
    final trainersResult = results[1] as ({dynamic data, dynamic failure});

    if (filterResult.failure != null) {
      emit(TrainersError(filterResult.failure!.message));
      return;
    }

    if (trainersResult.failure != null) {
      emit(TrainersError(trainersResult.failure!.message));
      return;
    }

    _cachedSpecialties = filterResult.data!.specialties as List<String>;
    _allTrainers = trainersResult.data!.trainers as List<TrainerCardEntity>;
    _favoriteCount = trainersResult.data!.favoriteCount as int;

    emit(
      TrainersLoaded(
        trainers: _applyLocalFilters(),
        favoriteCount: _favoriteCount,
        specialties: _cachedSpecialties,
        activeSpecialtyFilter: _activeSpecialtyFilter,
        favoritesOnly: _favoritesOnly,
      ),
    );
  }

  // ── TrainersSpecialtyFilterChanged ────────────────────────────────────────
  Future<void> _onSpecialtyFilterChanged(
      TrainersSpecialtyFilterChanged event,
      Emitter<MemberPtState> emit,
      ) async {
    _activeSpecialtyFilter = event.specialty;
    _favoritesOnly = false;

    emit(
      TrainersLoaded(
        trainers: _applyLocalFilters(),
        favoriteCount: _favoriteCount,
        specialties: _cachedSpecialties,
        activeSpecialtyFilter: _activeSpecialtyFilter,
        favoritesOnly: _favoritesOnly,
      ),
    );
  }

  // ── TrainersFavoritesFilterToggled ────────────────────────────────────────
  Future<void> _onFavoritesFilterToggled(
      TrainersFavoritesFilterToggled event,
      Emitter<MemberPtState> emit,
      ) async {
    _activeSpecialtyFilter = null;
    _favoritesOnly = !_favoritesOnly;

    emit(
      TrainersLoaded(
        trainers: _applyLocalFilters(),
        favoriteCount: _favoriteCount,
        specialties: _cachedSpecialties,
        activeSpecialtyFilter: _activeSpecialtyFilter,
        favoritesOnly: _favoritesOnly,
      ),
    );
  }

  // ── TrainerFavoriteToggleRequested ────────────────────────────────────────
  Future<void> _onFavoriteToggleRequested(
      TrainerFavoriteToggleRequested event,
      Emitter<MemberPtState> emit,
      ) async {
    if (state is! TrainersLoaded) return;

    final previousAllTrainers = List<TrainerCardEntity>.from(_allTrainers);
    final previousFavoriteCount = _favoriteCount;

    final trainerIndex = _allTrainers.indexWhere(
          (trainer) => trainer.trainerId == event.trainerId,
    );

    if (trainerIndex == -1) return;

    final currentTrainer = _allTrainers[trainerIndex];
    final newFavoriteValue = !currentTrainer.isFavorited;

    // Optimistic update:
    // update the local cache immediately so the UI changes instantly.
    _allTrainers = _allTrainers.map((trainer) {
      if (trainer.trainerId == event.trainerId) {
        return trainer.copyWith(
          isFavorited: newFavoriteValue,
        );
      }

      return trainer;
    }).toList();

    _favoriteCount = _allTrainers.where((trainer) => trainer.isFavorited).length;

    // Re-emit the normal loaded state.
    // If favoritesOnly == true and the trainer was unfavorited,
    // _applyLocalFilters() removes it from the visible list immediately.
    emit(
      TrainersLoaded(
        trainers: _applyLocalFilters(),
        favoriteCount: _favoriteCount,
        specialties: _cachedSpecialties,
        activeSpecialtyFilter: _activeSpecialtyFilter,
        favoritesOnly: _favoritesOnly,
      ),
    );

    final toggleResult = await _toggleFavoriteTrainerUseCase(event.trainerId);

    if (toggleResult.failure != null) {
      // Rollback if backend failed.
      _allTrainers = previousAllTrainers;
      _favoriteCount = previousFavoriteCount;

      emit(
        TrainersLoaded(
          trainers: _applyLocalFilters(),
          favoriteCount: _favoriteCount,
          specialties: _cachedSpecialties,
          activeSpecialtyFilter: _activeSpecialtyFilter,
          favoritesOnly: _favoritesOnly,
        ),
      );

      emit(
        TrainerFavoriteToggleError(
          event.trainerId,
          toggleResult.failure!.message,
        ),
      );

      return;
    }

    // Reload all trainers from backend to keep server as source of truth.
    // Important: fetch all trainers, then apply local filters.
    final reloadResult = await _getTrainersUseCase(
      specialtyFilter: null,
      favoritesOnly: false,
    );

    if (reloadResult.failure != null) {
      return;
    }

    _allTrainers = reloadResult.data!.trainers;
    _favoriteCount = reloadResult.data!.favoriteCount;

    emit(
      TrainersLoaded(
        trainers: _applyLocalFilters(),
        favoriteCount: _favoriteCount,
        specialties: _cachedSpecialties,
        activeSpecialtyFilter: _activeSpecialtyFilter,
        favoritesOnly: _favoritesOnly,
      ),
    );
  }

  // ── TrainerDetailRequested ────────────────────────────────────────────────
  Future<void> _onTrainerDetailRequested(
      TrainerDetailRequested event,
      Emitter<MemberPtState> emit,
      ) async {
    emit(const TrainerDetailLoading());

    final result = await _getTrainerDetailUseCase(event.trainerId);

    if (result.failure != null) {
      emit(TrainerDetailError(result.failure!.message));
      return;
    }

    if (result.data == null) {
      emit(const TrainerDetailError('Trainer details not found.'));
      return;
    }

    emit(TrainerDetailLoaded(result.data!));
  }

  // ── Local filters ─────────────────────────────────────────────────────────
  List<TrainerCardEntity> _applyLocalFilters() {
    var filtered = List<TrainerCardEntity>.from(_allTrainers);

    if (_favoritesOnly) {
      filtered = filtered.where((trainer) => trainer.isFavorited).toList();
    }

    if (_activeSpecialtyFilter != null) {
      filtered = filtered
          .where(
            (trainer) => trainer.specialties.contains(_activeSpecialtyFilter),
      )
          .toList();
    }

    return filtered;
  }
}