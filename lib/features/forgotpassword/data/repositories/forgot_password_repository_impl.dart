import '../../domain/entities/forgot_password_entity.dart';
import '../../domain/repositories/forgot_password_repository.dart';
import '../services/forgot_password_api_service.dart';

// The REAL implementation of the repository.
// Calls the API service and converts API models → domain entities.
class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  final ForgotPasswordApiService api;

  ForgotPasswordRepositoryImpl({required this.api});

  @override
  Future<InitiateResult> initiateForgotPassword(String identifier) async {
    // Call API → get ForgotPasswordData → convert to InitiateResult
    final data = await api.initiateForgotPassword(identifier);
    return InitiateResult(
      maskedContact: data.maskedContact,
      deliveryMethod: data.deliveryMethod,
    );
  }

  @override
  Future<VerifyOtpResult> verifyOtp(String identifier, String otpCode) async {
    // Call API → get VerifyOtpData → convert to VerifyOtpResult
    final data = await api.verifyOtp(identifier, otpCode);
    return VerifyOtpResult(resetToken: data.resetToken);
  }

  @override
  Future<ForgotPasswordResult> resetPassword(
      String resetToken, String newPassword) async {
    // Call API → get success message string → convert to ForgotPasswordResult
    final message = await api.resetPassword(resetToken, newPassword);
    return ForgotPasswordResult(message: message);
  }
}