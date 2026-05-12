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
  final String currentPassword;
  final String newPassword;
  final int ownerProjectLinkId;

  const MemberProfileEditSubmitted({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.address,
    required this.currentEmail,
    required this.currentPassword,
    required this.newPassword,
    required this.ownerProjectLinkId,
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
    currentPassword,
    newPassword,
    ownerProjectLinkId,
  ];
}

class MemberProfileEditEmailCodeSubmitted extends MemberProfileEditEvent {
  final String code;

  const MemberProfileEditEmailCodeSubmitted(this.code);

  @override
  List<Object?> get props => [code];
}

class MemberProfileEditEmailCodeResendRequested extends MemberProfileEditEvent {
  const MemberProfileEditEmailCodeResendRequested();
}

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