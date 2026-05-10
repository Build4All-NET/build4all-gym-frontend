import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/pt_package_service.dart';
import '../../data/models/pt_package_model.dart';

// ── Events ──────────────────────────────────────────────────────────────────

abstract class PtPackageEvent {}

class LoadPackages extends PtPackageEvent {
  final int trainerId;
  final int tenantId;
  final int branchId;
  LoadPackages({required this.trainerId, required this.tenantId, required this.branchId});
}

class CreatePackage extends PtPackageEvent {
  final int trainerId;
  final int tenantId;
  final int branchId;
  final Map<String, dynamic> data;
  CreatePackage({required this.trainerId, required this.tenantId, required this.branchId, required this.data});
}

class UpdatePackage extends PtPackageEvent {
  final int id;
  final Map<String, dynamic> data;
  UpdatePackage({required this.id, required this.data});
}

class DeactivatePackage extends PtPackageEvent {
  final int id;
  DeactivatePackage(this.id);
}

// ── States ───────────────────────────────────────────────────────────────────

abstract class PtPackageState {}
class PtPackageInitial extends PtPackageState {}
class PtPackageLoading extends PtPackageState {}
class PtPackageLoaded extends PtPackageState {
  final List<PtPackageModel> packages;
  PtPackageLoaded(this.packages);
}
class PtPackageError extends PtPackageState {
  final String message;
  PtPackageError(this.message);
}
class PtPackageMutating extends PtPackageState {}   // shows spinner on button
class PtPackageMutated extends PtPackageState {}    // triggers reload + snackbar

// ── BLoC ─────────────────────────────────────────────────────────────────────

class PtPackageBloc extends Bloc<PtPackageEvent, PtPackageState> {
  final PtPackageService _service;

  PtPackageBloc(this._service) : super(PtPackageInitial()) {
    on<LoadPackages>(_onLoad);
    on<CreatePackage>(_onCreate);
    on<UpdatePackage>(_onUpdate);
    on<DeactivatePackage>(_onDeactivate);
  }

  Future<void> _onLoad(LoadPackages e, Emitter<PtPackageState> emit) async {
    emit(PtPackageLoading());
    try {
      final packages = await _service.getPackages(
          trainerId: e.trainerId, tenantId: e.tenantId, branchId: e.branchId);
      emit(PtPackageLoaded(packages));
    } catch (err) {
      emit(PtPackageError(err.toString()));
    }
  }

  Future<void> _onCreate(CreatePackage e, Emitter<PtPackageState> emit) async {
    emit(PtPackageMutating());
    try {
      await _service.createPackage(
          trainerId: e.trainerId, tenantId: e.tenantId, branchId: e.branchId, body: e.data);
      emit(PtPackageMutated());
    } catch (err) {
      emit(PtPackageError(err.toString()));
    }
  }

  Future<void> _onUpdate(UpdatePackage e, Emitter<PtPackageState> emit) async {
    emit(PtPackageMutating());
    try {
      await _service.updatePackage(e.id, e.data);
      emit(PtPackageMutated());
    } catch (err) {
      emit(PtPackageError(err.toString()));
    }
  }

  Future<void> _onDeactivate(DeactivatePackage e, Emitter<PtPackageState> emit) async {
    emit(PtPackageMutating());
    try {
      await _service.deactivatePackage(e.id);
      emit(PtPackageMutated());
    } catch (err) {
      emit(PtPackageError(err.toString()));
    }
  }
}