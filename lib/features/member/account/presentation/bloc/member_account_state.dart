import 'package:equatable/equatable.dart';
import 'package:build4allgym/features/member/account/domain/entities/member_account_entity.dart';

abstract class MemberAccountState extends Equatable {
  const MemberAccountState();

  @override
  List<Object?> get props => [];
}

class MemberAccountInitial extends MemberAccountState {
  const MemberAccountInitial();
}

class MemberAccountLoading extends MemberAccountState {
  const MemberAccountLoading();
}

class MemberAccountLoaded extends MemberAccountState {
  final MemberAccountEntity account;

  const MemberAccountLoaded(this.account);

  @override
  List<Object?> get props => [account];
}

class MemberAccountError extends MemberAccountState {
  final String message;

  const MemberAccountError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileUpdateLoading extends MemberAccountState {
  const ProfileUpdateLoading();
}

class ProfileUpdateSuccess extends MemberAccountState {
  const ProfileUpdateSuccess();
}

// Emitted when Gym profile update fails.
class ProfileUpdateError extends MemberAccountState {
  final String message;

  const ProfileUpdateError(this.message);

  @override
  List<Object?> get props => [message];
}