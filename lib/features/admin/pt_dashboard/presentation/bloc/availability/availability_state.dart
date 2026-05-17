// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/bloc/availability_state.dart
// =============================================================================

part of 'availability_bloc.dart';

abstract class AvailabilityState extends Equatable {
  const AvailabilityState();

  @override
  List<Object?> get props => [];
}

class AvailabilityInitial extends AvailabilityState {
  const AvailabilityInitial();
}

class AvailabilityLoading extends AvailabilityState {
  const AvailabilityLoading();
}

class AvailabilityLoaded extends AvailabilityState {
  final List<AvailabilityEntity> slots;

  const AvailabilityLoaded(this.slots);

  @override
  List<Object?> get props => [slots];
}

class AvailabilityMutating extends AvailabilityState {
  const AvailabilityMutating();
}

class AvailabilityMutationSuccess extends AvailabilityState {
  final String message;

  const AvailabilityMutationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AvailabilityError extends AvailabilityState {
  final String message;

  const AvailabilityError(this.message);

  @override
  List<Object?> get props => [message];
}