import '../../domain/entities/admin_branch_option_entity.dart';

class AdminBranchOptionModel {
  final int    branchId;
  final String branchName;

  const AdminBranchOptionModel({
    required this.branchId,
    required this.branchName,
  });

  factory AdminBranchOptionModel.fromJson(Map<String, dynamic> json) {
    return AdminBranchOptionModel(
      branchId:   (json['branchId'] as num).toInt(),
      branchName: json['branchName'] as String,
    );
  }

  AdminBranchOptionEntity toEntity() => AdminBranchOptionEntity(
    branchId:   branchId,
    branchName: branchName,
  );
}
