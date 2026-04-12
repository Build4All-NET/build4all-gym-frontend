import 'package:build4allgym/features/forgotpassword/domain/entities/forgot_password_entity.dart';
import 'package:build4allgym/features/forgotpassword/domain/repositories/forgot_password_repository.dart';
import '../services/forgot_password_api_service.dart';

class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  final ForgotPasswordApiService api;

  ForgotPasswordRepositoryImpl({required this.api});

  @override
  Future<InitiateResult> initiateForgotPassword(String identifier) async {
    //Calls api.initiateForgotPassword() → gets ForgotPasswordData → converts to InitiateResult entity.
    final data = await api.initiateForgotPassword(identifier);
    return InitiateResult(
      maskedContact: data.maskedContact,
      deliveryMethod: data.deliveryMethod,
    );
  }

  @override
  Future<VerifyOtpResult> verifyOtp(String identifier, String otpCode) async {
    //Calls api.verifyOtp() → gets VerifyOtpData → converts to VerifyOtpResult entity.
    final data = await api.verifyOtp(identifier, otpCode);
    return VerifyOtpResult(resetToken: data.resetToken);
  }

  @override
  Future<ForgotPasswordResult> resetPassword(
      String resetToken, String newPassword) async {
    //Calls api.resetPassword() → gets message string → wraps in ForgotPasswordResult entity.
    final message = await api.resetPassword(resetToken, newPassword);
    return ForgotPasswordResult(message: message);
  }
}