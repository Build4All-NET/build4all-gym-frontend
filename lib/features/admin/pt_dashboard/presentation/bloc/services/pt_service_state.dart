// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/bloc/pt_service_state.dart
// =============================================================================

part of 'pt_service_bloc.dart';

abstract class PtServiceState extends Equatable {
  const PtServiceState();

  @override
  List<Object?> get props => [];
}

class PtServiceInitial extends PtServiceState {
  const PtServiceInitial();
}

class PtServiceLoading extends PtServiceState {
  const PtServiceLoading();
}

class PtServiceLoaded extends PtServiceState {
  final List<PtServiceEntity> services;

  const PtServiceLoaded(this.services);

  @override
  List<Object?> get props => [services];
}

class PtServiceMutating extends PtServiceState {
  const PtServiceMutating();
}

class PtServiceMutationSuccess extends PtServiceState {
  final String message;

  const PtServiceMutationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class PtServiceError extends PtServiceState {
  final String message;

  const PtServiceError(this.message);

  @override
  List<Object?> get props => [message];
}