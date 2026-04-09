import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/facade/dual_login_orchestrator.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  failure,
  roleChoice,   // both admin + user valid → ask
  inactive,     // wasInactive = true
  deleted,      // wasDeleted = true
}

class AuthState extends Equatable {
  final AuthStatus status;
  final UserEntity? user;
  final String? token;
  final String? role;             // 'user' | 'admin'
  final bool wasInactive;
  final bool wasDeleted;
  final bool canRestoreDeleted;
  final String? errorMessage;
  final String? errorCode;
  final DualLoginResult? dualResult; // carried during roleChoice

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.token,
    this.role,
    this.wasInactive = false,
    this.wasDeleted = false,
    this.canRestoreDeleted = false,
    this.errorMessage,
    this.errorCode,
    this.dualResult,
  });

  bool get isLoading       => status == AuthStatus.loading;
  bool get isAuthenticated => status == AuthStatus.authenticated;

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? token,
    String? role,
    bool? wasInactive,
    bool? wasDeleted,
    bool? canRestoreDeleted,
    String? errorMessage,
    String? errorCode,
    DualLoginResult? dualResult,
  }) {
    return AuthState(
      status:           status           ?? this.status,
      user:             user             ?? this.user,
      token:            token            ?? this.token,
      role:             role             ?? this.role,
      wasInactive:      wasInactive      ?? this.wasInactive,
      wasDeleted:       wasDeleted       ?? this.wasDeleted,
      canRestoreDeleted: canRestoreDeleted ?? this.canRestoreDeleted,
      errorMessage:     errorMessage,   // nullable reset intentional
      errorCode:        errorCode,
      dualResult:       dualResult      ?? this.dualResult,
    );
  }

  @override
  List<Object?> get props => [
    status, user, token, role, wasInactive,
    wasDeleted, canRestoreDeleted,
    errorMessage, errorCode, dualResult,
  ];
}