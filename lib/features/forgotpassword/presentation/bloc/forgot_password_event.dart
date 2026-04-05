import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();
  @override
  List<Object?> get props => [];
}

//Fired when user taps "Send OTP" on Screen 1 OR "Resend" on Screen 2.
// Carries identifier (email/phone). Same event for both — backend handles resend automatically.
class ForgotSendCodePressed extends ForgotPasswordEvent {
  final String identifier; // email or phone number
  const ForgotSendCodePressed({required this.identifier});
  @override
  List<Object?> get props => [identifier];
}

// Fired when user taps "Verify" on Screen 2. Carries identifier + otpCode (6-digit string).
class ForgotVerifyOtpPressed extends ForgotPasswordEvent {
  final String identifier; // same email/phone from Step 1
  final String otpCode;    // 6-digit code user typed
  const ForgotVerifyOtpPressed({
    required this.identifier,
    required this.otpCode,
  });
  @override
  List<Object?> get props => [identifier, otpCode];
}

// Fired when user taps "Save Password" on Screen 3. Carries resetToken (UUID from Step 2) + newPassword.
class ForgotResetPasswordPressed extends ForgotPasswordEvent {
  final String resetToken;  // UUID stored from Step 2
  final String newPassword; // what the user typed
  const ForgotResetPasswordPressed({
    required this.resetToken,
    required this.newPassword,
  });
  @override
  List<Object?> get props => [resetToken, newPassword];
}

//Fired after navigation to reset the BLoC state. Prevents listeners from firing twice when user presses back.
class ForgotClearState extends ForgotPasswordEvent {
  const ForgotClearState();
}