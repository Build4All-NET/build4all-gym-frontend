import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/initiate_forgot_password.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';
// ─────────────────────────────────────────────────────────────────────────────
// lib/features/forgotpassword/presentation/bloc/forgot_password_bloc.dart
//
// PURPOSE:
//   The brain of the forgot-password flow. Receives events from the UI,
//   calls the appropriate use case, and emits a new state.
//   All three screens share this single BLoC instance (passed via
//   BlocProvider.value when navigating).
//
// EVENT → HANDLER MAP:
//   ForgotSendCodePressed       → _onSend()    → calls SendResetCode use case
//   ForgotVerifyCodePressed     → _onVerify()  → calls VerifyResetCode use case
//   ForgotUpdatePasswordPressed → _onUpdate()  → calls UpdatePassword use case
//   ForgotClearMessage          → inline       → clears successMessage + error
//
// ERROR HANDLING:
//   All use case calls are wrapped in try/catch. Any exception is stored in
//   state.error and displayed by the screen's BlocConsumer listener via
//   ExceptionMapper.toMessage().
//
// RELATIONSHIPS:
//   ▶ Depends on:  SendResetCode, VerifyResetCode, UpdatePassword (use cases)
//   ◀ Listened by: ForgotPasswordEmailScreen, ForgotPasswordVerifyScreen,
//                  ForgotPasswordNewPasswordScreen
// ─────────────────────────────────────────────────────────────────────────────

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  /// Use case for Step 1 — sending the OTP.
  final SendResetCode sendResetCode;

  /// Use case for Step 2 — verifying the OTP.
  final VerifyResetCode verifyResetCode;

  /// Use case for Step 3 — updating the password.
  final UpdatePassword updatePassword;

  ForgotPasswordBloc({
    required this.sendResetCode,
    required this.verifyResetCode,
    required this.updatePassword,
  }) : super(ForgotPasswordState.initial()) {
    // Register a handler for each event type
    on<ForgotSendCodePressed>(_onSend);
    on<ForgotVerifyCodePressed>(_onVerify);
    on<ForgotUpdatePasswordPressed>(_onUpdate);

    // Inline handler: simply wipes success and error fields from state.
    // Called right after navigation to prevent the listener from re-firing.
    on<ForgotClearMessage>(
          (e, emit) =>
          emit(state.copyWith(clearSuccess: true, clearError: true)),
    );
  }

  // ── STEP 1 HANDLER ────────────────────────────────────────────────────────

  /// Fired by Screen 1 ("Send OTP") and Screen 2 ("Resend").
  /// Sets isLoading → calls use case → emits success or error.
  Future<void> _onSend(
      ForgotSendCodePressed e,
      Emitter<ForgotPasswordState> emit,
      ) async {
    // Show spinner, clear any previous message/error
    emit(state.copyWith(
      isLoading: true,
      clearSuccess: true,
      clearError: true,
    ));

    try {
      final res = await sendResetCode(
        email: e.email,
        ownerProjectLinkId: e.ownerProjectLinkId,
      );
      // Success → store the backend message (Screen 1 listener will navigate)
      emit(state.copyWith(isLoading: false, successMessage: res.message));
    } catch (err) {
      // Failure → store the exception (screen listener shows toast)
      emit(state.copyWith(isLoading: false, error: err));
    }
  }

  // ── STEP 2 HANDLER ────────────────────────────────────────────────────────

  /// Fired by Screen 2 ("Verify").
  Future<void> _onVerify(
      ForgotVerifyCodePressed e,
      Emitter<ForgotPasswordState> emit,
      ) async {
    emit(state.copyWith(
      isLoading: true,
      clearSuccess: true,
      clearError: true,
    ));

    try {
      final res = await verifyResetCode(
        email: e.email,
        code: e.code,
        ownerProjectLinkId: e.ownerProjectLinkId,
      );
      // Success → Screen 2 listener navigates to Screen 3
      emit(state.copyWith(isLoading: false, successMessage: res.message));
    } catch (err) {
      emit(state.copyWith(isLoading: false, error: err));
    }
  }

  // ── STEP 3 HANDLER ────────────────────────────────────────────────────────

  /// Fired by Screen 3 ("Save Password").
  Future<void> _onUpdate(
      ForgotUpdatePasswordPressed e,
      Emitter<ForgotPasswordState> emit,
      ) async {
    emit(state.copyWith(
      isLoading: true,
      clearSuccess: true,
      clearError: true,
    ));

    try {
      final res = await updatePassword(
        email: e.email,
        code: e.code,
        newPassword: e.newPassword,
        ownerProjectLinkId: e.ownerProjectLinkId,
      );
      // Success → Screen 3 listener pops to login and shows success toast
      emit(state.copyWith(isLoading: false, successMessage: res.message));
    } catch (err) {
      emit(state.copyWith(isLoading: false, error: err));
    }
  }
}