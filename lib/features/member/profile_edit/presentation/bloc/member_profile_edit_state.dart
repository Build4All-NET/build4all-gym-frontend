import 'package:equatable/equatable.dart';

/// Base state for the member edit profile flow.
///
/// This Bloc handles Build4All profile updates:
/// - first name
/// - last name
/// - username
/// - email
/// - phone number
/// - password flow
///
/// Gym-only fields like dateOfBirth/address are still updated through
/// MemberAccountBloc / Gym backend.
abstract class MemberProfileEditState extends Equatable {
  const MemberProfileEditState();

  @override
  List<Object?> get props => [];
}

/// Initial state before the user taps Save.
class MemberProfileEditInitial extends MemberProfileEditState {
  const MemberProfileEditInitial();
}

/// Save/update request is running.
class MemberProfileEditLoading extends MemberProfileEditState {
  const MemberProfileEditLoading();
}

/// Build4All profile was updated successfully.
class MemberProfileEditSuccess extends MemberProfileEditState {
  final String message;

  const MemberProfileEditSuccess({
    this.message = 'Profile updated successfully',
  });

  @override
  List<Object?> get props => [message];
}

/// Email changed and Build4All requires OTP verification.
///
/// The UI should open the e-commerce-style OTP dialog.
/// The dialog then dispatches MemberProfileEditEmailCodeSubmitted.
class MemberProfileEditEmailVerificationRequired
    extends MemberProfileEditState {
  final String newEmail;

  const MemberProfileEditEmailVerificationRequired({
    required this.newEmail,
  });

  @override
  List<Object?> get props => [newEmail];
}

/// Email OTP was verified successfully.
class MemberProfileEditEmailVerified extends MemberProfileEditState {
  const MemberProfileEditEmailVerified();
}

/// Phone changed and Build4All requires OTP verification.
///
/// Flow:
/// 1. User changes phone number.
/// 2. Bloc sends OTP using Build4All:
///    POST /api/auth/send-verification
/// 3. UI opens OTP dialog.
/// 4. Dialog dispatches MemberProfileEditPhoneCodeSubmitted.
/// 5. After phone is verified, UI submits again with phoneAlreadyVerified = true.
class MemberProfileEditPhoneVerificationRequired
    extends MemberProfileEditState {
  final String newPhoneNumber;
  final int ownerProjectLinkId;

  const MemberProfileEditPhoneVerificationRequired({
    required this.newPhoneNumber,
    required this.ownerProjectLinkId,
  });

  @override
  List<Object?> get props => [
    newPhoneNumber,
    ownerProjectLinkId,
  ];
}
/// Phone OTP was verified successfully.
class MemberProfileEditPhoneVerified extends MemberProfileEditState {
  final String phoneNumber;

  const MemberProfileEditPhoneVerified({
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [phoneNumber];
}

/// Password change requires OTP verification.
///
/// This happens after:
/// 1. Current password is checked using Build4All login.
/// 2. Reset code is sent to the user email.
class MemberProfileEditPasswordVerificationRequired
    extends MemberProfileEditState {
  final String email;
  final String newPassword;
  final int ownerProjectLinkId;

  const MemberProfileEditPasswordVerificationRequired({
    required this.email,
    required this.newPassword,
    required this.ownerProjectLinkId,
  });

  @override
  List<Object?> get props => [
    email,
    newPassword,
    ownerProjectLinkId,
  ];
}

/// Password OTP was verified and the new password was saved in Build4All.
class MemberProfileEditPasswordUpdated extends MemberProfileEditState {
  const MemberProfileEditPasswordUpdated();
}

/// Resend code succeeded.
class MemberProfileEditCodeResent extends MemberProfileEditState {
  final String message;

  const MemberProfileEditCodeResent({
    this.message = 'Code resent successfully',
  });

  @override
  List<Object?> get props => [message];
}

/// Any normal error that should be shown as SnackBar/dialog text,
/// not as a Flutter red screen.
class MemberProfileEditError extends MemberProfileEditState {
  final String message;

  const MemberProfileEditError(this.message);

  @override
  List<Object?> get props => [message];
}