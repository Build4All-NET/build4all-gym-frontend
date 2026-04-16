import 'package:equatable/equatable.dart';
import 'package:build4allgym/features/auth/domain/entities/user_entity.dart';

import 'register_event.dart';

class RegisterState extends Equatable {
  final bool isLoading;

  /// UI-level error code — screen resolves it to a localized string.
  final String? errorCode;

  // ── Step 1 result ─────────────────────────────────────────────────────────
  final bool            codeSent;
  final String?         contact; // email OR phone shown in OTP screen
  final RegisterMethod? method;

  // ── Resume path (already-verified pending user) ───────────────────────────
  final bool resumeCompleteProfile;
  final int?  resumePendingId;

  // ── Step 3a result (names stored before API call) ─────────────────────────
  final String? firstName;
  final String? lastName;

  // ── Step 3b result (profile fully saved) ─────────────────────────────────
  final bool        isProfileComplete;
  final UserEntity? completedUser;

  const RegisterState({
    required this.isLoading,
    required this.errorCode,
    required this.codeSent,
    required this.contact,
    required this.method,
    required this.resumeCompleteProfile,
    required this.resumePendingId,
    this.firstName,
    this.lastName,
    this.isProfileComplete = false,
    this.completedUser,
  });

  factory RegisterState.initial() {
    return const RegisterState(
      isLoading:            false,
      errorCode:            null,
      codeSent:             false,
      contact:              null,
      method:               null,
      resumeCompleteProfile: false,
      resumePendingId:      null,
      firstName:            null,
      lastName:             null,
      isProfileComplete:    false,
      completedUser:        null,
    );
  }

  // Sentinel so copyWith can null-reset optional fields
  static const Object _unset = Object();

  RegisterState copyWith({
    bool?            isLoading,
    Object?          errorCode          = _unset,
    bool?            codeSent,
    Object?          contact            = _unset,
    Object?          method             = _unset,
    bool?            resumeCompleteProfile,
    Object?          resumePendingId    = _unset,
    Object?          firstName          = _unset,
    Object?          lastName           = _unset,
    bool?            isProfileComplete,
    Object?          completedUser      = _unset,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      errorCode: identical(errorCode, _unset)
          ? this.errorCode
          : errorCode as String?,
      codeSent: codeSent ?? this.codeSent,
      contact: identical(contact, _unset)
          ? this.contact
          : contact as String?,
      method: identical(method, _unset)
          ? this.method
          : method as RegisterMethod?,
      resumeCompleteProfile:
      resumeCompleteProfile ?? this.resumeCompleteProfile,
      resumePendingId: identical(resumePendingId, _unset)
          ? this.resumePendingId
          : resumePendingId as int?,
      firstName: identical(firstName, _unset)
          ? this.firstName
          : firstName as String?,
      lastName: identical(lastName, _unset)
          ? this.lastName
          : lastName as String?,
      isProfileComplete:
      isProfileComplete ?? this.isProfileComplete,
      completedUser: identical(completedUser, _unset)
          ? this.completedUser
          : completedUser as UserEntity?,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    errorCode,
    codeSent,
    contact,
    method,
    resumeCompleteProfile,
    resumePendingId,
    firstName,
    lastName,
    isProfileComplete,
    completedUser,
  ];
}