import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/admin_trainer_card_entity.dart';
import '../../domain/entities/trainer_form_options_entity.dart';
import '../../domain/usecases/get_trainer_detail_usecase.dart';
import '../../domain/usecases/get_trainers_usecase.dart';
import '../../domain/usecases/get_trainer_form_options_usecase.dart';
import '../../domain/usecases/create_trainer_usecase.dart';
import '../../domain/usecases/update_trainer_usecase.dart';
import '../../domain/usecases/block_trainer_usecase.dart';
import '../../data/models/create_trainer_request_model.dart';
import '../../data/models/update_trainer_request_model.dart';
import 'admin_trainers_event.dart';
import 'admin_trainers_state.dart';

class AdminTrainersBloc extends Bloc<AdminTrainersEvent, AdminTrainersState> {

  final GetTrainersUseCase           _getTrainers;
  final GetTrainerFormOptionsUseCase _getFormOptions;
  final CreateTrainerUseCase         _createTrainer;
  final UpdateTrainerUseCase         _updateTrainer;
  final BlockTrainerUseCase          _blockTrainer;
  final GetTrainerDetailUseCase _getTrainerDetail;

  // Internal filter state — persisted across actions so reload uses same filters
  String? _activeSearch;
  String? _activeSpecialty;

  // Debounce timer for search
  Timer? _searchDebounce;

  AdminTrainersBloc({
    required GetTrainersUseCase           getTrainers,
    required GetTrainerFormOptionsUseCase getFormOptions,
    required CreateTrainerUseCase         createTrainer,
    required UpdateTrainerUseCase         updateTrainer,
    required BlockTrainerUseCase          blockTrainer,
    required GetTrainerDetailUseCase    getTrainerDetail,
  })  : _getTrainers    = getTrainers,
        _getFormOptions = getFormOptions,
        _createTrainer  = createTrainer,
        _updateTrainer  = updateTrainer,
        _blockTrainer   = blockTrainer,
        _getTrainerDetail = getTrainerDetail,
        super(TrainersInitial()) {
    on<TrainersStarted>(_onStarted);
    on<TrainersSearchChanged>(_onSearchChanged);
    on<TrainersSpecialtyFilterChanged>(_onSpecialtyChanged);
    on<TrainerFormOptionsRequested>(_onFormOptionsRequested);
    on<TrainerCreateRequested>(_onCreateRequested);
    on<TrainerUpdateRequested>(_onUpdateRequested);
    on<TrainerBlockRequested>(_onBlockRequested);
    on<TrainersReload>(_onReload);
    on<TrainerDetailRequested>(_onDetailRequested);
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  // ── TrainersStarted ────────────────────────────────────────────────────────
  Future<void> _onStarted(
      TrainersStarted event, Emitter<AdminTrainersState> emit) async {
    emit(TrainersLoading());
    try {
      final trainers = await _getTrainers();
      emit(TrainersLoaded(trainers: trainers, total: trainers.length));
    } catch (e) {
      emit(TrainersError(_msg(e)));
    }
  }

  // ── TrainersSearchChanged (debounced 300ms) ────────────────────────────────
  Future<void> _onSearchChanged(
      TrainersSearchChanged event, Emitter<AdminTrainersState> emit) async {
    _searchDebounce?.cancel();
    _activeSearch = event.query.isEmpty ? null : event.query;

    final completer = Completer<void>();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () async {
      emit(TrainersLoading());
      try {
        final trainers = await _getTrainers(
            search: _activeSearch, specialtyFilter: _activeSpecialty);
        emit(TrainersLoaded(
          trainers:        trainers,
          total:           trainers.length,
          activeSearch:    _activeSearch,
          activeSpecialty: _activeSpecialty,
        ));
      } catch (e) {
        emit(TrainersError(_msg(e)));
      }
      completer.complete();
    });
    await completer.future;
  }

  // ── TrainersSpecialtyFilterChanged ─────────────────────────────────────────
  Future<void> _onSpecialtyChanged(
      TrainersSpecialtyFilterChanged event,
      Emitter<AdminTrainersState> emit) async {
    _activeSpecialty = event.specialty;
    emit(TrainersLoading());
    try {
      final trainers = await _getTrainers(
          search: _activeSearch, specialtyFilter: _activeSpecialty);
      emit(TrainersLoaded(
        trainers:        trainers,
        total:           trainers.length,
        activeSearch:    _activeSearch,
        activeSpecialty: _activeSpecialty,
      ));
    } catch (e) {
      emit(TrainersError(_msg(e)));
    }
  }

  // ── TrainerFormOptionsRequested ────────────────────────────────────────────
  Future<void> _onFormOptionsRequested(
      TrainerFormOptionsRequested event,
      Emitter<AdminTrainersState> emit) async {
    emit(TrainerFormOptionsLoading());
    try {
      final options = await _getFormOptions();
      emit(TrainerFormOptionsLoaded(options));
    } catch (e) {
      emit(TrainersError(_msg(e)));
    }
  }

  // ── TrainerCreateRequested ─────────────────────────────────────────────────
  Future<void> _onCreateRequested(
      TrainerCreateRequested event,
      Emitter<AdminTrainersState> emit) async {
    emit(const TrainerActionLoading(0)); // 0 = new, no card ID
    try {
      final newId = await _createTrainer(event.request);
      emit(TrainerActionSuccess(newId, 'created'));
      add(const TrainersReload());
    } catch (e) {
      emit(TrainerActionError(0, _msg(e)));
    }
  }

  // ── TrainerUpdateRequested ─────────────────────────────────────────────────
  Future<void> _onUpdateRequested(
      TrainerUpdateRequested event,
      Emitter<AdminTrainersState> emit) async {
    emit(TrainerActionLoading(event.trainerId));
    try {
      await _updateTrainer(event.trainerId, event.request);
      emit(TrainerActionSuccess(event.trainerId, 'updated'));
      add(const TrainersReload());
    } catch (e) {
      emit(TrainerActionError(event.trainerId, _msg(e)));
    }
  }

  // ── TrainerBlockRequested ──────────────────────────────────────────────────
  Future<void> _onBlockRequested(
      TrainerBlockRequested event,
      Emitter<AdminTrainersState> emit) async {
    emit(TrainerActionLoading(event.trainerId));
    try {
      final newStatus = await _blockTrainer(event.trainerId);
      final action = newStatus == 'BLOCKED' ? 'blocked' : 'unblocked';
      emit(TrainerActionSuccess(event.trainerId, action));
      add(const TrainersReload());
    } catch (e) {
      emit(TrainerActionError(event.trainerId, _msg(e)));
    }
  }

  // ── _TrainersReload ────────────────────────────────────────────────────────
  Future<void> _onReload(
      TrainersReload event, Emitter<AdminTrainersState> emit) async {
    try {
      final trainers = await _getTrainers(
          search: _activeSearch, specialtyFilter: _activeSpecialty);
      emit(TrainersLoaded(
        trainers:        trainers,
        total:           trainers.length,
        activeSearch:    _activeSearch,
        activeSpecialty: _activeSpecialty,
      ));
    } catch (e) {
      emit(TrainersError(_msg(e)));
    }
  }

  Future<void> _onDetailRequested(
      TrainerDetailRequested event,
      Emitter<AdminTrainersState> emit) async {
    emit(TrainerDetailLoading());  // ← loading state first
    try {
      final detail = await _getTrainerDetail(event.trainerId);
      emit(TrainerDetailLoaded(detail));
    } catch (e) {
      emit(TrainerDetailError(_msg(e)));
    }
  }

  String _msg(Object e) => e.toString().replaceFirst('Exception: ', '');
}