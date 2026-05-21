part of 'member_pt_bloc.dart';

abstract class MemberPtEvent {
  const MemberPtEvent();
}

// Dispatched on screen init.
// Triggers both getFilterOptions and getTrainers in parallel.
class TrainersStarted extends MemberPtEvent {
  const TrainersStarted();
}

// Dispatched when All chip is tapped.
// Clears specialty, branch, and favorites filters.
class TrainersAllFiltersCleared extends MemberPtEvent {
  const TrainersAllFiltersCleared();
}

// Dispatched when a specialty chip is tapped.
// null means "All specialties".
class TrainersSpecialtyFilterChanged extends MemberPtEvent {
  final String? specialty;

  const TrainersSpecialtyFilterChanged(this.specialty);
}

// Dispatched when a branch chip is tapped.
// null means "All branches".
class TrainersBranchFilterChanged extends MemberPtEvent {
  final int? branchId;

  const TrainersBranchFilterChanged(this.branchId);
}

// Dispatched when favorites chip is tapped.
// Toggles favoritesOnly.
class TrainersFavoritesFilterToggled extends MemberPtEvent {
  const TrainersFavoritesFilterToggled();
}

// Dispatched when the heart icon on a trainer card is tapped.
class TrainerFavoriteToggleRequested extends MemberPtEvent {
  final int trainerId;

  const TrainerFavoriteToggleRequested(this.trainerId);
}

// Dispatched when opening the trainer detail screen.
class TrainerDetailRequested extends MemberPtEvent {
  final int trainerId;

  const TrainerDetailRequested(this.trainerId);
}