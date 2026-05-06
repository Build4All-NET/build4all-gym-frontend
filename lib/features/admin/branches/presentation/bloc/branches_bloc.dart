// ─────────────────────────────────────────────────────────────────────────────
// FILE: branches_bloc.dart
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entity/branch_entity.dart';
import '../../domain/entity/branch_detail_entity.dart';
import '../../domain/entity/branch_stats_entity.dart';
import '../../domain/usecase/get_branches_usecase.dart';
import '../../domain/usecase/get_branch_detail_usecase.dart';
import '../../domain/usecase/create_branch_usecase.dart';
import 'branches_event.dart';
import 'branches_state.dart';

class BranchesBloc extends Bloc<BranchesEvent, BranchesState> {
  final GetBranchesUseCase     getBranchesUseCase;
  final GetBranchDetailUseCase getBranchDetailUseCase;
  final CreateBranchUseCase    createBranchUseCase;

  // CRITICAL: all use cases must be passed at construction with their repositories
  BranchesBloc({
    required this.getBranchesUseCase,
    required this.getBranchDetailUseCase,
    required this.createBranchUseCase,
  }) : super(const BranchesInitial()) {
    on<LoadBranches>(_onLoadBranches);
    on<FilterBranchesByStatus>(_onFilterByStatus);
    on<SearchBranches>(_onSearch);
    on<LoadBranchDetail>(_onLoadBranchDetail);
    on<SubmitCreateBranch>(_onCreateBranch);
  }

  // ── Keep last-known filter/search to pass through on reload ─────────────────
  String? _currentStatus;
  String? _currentSearch;

  Future<void> _onLoadBranches(
      LoadBranches event, Emitter<BranchesState> emit) async {
    emit(const BranchesLoading());
    final result = await getBranchesUseCase(
        status: _currentStatus, search: _currentSearch);
    result.fold(
          (failure) => emit(BranchesError(failure.message)),
          (data) => emit(BranchesLoaded(
        stats: data.stats,
        branches: data.branches,
        activeStatus: _currentStatus,
        activeSearch: _currentSearch,
      )),
    );
  }

  Future<void> _onFilterByStatus(
      FilterBranchesByStatus event, Emitter<BranchesState> emit) async {
    _currentStatus = event.status;
    add(const LoadBranches());
  }

  Future<void> _onSearch(
      SearchBranches event, Emitter<BranchesState> emit) async {
    _currentSearch = event.query.isEmpty ? null : event.query;
    add(const LoadBranches());
  }

  Future<void> _onLoadBranchDetail(
      LoadBranchDetail event, Emitter<BranchesState> emit) async {
    emit(const BranchDetailLoading());
    final result = await getBranchDetailUseCase(event.branchId);
    result.fold(
          (failure) => emit(BranchDetailError(failure.message)),
          (detail)  => emit(BranchDetailLoaded(detail)),
    );
  }

  Future<void> _onCreateBranch(
      SubmitCreateBranch event, Emitter<BranchesState> emit) async {
    emit(const BranchCreating());
    final result = await createBranchUseCase(event.params);
    result.fold(
          (failure) => emit(BranchCreateError(failure.message)),
          (branch)  => emit(BranchCreated(branch)),
    );
  }
}