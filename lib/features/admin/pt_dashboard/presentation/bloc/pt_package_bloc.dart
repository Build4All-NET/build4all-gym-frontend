// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/bloc/pt_package_bloc.dart
//
// FIX SUMMARY:
//   1. Uses proper events/states with Equatable
//   2. Supports null trainerId for admin all-trainers mode
//   3. Proper error handling
// =============================================================================

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/services/pt_package_service.dart';
import '../../data/models/pt_package_model.dart';

// ── Events ──────────────────────────────────────────────────────────────────

abstract class PtPackageEvent extends Equatable {
  const PtPackageEvent();
  @override
  List<Object?> get props => [];
}

class LoadPackages extends PtPackageEvent {
  final int? trainerId; // null = all trainers (admin/owner)
  final int tenantId;
  final int branchId;
  const LoadPackages({this.trainerId, required this.tenantId, required this.branchId});

  @override
  List<Object?> get props => [trainerId, tenantId, branchId];
}

class CreatePackage extends PtPackageEvent {
  final int trainerId;
  final int tenantId;
  final int branchId;
  final Map<String, dynamic> data;
  const CreatePackage({required this.trainerId, required this.tenantId, required this.branchId, required this.data});

  @override
  List<Object?> get props => [trainerId, tenantId, branchId, data];
}

class UpdatePackage extends PtPackageEvent {
  final int id;
  final Map<String, dynamic> data;
  const UpdatePackage({required this.id, required this.data});

  @override
  List<Object?> get props => [id, data];
}

class DeactivatePackage extends PtPackageEvent {
  final int id;
  const DeactivatePackage(this.id);

  @override
  List<Object?> get props => [id];
}

// ── States ───────────────────────────────────────────────────────────────────

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
  final List<PtPackageModel> packages;
  const PtPackageLoaded(this.packages);

  @override
  List<Object?> get props => [packages];
}

class PtPackageError extends PtPackageState {
  final String message;
  const PtPackageError(this.message);

  @override
  List<Object?> get props => [message];
}

class PtPackageMutating extends PtPackageState {
  const PtPackageMutating();
}

class PtPackageMutated extends PtPackageState {
  const PtPackageMutated();
}

// ── BLoC ─────────────────────────────────────────────────────────────────────

class PtPackageBloc extends Bloc<PtPackageEvent, PtPackageState> {
  final PtPackageService _service;

  PtPackageBloc(this._service) : super(const PtPackageInitial()) {
    on<LoadPackages>(_onLoad);
    on<CreatePackage>(_onCreate);
    on<UpdatePackage>(_onUpdate);
    on<DeactivatePackage>(_onDeactivate);
  }

  Future<void> _onLoad(LoadPackages e, Emitter<PtPackageState> emit) async {
    emit(const PtPackageLoading());
    try {
      final packages = await _service.getPackages(
          trainerId: e.trainerId, tenantId: e.tenantId, branchId: e.branchId);
      emit(PtPackageLoaded(packages));
    } catch (err) {
      emit(PtPackageError(err.toString()));
    }
  }

  Future<void> _onCreate(CreatePackage e, Emitter<PtPackageState> emit) async {
    emit(const PtPackageMutating());
    try {
      await _service.createPackage(
          trainerId: e.trainerId, tenantId: e.tenantId, branchId: e.branchId, body: e.data);
      emit(const PtPackageMutated());
    } catch (err) {
      emit(PtPackageError(err.toString()));
    }
  }

  Future<void> _onUpdate(UpdatePackage e, Emitter<PtPackageState> emit) async {
    emit(const PtPackageMutating());
    try {
      await _service.updatePackage(e.id, e.data);
      emit(const PtPackageMutated());
    } catch (err) {
      emit(PtPackageError(err.toString()));
    }
  }

  Future<void> _onDeactivate(DeactivatePackage e, Emitter<PtPackageState> emit) async {
    emit(const PtPackageMutating());
    try {
      await _service.deactivatePackage(e.id);
      emit(const PtPackageMutated());
    } catch (err) {
      emit(PtPackageError(err.toString()));
    }
  }
}