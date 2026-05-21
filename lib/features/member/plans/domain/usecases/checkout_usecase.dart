import '../entities/checkout_result_entity.dart';
import '../repositories/member_plans_repository.dart';

class CheckoutUseCase {
  final MemberPlansRepository repository;

  CheckoutUseCase({required this.repository});

  Future<CheckoutResultEntity> call({
    required int planId,
    required String paymentMethod,
    String? couponCode,
  }) =>
      repository.checkout(
        planId: planId,
        paymentMethod: paymentMethod,
        couponCode: couponCode,
      );
}
