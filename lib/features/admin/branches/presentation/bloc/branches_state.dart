// ─────────────────────────────────────────────────────────────────────────────
// FILE: branches_state.dart

import 'package:equatable/equatable.dart';

import '../../domain/entity/branch_detail_entity.dart';
import '../../domain/entity/branch_entity.dart';
import '../../domain/entity/branch_stats_entity.dart';

abstract class BranchesState extends Equatable {
  const BranchesState();
  @override
  List<Object?> get props => [];
}

class BranchesInitial extends BranchesState {
  const BranchesInitial();
}

class BranchesLoading extends BranchesState {
  const BranchesLoading();
}

class BranchesLoaded extends BranchesState {
  final BranchStatsEntity stats;
  final List<BranchEntity> branches;
  // Keep active filter/search values so the UI can restore them on rebuild
  final String? activeStatus;
  final String? activeSearch;

  const BranchesLoaded({
    required this.stats,
    required this.branches,
    this.activeStatus,
    this.activeSearch,
  });

  @override
  List<Object?> get props => [stats, branches, activeStatus, activeSearch];
}

class BranchesError extends BranchesState {
  final String message;
  const BranchesError(this.message);
  @override
  List<Object?> get props => [message];
}

// ── Detail states ─────────────────────────────────────────────────────────────
class BranchDetailLoading extends BranchesState {
  const BranchDetailLoading();
}

class BranchDetailLoaded extends BranchesState {
  final BranchDetailEntity detail;
  const BranchDetailLoaded(this.detail);
  @override
  List<Object?> get props => [detail];
}

class BranchDetailError extends BranchesState {
  final String message;
  const BranchDetailError(this.message);
  @override
  List<Object?> get props => [message];
}

// ── Create states ─────────────────────────────────────────────────────────────
class BranchCreating extends BranchesState {
  const BranchCreating();
}

class BranchCreated extends BranchesState {
  final BranchEntity branch;
  const BranchCreated(this.branch);
  @override
  List<Object?> get props => [branch];
}

class BranchCreateError extends BranchesState {
  final String message;
  const BranchCreateError(this.message);
  @override
  List<Object?> get props => [message];
}
