import 'package:equatable/equatable.dart';

enum RegisterMethod { email, phone }

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

// ── Step 1: send verification code ───────────────────────────────────────────

class RegisterSendCodeSubmitted extends RegisterEvent {
  final RegisterMethod method;
  final String?        email;
  final String?        phoneNumber;
  final String         password;

  const RegisterSendCodeSubmitted({
    required this.method,
    this.email,
    this.phoneNumber,
    required this.password,
  });

  @override
  List<Object?> get props => [method, email, phoneNumber, password];
}

// ── Step 3a: save names (no API call — just stored in state) ─────────────────
// Fired when user taps "Continue" on complete-profile sub-step 1.

class RegisterNamesSubmitted extends RegisterEvent {
  final String firstName;
  final String lastName;

  const RegisterNamesSubmitted({
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object?> get props => [firstName, lastName];
}

// ── Step 3b: finish profile (API call) ───────────────────────────────────────
// Fired when user taps "Finish" on complete-profile sub-step 2.

class RegisterProfileFinished extends RegisterEvent {
  final int     pendingId;
  final String  username;
  final bool    isPublicProfile;
  final int     ownerProjectLinkId;
  final String? profileImagePath;

  const RegisterProfileFinished({
    required this.pendingId,
    required this.username,
    required this.isPublicProfile,
    required this.ownerProjectLinkId,
    this.profileImagePath,
  });

  @override
  List<Object?> get props => [
    pendingId, username, isPublicProfile, ownerProjectLinkId,
  ];
}