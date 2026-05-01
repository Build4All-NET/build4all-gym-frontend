import 'package:equatable/equatable.dart';
import 'package:build4allgym/features/member/account/domain/entities/member_account_entity.dart';

abstract class MemberAccountState extends Equatable {
  const MemberAccountState();

  @override
  List<Object?> get props => [];
}

// Default state before any load.
class MemberAccountInitial extends MemberAccountState {
  const MemberAccountInitial();
}

// Emitted while GET /api/member/account is in flight.
class MemberAccountLoading extends MemberAccountState {
  const MemberAccountLoading();
}

// Emitted on successful load — drives all widgets.
class MemberAccountLoaded extends MemberAccountState {
  final MemberAccountEntity account;

  const MemberAccountLoaded(this.account);

  @override
  List<Object?> get props => [account];
}

// Emitted on network or server error — shows retry.
class MemberAccountError extends MemberAccountState {
  final String message;

  const MemberAccountError(this.message);

  @override
  List<Object?> get props => [message];
}

// Emitted while PATCH is in flight — disables save button.
class ProfileUpdateLoading extends MemberAccountState {
  const ProfileUpdateLoading();
}

// Emitted after successful update — triggers snackbar and refreshes data.
class ProfileUpdateSuccess extends MemberAccountState {
  const ProfileUpdateSuccess();
}

// Emitted on 409 phone conflict or other errors — shows inline error.
class ProfileUpdateError extends MemberAccountState {
  final String message;

  const ProfileUpdateError(this.message);

  @override
  List<Object?> get props => [message];
}