import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_entity.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Email login
class AuthLoginSubmitted extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginSubmitted({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// Phone login
class AuthPhoneLoginSubmitted extends AuthEvent {
  final String phone;
  final String password;

  const AuthPhoneLoginSubmitted({required this.phone, required this.password});

  @override
  List<Object?> get props => [phone, password];
}

/// Hydrate from external login (AuthGate token restore)
class AuthLoginHydrated extends AuthEvent {
  final UserEntity? user;
  final String token;
  final bool wasInactive;

  const AuthLoginHydrated({
    required this.user,
    required this.token,
    required this.wasInactive,
  });

  @override
  List<Object?> get props => [user, token, wasInactive];
}

/// Patch user after profile edit
class AuthUserPatched extends AuthEvent {
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? profilePictureUrl;
  final bool? isPublicProfile;
  final String? status;

  const AuthUserPatched({
    this.firstName,
    this.lastName,
    this.username,
    this.profilePictureUrl,
    this.isPublicProfile,
    this.status,
  });

  @override
  List<Object?> get props => [
    firstName, lastName, username,
    profilePictureUrl, isPublicProfile, status,
  ];
}

/// User chose a role when both admin+user tokens were valid
class AuthRoleChosen extends AuthEvent {
  final String role; // 'admin' | 'user'

  const AuthRoleChosen(this.role);

  @override
  List<Object?> get props => [role];
}

/// Logout
class AuthLoggedOut extends AuthEvent {
  const AuthLoggedOut();
}