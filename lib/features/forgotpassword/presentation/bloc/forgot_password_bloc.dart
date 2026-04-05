import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:build4allgym/core/exceptions/app_exception.dart';

import '../../domain/usecases/initiate_forgot_password.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {

  final InitiateForgotPassword initiateForgotPassword;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  ForgotPasswordBloc({
    required this.initiateForgotPassword,
    required this.verifyOtpUseCase,
    required this.resetPasswordUseCase,
  }) : super(ForgotPasswordState.initial()) {
    on<ForgotSendCodePressed>(_onSend);
    on<ForgotVerifyOtpPressed>(_onVerify);
    on<ForgotResetPasswordPressed>(_onReset);
    on<ForgotClearState>((_, emit) => emit(ForgotPasswordState.initial()));
  }

  // ── STEP 1 ────────────────────────────────────────────────────────────────
  // Fired when user taps "Send OTP" on Screen 1 OR "Resend" on Screen 2
  Future<void> _onSend(
      ForgotSendCodePressed e,
      Emitter<ForgotPasswordState> emit,
      ) async {
    // Show spinner, clear any old errors/success
    emit(state.copyWith(
      isLoading: true,
      clearError: true,
      clearSuccess: true,
    ));

    try {
      final result = await initiateForgotPassword(e.identifier);

      // Store maskedContact + deliveryMethod in state
      // Set step to 1 → Screen 1's listener will navigate to Screen 2
      emit(state.copyWith(
        isLoading: false,
        step: 1,
        maskedContact: result.maskedContact,
        deliveryMethod: result.deliveryMethod,
        successMessage: 'OTP sent to ${result.maskedContact}',
      ));

    } on AppException catch (e) {
      // AppException— use e.message directly
      // e.message = the backend message like "Email or phone number is required"
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      // Fallback for anything unexpected
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Something went wrong. Please try again.',
      ));
    }
  }

  // ── STEP 2 ────────────────────────────────────────────────────────────────
  // Fired when user taps "Verify" on Screen 2
  Future<void> _onVerify(
      ForgotVerifyOtpPressed e,
      Emitter<ForgotPasswordState> emit,
      ) async {
    emit(state.copyWith(
      isLoading: true,
      clearError: true,
      clearSuccess: true,
    ));

    try {
      final result = await verifyOtpUseCase(e.identifier, e.otpCode);

      // Store the resetToken in state — Screen 3 reads it from here!
      // Set step to 2 → Screen 2's listener will navigate to Screen 3
      emit(state.copyWith(
        isLoading: false,
        step: 2,
        resetToken: result.resetToken,
        successMessage: 'OTP verified successfully!',
      ));

    } on AppException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Something went wrong. Please try again.',
      ));
    }
  }

  // ── STEP 3 ────────────────────────────────────────────────────────────────
  // Fired when user taps "Save Password" on Screen 3
  Future<void> _onReset(
      ForgotResetPasswordPressed e,
      Emitter<ForgotPasswordState> emit,
      ) async {
    emit(state.copyWith(
      isLoading: true,
      clearError: true,
      clearSuccess: true,
    ));

    try {
      final result = await resetPasswordUseCase(e.resetToken, e.newPassword);

      // Set step to 3 → Screen 3's listener will navigate back to login
      emit(state.copyWith(
        isLoading: false,
        step: 3,
        successMessage: result.message,
      ));

    } on AppException catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Something went wrong. Please try again.',
      ));
    }
  }
}