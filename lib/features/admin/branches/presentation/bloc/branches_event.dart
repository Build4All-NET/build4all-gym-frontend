// ─────────────────────────────────────────────────────────────────────────────
// FILE: branches_event.dart
import 'package:equatable/equatable.dart';

import '../../domain/usecase/create_branch_usecase.dart';

abstract class BranchesEvent extends Equatable {
  const BranchesEvent();
  @override
  List<Object?> get props => [];
}

// Load or reload the full list
class LoadBranches extends BranchesEvent {
  const LoadBranches();
}

// Apply status dropdown filter (null = "All Status")
class FilterBranchesByStatus extends BranchesEvent {
  final String? status;
  const FilterBranchesByStatus(this.status);
  @override
  List<Object?> get props => [status];
}

// Text search by name or city
class SearchBranches extends BranchesEvent {
  final String query;
  const SearchBranches(this.query);
  @override
  List<Object?> get props => [query];
}

// Trigger fetch for branch detail
class LoadBranchDetail extends BranchesEvent {
  final String branchId;
  const LoadBranchDetail(this.branchId);
  @override
  List<Object?> get props => [branchId];
}

// Submit the Add Branch form
class SubmitCreateBranch extends BranchesEvent {
  final CreateBranchParams params;
  const SubmitCreateBranch(this.params);
  @override
  List<Object?> get props => [params];
}
