import 'package:equatable/equatable.dart';


abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();
  @override
  List<Object?> get props => [];
}

// Screen 1: user taps "Send OTP"
// Also used for RESEND on Screen 2 — same event, same endpoint!
class ForgotSendCodePressed extends ForgotPasswordEvent {
  final String identifier; // email or phone
  const ForgotSendCodePressed({required this.identifier});
  @override
  List<Object?> get props => [identifier];
}

// Screen 2: user taps "Verify"
class ForgotVerifyOtpPressed extends ForgotPasswordEvent {
  final String identifier; // same email/phone from step 1
  final String otpCode;    // the 6-digit code user typed
  const ForgotVerifyOtpPressed({
    required this.identifier,
    required this.otpCode,
  });
  @override
  List<Object?> get props => [identifier, otpCode];
}

// Screen 3: user taps "Save Password"
class ForgotResetPasswordPressed extends ForgotPasswordEvent {
  final String resetToken;  // UUID stored from step 2
  final String newPassword; // what the user typed
  const ForgotResetPasswordPressed({
    required this.resetToken,
    required this.newPassword,
  });
  @override
  List<Object?> get props => [resetToken, newPassword];
}

// Clears success/error after navigation so it doesn't fire again
class ForgotClearState extends ForgotPasswordEvent {
  const ForgotClearState();
}