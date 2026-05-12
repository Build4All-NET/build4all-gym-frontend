import 'package:equatable/equatable.dart';

import '../../domain/entities/member_build4all_profile_entity.dart';

abstract class MemberBuild4AllProfileState extends Equatable {
  const MemberBuild4AllProfileState();

  @override
  List<Object?> get props => [];
}

class MemberBuild4AllProfileInitial extends MemberBuild4AllProfileState {
  const MemberBuild4AllProfileInitial();
}

class MemberBuild4AllProfileLoading extends MemberBuild4AllProfileState {
  const MemberBuild4AllProfileLoading();
}

class MemberBuild4AllProfileLoaded extends MemberBuild4AllProfileState {
  final MemberBuild4AllProfileEntity profile;

  const MemberBuild4AllProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class MemberBuild4AllProfileError extends MemberBuild4AllProfileState {
  final String message;

  const MemberBuild4AllProfileError(this.message);

  @override
  List<Object?> get props => [message];
}