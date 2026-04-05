import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/initiate_forgot_password.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';


// Listens to events → calls use cases → emits new states.
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
  Future<void> _onSend(
      ForgotSendCodePressed e,
      Emitter<ForgotPasswordState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));
    try {
      final result = await initiateForgotPassword(e.identifier);
      // Store maskedContact + deliveryMethod in state
      // Change step to 1 → Screen 1 listener will navigate to Screen 2
      emit(state.copyWith(
        isLoading: false,
        step: 1,
        maskedContact: result.maskedContact,
        deliveryMethod: result.deliveryMethod,
        successMessage: 'OTP sent to ${result.maskedContact}',
      ));
    } catch (err) {
      emit(state.copyWith(isLoading: false, errorMessage: err.toString().replaceAll('Exception: ', '')));
    }
  }

  // ── STEP 2 ────────────────────────────────────────────────────────────────
  Future<void> _onVerify(
      ForgotVerifyOtpPressed e,
      Emitter<ForgotPasswordState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));
    try {
      final result = await verifyOtpUseCase(e.identifier, e.otpCode);
      // Store the resetToken in state — Screen 3 will read it from here!
      // Change step to 2 → Screen 2 listener will navigate to Screen 3
      emit(state.copyWith(
        isLoading: false,
        step: 2,
        resetToken: result.resetToken,
        successMessage: 'OTP verified!',
      ));
    } catch (err) {
      emit(state.copyWith(isLoading: false, errorMessage: err.toString().replaceAll('Exception: ', '')));
    }
  }

  // ── STEP 3 ────────────────────────────────────────────────────────────────
  Future<void> _onReset(
      ForgotResetPasswordPressed e,
      Emitter<ForgotPasswordState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));
    try {
      final result = await resetPasswordUseCase(e.resetToken, e.newPassword);
      // Change step to 3 → Screen 3 listener will navigate back to login
      emit(state.copyWith(
        isLoading: false,
        step: 3,
        successMessage: result.message,
      ));
    } catch (err) {
      emit(state.copyWith(isLoading: false, errorMessage: err.toString().replaceAll('Exception: ', '')));
    }
  }
}