part of 'member_pt_bloc.dart';

abstract class MemberPtState {
  const MemberPtState();
}

// Default before any load.
class TrainersInitial extends MemberPtState {
  const TrainersInitial();
}

// Emitted while initial load or filter change is in flight — shows shimmer skeleton.
class TrainersLoading extends MemberPtState {
  const TrainersLoading();
}

// Drives entire screen.
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

// Emitted on network or 404 no active membership error.
class TrainersError extends MemberPtState {
  final String message;
  const TrainersError(this.message);
}

// Emitted while toggle POST is in flight.
// Screen keeps showing current TrainersLoaded list but replaces
// heart icon of matching trainerId with CircularProgressIndicator.
class TrainerFavoriteToggleLoading extends MemberPtState {
  final int trainerId;
  const TrainerFavoriteToggleLoading(this.trainerId);
}

// Emitted on toggle failure — shows red snackbar, heart reverts to original state.
class TrainerFavoriteToggleError extends MemberPtState {
  final int trainerId;
  final String message;
  const TrainerFavoriteToggleError(this.trainerId, this.message);
}