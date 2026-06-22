import '../../domain/entities/branch_checkin_qr_entity.dart';

class BranchCheckinQrModel {
  final int branchId;
  final String token;

  const BranchCheckinQrModel({required this.branchId, required this.token});

  factory BranchCheckinQrModel.fromJson(Map<String, dynamic> json) {
    return BranchCheckinQrModel(
      branchId: (json['branchId'] as num).toInt(),
      token: json['token'] as String,
    );
  }

  BranchCheckinQrEntity toEntity() => BranchCheckinQrEntity(branchId: branchId, token: token);
}
