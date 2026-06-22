/// The branch's static, non-expiring check-in QR — printed/displayed as a
/// poster at the entrance for trainers/reception to scan and self check-in.
class BranchCheckinQrEntity {
  final int branchId;
  final String token;

  const BranchCheckinQrEntity({required this.branchId, required this.token});
}
