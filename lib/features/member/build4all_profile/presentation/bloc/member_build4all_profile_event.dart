import 'package:equatable/equatable.dart';

abstract class MemberBuild4AllProfileEvent extends Equatable {
  const MemberBuild4AllProfileEvent();

  @override
  List<Object?> get props => [];
}

class MemberBuild4AllProfileStarted extends MemberBuild4AllProfileEvent {
  const MemberBuild4AllProfileStarted();
}

class MemberBuild4AllProfileRefreshRequested
    extends MemberBuild4AllProfileEvent {
  const MemberBuild4AllProfileRefreshRequested();
}