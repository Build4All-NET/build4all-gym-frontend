import 'package:equatable/equatable.dart';

// The STATE = what the app remembers at any moment.
// We need to store maskedContact + resetToken between screens!
class ForgotPasswordState extends Equatable {
  final bool isLoading;

  // step 0 = start
  // step 1 = OTP sent     → navigate to Screen 2
  // step 2 = OTP verified → navigate to Screen 3
  // step 3 = password reset → go back to login
  final int step;

  // From Step 1 — needed to show "Check jo***@gmail.com" on Screen 2
  final String? maskedContact;
  final String? deliveryMethod; // "EMAIL" or "PHONE"

  // From Step 2 — MUST be sent in Step 3!
  // Stored here so Screen 3 can access it
  final String? resetToken;

  final String? successMessage;
  final String? errorMessage;

  const ForgotPasswordState({
    this.isLoading = false,
    this.step = 0,
    this.maskedContact,
    this.deliveryMethod,
    this.resetToken,
    this.successMessage,
    this.errorMessage,
  });

  // Initial state when screen first opens
  factory ForgotPasswordState.initial() => const ForgotPasswordState();

  // copyWith = update only certain fields, keep the rest the same
  ForgotPasswordState copyWith({
    bool? isLoading,
    int? step,
    String? maskedContact,
    String? deliveryMethod,
    String? resetToken,
    String? successMessage,
    String? errorMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return ForgotPasswordState(
      isLoading: isLoading ?? this.isLoading,
      step: step ?? this.step,
      maskedContact: maskedContact ?? this.maskedContact,
      deliveryMethod: deliveryMethod ?? this.deliveryMethod,
      resetToken: resetToken ?? this.resetToken,
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    isLoading, step, maskedContact, deliveryMethod,
    resetToken, successMessage, errorMessage,
  ];
}