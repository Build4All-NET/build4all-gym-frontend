// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/bloc/pt_package_event.dart
//
// EVENT DEFINITIONS FOR PACKAGE MANAGEMENT
// =============================================================================

import 'package:equatable/equatable.dart';

abstract class PtPackageEvent extends Equatable {
  const PtPackageEvent();

  @override
  List<Object?> get props => [];
}

/// Fetch packages (optional trainerId filters to specific trainer)
class FetchPackagesRequested extends PtPackageEvent {
  final int branchId;
  final int? trainerId; // null = admin sees all, int = specific trainer

  const FetchPackagesRequested({
    required this.branchId,
    this.trainerId,
  });

  @override
  List<Object?> get props => [branchId, trainerId];
}

/// Create new package
class CreatePackageRequested extends PtPackageEvent {
  final int branchId;
  final int trainerId;
  final String name;
  final String? description;
  final double price;
  final int sessions;

  const CreatePackageRequested({
    required this.branchId,
    required this.trainerId,
    required this.name,
    this.description,
    required this.price,
    required this.sessions,
  });

  @override
  List<Object?> get props => [
    branchId,
    trainerId,
    name,
    description,
    price,
    sessions,
  ];
}

/// Update existing package
class UpdatePackageRequested extends PtPackageEvent {
  final String packageId;
  final String name;
  final String? description;
  final double price;
  final int sessions;

  const UpdatePackageRequested({
    required this.packageId,
    required this.name,
    this.description,
    required this.price,
    required this.sessions,
  });

  @override
  List<Object?> get props => [
    packageId,
    name,
    description,
    price,
    sessions,
  ];
}

/// Delete package
class DeletePackageRequested extends PtPackageEvent {
  final String packageId;

  const DeletePackageRequested({required this.packageId});

  @override
  List<Object?> get props => [packageId];
}