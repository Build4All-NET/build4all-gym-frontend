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

  // Internal fields — reused after reload to maintain active filters.
  String? _activeSpecialtyFilter;
  int? _activeBranchFilter;
  bool _favoritesOnly = false;

  // Cache data so it persists across filter changes.
  List<String> _cachedSpecialties = [];
  Map<int, String> _cachedBranches = {};

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
    on<TrainersAllFiltersCleared>(_onAllFiltersCleared);
    on<TrainersSpecialtyFilterChanged>(_onSpecialtyFilterChanged);
    on<TrainersBranchFilterChanged>(_onBranchFilterChanged);
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

    final results = await Future.wait([
      _getFilterOptionsUseCase(),
      _getTrainersUseCase(
        specialtyFilter: null,
        favoritesOnly: false,
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
    for (final trainer in _allTrainers) {
      print(
        'PT TRAINER => id=${trainer.trainerId}, '
            'name=${trainer.fullName}, '
            'branchId=${trainer.branchId}, '
            'branchName=${trainer.branchName}',
      );
    }
    _favoriteCount = trainersResult.data!.favoriteCount as int;

    _cachedBranches = _extractBranches(_allTrainers);

    _emitLoaded(emit);
  }

  // ── TrainersAllFiltersCleared ─────────────────────────────────────────────
  Future<void> _onAllFiltersCleared(
      TrainersAllFiltersCleared event,
      Emitter<MemberPtState> emit,
      ) async {
    _activeSpecialtyFilter = null;
    _activeBranchFilter = null;
    _favoritesOnly = false;

    _emitLoaded(emit);
  }

  // ── TrainersSpecialtyFilterChanged ────────────────────────────────────────
  Future<void> _onSpecialtyFilterChanged(
      TrainersSpecialtyFilterChanged event,
      Emitter<MemberPtState> emit,
      ) async {
    _activeSpecialtyFilter = event.specialty;
    _favoritesOnly = false;

    _emitLoaded(emit);
  }

  // ── TrainersBranchFilterChanged ───────────────────────────────────────────
  Future<void> _onBranchFilterChanged(
      TrainersBranchFilterChanged event,
      Emitter<MemberPtState> emit,
      ) async {
    _activeBranchFilter = event.branchId;
    _favoritesOnly = false;

    _emitLoaded(emit);
  }

  // ── TrainersFavoritesFilterToggled ────────────────────────────────────────
  Future<void> _onFavoritesFilterToggled(
      TrainersFavoritesFilterToggled event,
      Emitter<MemberPtState> emit,
      ) async {
    _activeSpecialtyFilter = null;
    _activeBranchFilter = null;
    _favoritesOnly = !_favoritesOnly;

    _emitLoaded(emit);
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

    // Optimistic update.
    _allTrainers = _allTrainers.map((trainer) {
      if (trainer.trainerId == event.trainerId) {
        return trainer.copyWith(
          isFavorited: newFavoriteValue,
        );
      }

      return trainer;
    }).toList();

    _favoriteCount = _allTrainers.where((trainer) => trainer.isFavorited).length;
    _cachedBranches = _extractBranches(_allTrainers);

    _emitLoaded(emit);

    final toggleResult = await _toggleFavoriteTrainerUseCase(event.trainerId);

    if (toggleResult.failure != null) {
      // Rollback if backend failed.
      _allTrainers = previousAllTrainers;
      _favoriteCount = previousFavoriteCount;
      _cachedBranches = _extractBranches(_allTrainers);

      _emitLoaded(emit);

      emit(
        TrainerFavoriteToggleError(
          event.trainerId,
          toggleResult.failure!.message,
        ),
      );

      return;
    }

    // Reload all trainers from backend to keep server as source of truth.
    final reloadResult = await _getTrainersUseCase(
      specialtyFilter: null,
      favoritesOnly: false,
    );

    if (reloadResult.failure != null) {
      return;
    }

    _allTrainers = reloadResult.data!.trainers;
    _favoriteCount = reloadResult.data!.favoriteCount;
    _cachedBranches = _extractBranches(_allTrainers);

    _emitLoaded(emit);
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

  // ── Emit loaded state ─────────────────────────────────────────────────────
  void _emitLoaded(Emitter<MemberPtState> emit) {
    emit(
      TrainersLoaded(
        trainers: _applyLocalFilters(),
        favoriteCount: _favoriteCount,
        specialties: _cachedSpecialties,
        branches: _cachedBranches,
        activeSpecialtyFilter: _activeSpecialtyFilter,
        activeBranchFilter: _activeBranchFilter,
        favoritesOnly: _favoritesOnly,
      ),
    );
  }

  // ── Local filters ─────────────────────────────────────────────────────────
  List<TrainerCardEntity> _applyLocalFilters() {
    var filtered = List<TrainerCardEntity>.from(_allTrainers);

    if (_favoritesOnly) {
      filtered = filtered.where((trainer) => trainer.isFavorited).toList();
    }

    if (_activeBranchFilter != null) {
      filtered = filtered
          .where((trainer) => trainer.branchId == _activeBranchFilter)
          .toList();
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

  // ── Branch extraction ─────────────────────────────────────────────────────
  Map<int, String> _extractBranches(List<TrainerCardEntity> trainers) {
    final branchMap = <int, String>{};

    for (final trainer in trainers) {
      final branchId = trainer.branchId;

      if (branchId == null || branchId <= 0) {
        continue;
      }

      final branchName = trainer.branchName?.trim();

      branchMap[branchId] = branchName == null || branchName.isEmpty
          ? 'Branch $branchId'
          : branchName;
    }

    final entries = branchMap.entries.toList()
      ..sort(
            (a, b) => a.value.toLowerCase().compareTo(b.value.toLowerCase()),
      );

    return {
      for (final entry in entries) entry.key: entry.value,
    };
  }
}