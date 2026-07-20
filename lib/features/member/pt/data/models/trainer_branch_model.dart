import 'package:build4allgym/features/member/pt/domain/entities/trainer_branch_entity.dart';

class TrainerBranchModel {
  final int branchId;
  final String branchName;

  const TrainerBranchModel({
    required this.branchId,
    required this.branchName,
  });

  factory TrainerBranchModel.fromJson(Map<String, dynamic> json) {
    return TrainerBranchModel(
      branchId: (json['branchId'] as num?)?.toInt() ?? 0,
      branchName: json['branchName'] as String? ?? '',
    );
  }

  TrainerBranchEntity toEntity() {
    return TrainerBranchEntity(branchId: branchId, branchName: branchName);
  }
}
