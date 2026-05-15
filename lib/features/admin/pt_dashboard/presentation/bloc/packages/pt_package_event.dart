// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/bloc/pt_package_event.dart
// =============================================================================

part of 'pt_package_bloc.dart';

abstract class PtPackageEvent extends Equatable {
  const PtPackageEvent();

  @override
  List<Object?> get props => [];
}

/// Load packages.
/// [trainerId] = null → admin mode (all trainers).
/// [trainerId] = id   → trainer mode (own packages only).
class PtPackagesLoadRequested extends PtPackageEvent {
  final int? trainerId;
  final int tenantId;
  final int branchId;

  const PtPackagesLoadRequested({
    this.trainerId,
    required this.tenantId,
    required this.branchId,
  });

  @override
  List<Object?> get props => [trainerId, tenantId, branchId];
}

/// Admin/owner creates a package and assigns it to [trainerId].
class PtPackageCreateRequested extends PtPackageEvent {
  final int trainerId;
  final int tenantId;
  final int branchId;
  final Map<String, dynamic> body;

  const PtPackageCreateRequested({
    required this.trainerId,
    required this.tenantId,
    required this.branchId,
    required this.body,
  });

  @override
  List<Object?> get props => [trainerId, tenantId, branchId, body];
}

/// Update an existing package.
class PtPackageUpdateRequested extends PtPackageEvent {
  final int packageId;
  final Map<String, dynamic> body;

  const PtPackageUpdateRequested({
    required this.packageId,
    required this.body,
  });

  @override
  List<Object?> get props => [packageId, body];
}

/// Soft-delete (deactivate) a package.
class PtPackageDeactivateRequested extends PtPackageEvent {
  final int packageId;

  const PtPackageDeactivateRequested(this.packageId);

  @override
  List<Object?> get props => [packageId];
}