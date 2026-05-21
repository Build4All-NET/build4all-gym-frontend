import '../entities/payment_method_entity.dart';
import '../repositories/member_plans_repository.dart';

class GetPaymentMethodsUseCase {
  final MemberPlansRepository repository;

  GetPaymentMethodsUseCase({required this.repository});

  Future<List<PaymentMethodEntity>> call() => repository.getPaymentMethods();
}
