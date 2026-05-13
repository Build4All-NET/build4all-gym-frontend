// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/bloc/pt_package_state.dart
//
// STATE DEFINITIONS FOR PACKAGE MANAGEMENT
// =============================================================================



import 'package:equatable/equatable.dart';

import '../../../../member/pt/domain/entities/pt_package_entity.dart';


abstract class PtPackageState extends Equatable {
  const PtPackageState();

  @override
  List<Object?> get props => [];
}

class PtPackageInitial extends PtPackageState {
  const PtPackageInitial();
}

class PtPackageLoading extends PtPackageState {
  const PtPackageLoading();
}

class PtPackageLoaded extends PtPackageState {
  final List<PtPackageEntity> packages;

  const PtPackageLoaded({required this.packages});

  @override
  List<Object?> get props => [packages];
}

class PtPackageError extends PtPackageState {
  final String message;

  const PtPackageError({required this.message});

  @override
  List<Object?> get props => [message];
}

class PtPackageActionSuccess extends PtPackageState {
  final String actionType; // 'created', 'updated', 'deleted'
  final String message;

  const PtPackageActionSuccess({
    required this.actionType,
    required this.message,
  });

  @override
  List<Object?> get props => [actionType, message];
}

class PtPackageActionError extends PtPackageState {
  final String message;

  const PtPackageActionError({required this.message});

  @override
  List<Object?> get props => [message];
}