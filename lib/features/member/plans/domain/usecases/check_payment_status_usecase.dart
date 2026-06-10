import '../repositories/member_plans_repository.dart';

class CheckPaymentStatusUseCase {
  final MemberPlansRepository repository;
  CheckPaymentStatusUseCase({required this.repository});

  Future<Map<String, String>> call({required int membershipId}) =>
      repository.checkPaymentStatus(membershipId: membershipId);
}