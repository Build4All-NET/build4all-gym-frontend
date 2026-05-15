import 'package:equatable/equatable.dart';
// REPLACE with:
import 'package:build4allgym/features/admin/pt_dashboard/domain/entities/pt_package_entity.dart';

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

class PtPackageMutating extends PtPackageState {
  const PtPackageMutating();
}

class PtPackageLoaded extends PtPackageState {
  final List<PtPackageEntity> packages;

  const PtPackageLoaded(this.packages);

  @override
  List<Object?> get props => [packages];
}

class PtPackageMutationSuccess extends PtPackageState {
  final String message;

  const PtPackageMutationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class PtPackageError extends PtPackageState {
  final String message;

  const PtPackageError(this.message);

  @override
  List<Object?> get props => [message];
}