import 'package:build4allgym/features/admin/pt_dashboard/presentation/bloc/packages/pt_package_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// REPLACE with:
import 'package:build4allgym/features/admin/pt_dashboard/domain/entities/pt_package_entity.dart';
import '../../../domain/usecases/pt_package_usecases.dart';

part 'pt_package_event.dart';


class PtPackageBloc extends Bloc<PtPackageEvent, PtPackageState> {
  final GetPtPackagesUseCase _getPackages;
  final GetInactivePtPackagesUseCase _getInactivePackages;
  final CreatePtPackageUseCase _createPackage;
  final UpdatePtPackageUseCase _updatePackage;
  final DeactivatePtPackageUseCase _deactivatePackage;

  int? _lastTrainerId;
  int _lastTenantId = 0;
  int _lastBranchId = 0;
  bool _inactiveLoaded = false;

  PtPackageBloc({
    required GetPtPackagesUseCase getPackages,
    required GetInactivePtPackagesUseCase getInactivePackages,
    required CreatePtPackageUseCase createPackage,
    required UpdatePtPackageUseCase updatePackage,
    required DeactivatePtPackageUseCase deactivatePackage,
  })  : _getPackages = getPackages,
        _getInactivePackages = getInactivePackages,
        _createPackage = createPackage,
        _updatePackage = updatePackage,
        _deactivatePackage = deactivatePackage,
        super(const PtPackageInitial()) {
    on<PtPackagesLoadRequested>(_onLoad);
    on<PtInactivePackagesLoadRequested>(_onLoadInactive);
    on<PtPackageCreateRequested>(_onCreate);
    on<PtPackageUpdateRequested>(_onUpdate);
    on<PtPackageDeactivateRequested>(_onDeactivate);
  }

  Future<void> _onLoad(
      PtPackagesLoadRequested event,
      Emitter<PtPackageState> emit,
      ) async {
    _lastTrainerId = event.trainerId;
    _lastTenantId = event.tenantId;
    _lastBranchId = event.branchId;

    final prevInactive = state is PtPackageLoaded
        ? (state as PtPackageLoaded).inactivePackages
        : <PtPackageEntity>[];

    emit(const PtPackageLoading());

    final result = await _getPackages(
      trainerId: event.trainerId,
      tenantId: event.tenantId,
      branchId: event.branchId,
    );

    if (result.failure != null) {
      emit(PtPackageError(result.failure!.message));
      return;
    }

    emit(PtPackageLoaded(
      List<PtPackageEntity>.from(result.data ?? []),
      inactivePackages: prevInactive,
    ));
  }

  Future<void> _onLoadInactive(
      PtInactivePackagesLoadRequested event,
      Emitter<PtPackageState> emit,
      ) async {
    _lastTrainerId = event.trainerId;
    _lastTenantId = event.tenantId;
    _lastBranchId = event.branchId;
    _inactiveLoaded = true;

    final prevActive = state is PtPackageLoaded
        ? (state as PtPackageLoaded).packages
        : <PtPackageEntity>[];

    final result = await _getInactivePackages(
      trainerId: event.trainerId,
      tenantId: event.tenantId,
      branchId: event.branchId,
    );

    if (result.failure != null) {
      emit(PtPackageError(result.failure!.message));
      return;
    }

    emit(PtPackageLoaded(
      prevActive,
      inactivePackages: List<PtPackageEntity>.from(result.data ?? []),
    ));
  }

  Future<void> _onCreate(
      PtPackageCreateRequested event,
      Emitter<PtPackageState> emit,
      ) async {
    emit(const PtPackageMutating());

    final result = await _createPackage(
      trainerId: event.trainerId,
      tenantId: event.tenantId,
      branchId: event.branchId,
      body: event.body,
    );

    if (result.failure != null) {
      emit(PtPackageError(result.failure!.message));
      return;
    }

    emit(
      const PtPackageMutationSuccess(
        'Package created successfully',
      ),
    );

    _reload();
  }

  Future<void> _onUpdate(
      PtPackageUpdateRequested event,
      Emitter<PtPackageState> emit,
      ) async {
    emit(const PtPackageMutating());

    final result = await _updatePackage(
      event.packageId,
      event.body,
    );

    if (result.failure != null) {
      emit(PtPackageError(result.failure!.message));
      return;
    }

    emit(
      const PtPackageMutationSuccess(
        'Package updated successfully',
      ),
    );

    _reload();
  }

  Future<void> _onDeactivate(
      PtPackageDeactivateRequested event,
      Emitter<PtPackageState> emit,
      ) async {
    emit(const PtPackageMutating());

    final result = await _deactivatePackage(
      event.packageId,
    );

    if (result.failure != null) {
      emit(PtPackageError(result.failure!.message));
      return;
    }

    emit(
      const PtPackageMutationSuccess(
        'Package deactivated successfully',
      ),
    );

    _reload();
  }

  void _reload() {
    if (_lastTenantId == 0 || _lastBranchId == 0) return;

    add(PtPackagesLoadRequested(
      trainerId: _lastTrainerId,
      tenantId:  _lastTenantId,
      branchId:  _lastBranchId,
    ));

    if (_inactiveLoaded) {
      add(PtInactivePackagesLoadRequested(
        trainerId: _lastTrainerId,
        tenantId:  _lastTenantId,
        branchId:  _lastBranchId,
      ));
    }
  }
}