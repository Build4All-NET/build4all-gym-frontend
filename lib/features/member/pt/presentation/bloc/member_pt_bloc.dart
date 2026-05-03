import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/trainer_card_entity.dart';
import '../../domain/usecases/get_trainers_usecase.dart';
import '../../domain/usecases/get_filter_options_usecase.dart';
import '../../domain/usecases/toggle_favorite_trainer_usecase.dart';

part 'member_pt_event.dart';
part 'member_pt_state.dart';

class MemberPtBloc extends Bloc<MemberPtEvent, MemberPtState> {
  final GetTrainersUseCase _getTrainersUseCase;
  final GetFilterOptionsUseCase _getFilterOptionsUseCase;
  final ToggleFavoriteTrainerUseCase _toggleFavoriteTrainerUseCase;

  // Internal fields — reused after toggle reload to maintain active filters.
  String? _activeSpecialtyFilter;
  bool _favoritesOnly = false;

  // Cache specialties so they persist across filter changes.
  List<String> _cachedSpecialties = [];

  MemberPtBloc({
    required GetTrainersUseCase getTrainersUseCase,
    required GetFilterOptionsUseCase getFilterOptionsUseCase,
    required ToggleFavoriteTrainerUseCase toggleFavoriteTrainerUseCase,
  })  : _getTrainersUseCase = getTrainersUseCase,
        _getFilterOptionsUseCase = getFilterOptionsUseCase,
        _toggleFavoriteTrainerUseCase = toggleFavoriteTrainerUseCase,
        super(const TrainersInitial()) {
    on<TrainersStarted>(_onStarted);
    on<TrainersSpecialtyFilterChanged>(_onSpecialtyFilterChanged);
    on<TrainersFavoritesFilterToggled>(_onFavoritesFilterToggled);
    on<TrainerFavoriteToggleRequested>(_onFavoriteToggleRequested);
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

    emit(TrainersLoaded(
      trainers: trainersResult.data!.trainers as List<TrainerCardEntity>,
      favoriteCount: trainersResult.data!.favoriteCount as int,
      specialties: _cachedSpecialties,
      activeSpecialtyFilter: _activeSpecialtyFilter,
      favoritesOnly: _favoritesOnly,
    ));
  }

  // ── TrainersSpecialtyFilterChanged ────────────────────────────────────────
  Future<void> _onSpecialtyFilterChanged(
      TrainersSpecialtyFilterChanged event,
      Emitter<MemberPtState> emit,
      ) async {
    _activeSpecialtyFilter = event.specialty;
    _favoritesOnly = false;
    emit(const TrainersLoading());

    final result = await _getTrainersUseCase(
      specialtyFilter: _activeSpecialtyFilter,
      favoritesOnly: _favoritesOnly,
    );

    if (result.failure != null) {
      emit(TrainersError(result.failure!.message));
      return;
    }

    emit(TrainersLoaded(
      trainers: result.data!.trainers,
      favoriteCount: result.data!.favoriteCount,
      specialties: _cachedSpecialties,
      activeSpecialtyFilter: _activeSpecialtyFilter,
      favoritesOnly: _favoritesOnly,
    ));
  }

  // ── TrainersFavoritesFilterToggled ────────────────────────────────────────
  Future<void> _onFavoritesFilterToggled(
      TrainersFavoritesFilterToggled event,
      Emitter<MemberPtState> emit,
      ) async {
    _activeSpecialtyFilter = null;
    _favoritesOnly = !_favoritesOnly;
    emit(const TrainersLoading());

    final result = await _getTrainersUseCase(
      specialtyFilter: _activeSpecialtyFilter,


      favoritesOnly: _favoritesOnly,
    );

    if (result.failure != null) {
      emit(TrainersError(result.failure!.message));
      return;
    }

    emit(TrainersLoaded(
      trainers: result.data!.trainers,
      favoriteCount: result.data!.favoriteCount,
      specialties: _cachedSpecialties,
      activeSpecialtyFilter: _activeSpecialtyFilter,
      favoritesOnly: _favoritesOnly,
    ));
  }

  // ── TrainerFavoriteToggleRequested ────────────────────────────────────────
  Future<void> _onFavoriteToggleRequested(
      TrainerFavoriteToggleRequested event,
      Emitter<MemberPtState> emit,
      ) async {
    // Show loading on the specific card only.
    emit(TrainerFavoriteToggleLoading(event.trainerId));

    final toggleResult = await _toggleFavoriteTrainerUseCase(event.trainerId);

    if (toggleResult.failure != null) {
      emit(TrainerFavoriteToggleError(
        event.trainerId,
        toggleResult.failure!.message,
      ));
      return;
    }

    // Full reload after toggle — intentional and correct.
    // Reason: if favoritesOnly is active and user unfavorites a trainer,
    // that trainer must disappear from the list. In-place update cannot
    // handle this case. Full reload is fast and always consistent with BE.
    final reloadResult = await _getTrainersUseCase(
      specialtyFilter: _activeSpecialtyFilter,
      favoritesOnly: _favoritesOnly,
    );

    if (reloadResult.failure != null) {
      emit(TrainersError(reloadResult.failure!.message));
      return;
    }

    emit(TrainersLoaded(
      trainers: reloadResult.data!.trainers,
      favoriteCount: reloadResult.data!.favoriteCount,
      specialties: _cachedSpecialties,
      activeSpecialtyFilter: _activeSpecialtyFilter,
      favoritesOnly: _favoritesOnly,
    ));
  }
}