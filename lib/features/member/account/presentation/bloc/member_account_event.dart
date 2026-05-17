import 'package:equatable/equatable.dart';

abstract class MemberAccountEvent extends Equatable {
  const MemberAccountEvent();

  @override
  List<Object?> get props => [];
}

// Dispatched on screen init to load Gym-owned member account data.
class MemberAccountStarted extends MemberAccountEvent {
  const MemberAccountStarted();
}

// Dispatched when Gym-owned profile fields are updated.
//
// Sent to:
// PATCH /api/member/account/profile
//
// Gym backend updates only:
// - dateOfBirth
// - address
// - gender
//
// Build4All profile fields are handled separately:
// - firstName
// - lastName
// - username
// - email
// - phoneNumber
// - profileImageUrl
// - password
class MemberAccountProfileUpdateRequested extends MemberAccountEvent {
  final String? dateOfBirth;
  final String? address;
  final String? gender;

  const MemberAccountProfileUpdateRequested({
    this.dateOfBirth,
    this.address,
    this.gender,
  });

  @override
  List<Object?> get props => [
    dateOfBirth,
    address,
    gender,
  ];
}