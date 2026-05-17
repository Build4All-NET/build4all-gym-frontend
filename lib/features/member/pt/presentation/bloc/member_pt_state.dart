part of 'member_pt_bloc.dart';

abstract class MemberPtState {
  const MemberPtState();
}

// Default before any load.
class TrainersInitial extends MemberPtState {
  const TrainersInitial();
}

// Emitted while initial load or filter change is in flight.
// Shows shimmer skeleton.
class TrainersLoading extends MemberPtState {
  const TrainersLoading();
}

// Drives entire PT trainers screen.
class TrainersLoaded extends MemberPtState {
  final List<TrainerCardEntity> trainers;
  final int favoriteCount;
  final List<String> specialties;
  final String? activeSpecialtyFilter;
  final bool favoritesOnly;

  const TrainersLoaded({
    required this.trainers,
    required this.favoriteCount,
    required this.specialties,
    this.activeSpecialtyFilter,
    required this.favoritesOnly,
  });

  TrainersLoaded copyWith({
    List<TrainerCardEntity>? trainers,
    int? favoriteCount,
    List<String>? specialties,
    String? activeSpecialtyFilter,
    bool? favoritesOnly,
  }) {
    return TrainersLoaded(
      trainers: trainers ?? this.trainers,
      favoriteCount: favoriteCount ?? this.favoriteCount,
      specialties: specialties ?? this.specialties,
      activeSpecialtyFilter: activeSpecialtyFilter ?? this.activeSpecialtyFilter,
      favoritesOnly: favoritesOnly ?? this.favoritesOnly,
    );
  }
}

// Emitted on network error, server error, or no active membership.
class TrainersError extends MemberPtState {
  final String message;

  const TrainersError(this.message);
}

// Emitted while toggle favorite request is in flight.
// The screen keeps showing current TrainersLoaded list but can replace
// the matching trainer heart with CircularProgressIndicator.
class TrainerFavoriteToggleLoading extends MemberPtState {
  final int trainerId;

  const TrainerFavoriteToggleLoading(this.trainerId);
}

// Emitted on toggle failure.
// UI can show red snackbar and revert heart state.
class TrainerFavoriteToggleError extends MemberPtState {
  final int trainerId;
  final String message;

  const TrainerFavoriteToggleError(this.trainerId, this.message);
}

// Emitted while trainer detail is loading.
class TrainerDetailLoading extends MemberPtState {
  const TrainerDetailLoading();
}

// Emitted when trainer detail is loaded successfully.
class TrainerDetailLoaded extends MemberPtState {
  final TrainerDetailEntity trainer;

  const TrainerDetailLoaded(this.trainer);
}

// Emitted when trainer detail fails.
class TrainerDetailError extends MemberPtState {
  final String message;

  const TrainerDetailError(this.message);
}