import '../repositories/member_plans_repository.dart';

class ConfirmStripePaymentUseCase {
  final MemberPlansRepository repository;
  ConfirmStripePaymentUseCase({required this.repository});

  Future<Map<String, String>> call({
    required int transactionId,
    required int invoiceId,
  }) =>
      repository.confirmStripePayment(
          transactionId: transactionId, invoiceId: invoiceId);
}