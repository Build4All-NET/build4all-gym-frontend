import 'package:equatable/equatable.dart';

abstract class MemberProfileEditEvent extends Equatable {
  const MemberProfileEditEvent();

  @override
  List<Object?> get props => [];
}

class MemberProfileEditSubmitted extends MemberProfileEditEvent {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String phoneNumber;

  final String? dateOfBirth;
  final String? address;

  final String currentEmail;
  final String currentPhoneNumber;

  final String currentPassword;
  final String newPassword;
  final int ownerProjectLinkId;

  // True after phone OTP is verified.
  final bool phoneAlreadyVerified;

  // True after password OTP is verified and password is updated.
  final bool passwordAlreadyUpdated;

  const MemberProfileEditSubmitted({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.address,
    required this.currentEmail,
    required this.currentPhoneNumber,
    required this.currentPassword,
    required this.newPassword,
    required this.ownerProjectLinkId,
    this.phoneAlreadyVerified = false,
    this.passwordAlreadyUpdated = false,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    username,
    email,
    phoneNumber,
    dateOfBirth,
    address,
    currentEmail,
    currentPhoneNumber,
    currentPassword,
    newPassword,
    ownerProjectLinkId,
    phoneAlreadyVerified,
    passwordAlreadyUpdated,
  ];
}

// EMAIL OTP SUBMIT
class MemberProfileEditEmailCodeSubmitted extends MemberProfileEditEvent {
  final String code;

  const MemberProfileEditEmailCodeSubmitted(this.code);

  @override
  List<Object?> get props => [code];
}

// EMAIL OTP RESEND
class MemberProfileEditEmailCodeResendRequested extends MemberProfileEditEvent {
  const MemberProfileEditEmailCodeResendRequested();
}

// PASSWORD OTP SUBMIT
class MemberProfileEditPasswordCodeSubmitted extends MemberProfileEditEvent {
  final String email;
  final String code;
  final String newPassword;
  final int ownerProjectLinkId;

  const MemberProfileEditPasswordCodeSubmitted({
    required this.email,
    required this.code,
    required this.newPassword,
    required this.ownerProjectLinkId,
  });

  @override
  List<Object?> get props => [
    email,
    code,
    newPassword,
    ownerProjectLinkId,
  ];
}

// PASSWORD OTP RESEND
class MemberProfileEditPasswordCodeResendRequested
    extends MemberProfileEditEvent {
  final String email;
  final int ownerProjectLinkId;

  const MemberProfileEditPasswordCodeResendRequested({
    required this.email,
    required this.ownerProjectLinkId,
  });

  @override
  List<Object?> get props => [
    email,
    ownerProjectLinkId,
  ];
}

// PHONE OTP SUBMIT
class MemberProfileEditPhoneCodeSubmitted extends MemberProfileEditEvent {
  final String phoneNumber;
  final String code;

  const MemberProfileEditPhoneCodeSubmitted({
    required this.phoneNumber,
    required this.code,
  });

  @override
  List<Object?> get props => [
    phoneNumber,
    code,
  ];
}

// PHONE OTP RESEND
class MemberProfileEditPhoneCodeResendRequested
    extends MemberProfileEditEvent {
  final String phoneNumber;
  final int ownerProjectLinkId;

  const MemberProfileEditPhoneCodeResendRequested({
    required this.phoneNumber,
    required this.ownerProjectLinkId,
  });

  @override
  List<Object?> get props => [
    phoneNumber,
    ownerProjectLinkId,
  ];
}