import 'package:equatable/equatable.dart';

class ForgotPasswordState extends Equatable {
  final bool isLoading; // show spinner on the button

  // step 0 = just opened Screen 1
  // step 1 = OTP sent      → Screen 1 navigates to Screen 2
  // step 2 = OTP verified  → Screen 2 navigates to Screen 3
  // step 3 = password reset → Screen 3 goes back to login
  //when it changes they navigate to the next screen.
  final int step;

  // Stored after Step 1 — Screen 2 shows these
  final String? maskedContact;  // "jo***@gmail.com"
  final String? deliveryMethod; // "EMAIL" or "PHONE"

  // Stored after Step 2 — Screen 3 MUST send this to backend
  final String? resetToken; // "69fe576e-0b23-4e7e-..."

  final String? successMessage; // shown as success toast
  final String? errorMessage;   // shown as error toast

  const ForgotPasswordState({
    this.isLoading = false,//True while waiting for the backend. False when done.
    this.step = 0,
    this.maskedContact,
    this.deliveryMethod,
    this.resetToken,
    this.successMessage,
    this.errorMessage,
  });

  // Initial state — blank slate when screen first opens
  factory ForgotPasswordState.initial() => const ForgotPasswordState();

  // copyWith = change only specific fields, keep everything else the same
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
      successMessage:
      clearSuccess ? null : (successMessage ?? this.successMessage),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    isLoading, step, maskedContact, deliveryMethod,
    resetToken, successMessage, errorMessage,
  ];
}