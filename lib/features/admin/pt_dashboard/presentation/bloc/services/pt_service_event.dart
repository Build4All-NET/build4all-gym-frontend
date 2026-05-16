// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/bloc/pt_service_event.dart
// =============================================================================

part of 'pt_service_bloc.dart';

abstract class PtServiceEvent extends Equatable {
  const PtServiceEvent();

  @override
  List<Object?> get props => [];
}

/// [trainerId] = null → admin mode (all trainers' services).
class PtServicesLoadRequested extends PtServiceEvent {
  final int? trainerId;
  final int tenantId;

  const PtServicesLoadRequested({
    this.trainerId,
    required this.tenantId,
  });

  @override
  List<Object?> get props => [trainerId, tenantId];
}

/// Admin/owner assigns the new service to [trainerId].
class PtServiceCreateRequested extends PtServiceEvent {
  final int trainerId;
  final int tenantId;
  final Map<String, dynamic> body;

  const PtServiceCreateRequested({
    required this.trainerId,
    required this.tenantId,
    required this.body,
  });

  @override
  List<Object?> get props => [trainerId, tenantId, body];
}

class PtServiceUpdateRequested extends PtServiceEvent {
  final int serviceId;
  final Map<String, dynamic> body;

  const PtServiceUpdateRequested({
    required this.serviceId,
    required this.body,
  });

  @override
  List<Object?> get props => [serviceId, body];
}

class PtServiceDeleteRequested extends PtServiceEvent {
  final int serviceId;

  const PtServiceDeleteRequested(this.serviceId);

  @override
  List<Object?> get props => [serviceId];
}