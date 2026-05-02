import 'package:equatable/equatable.dart';

abstract class MemberAccountEvent extends Equatable {
  const MemberAccountEvent();

  @override
  List<Object?> get props => [];
}

// Dispatched on screen init to load all account data.
class MemberAccountStarted extends MemberAccountEvent {
  const MemberAccountStarted();
}

// Dispatched when user taps save button on edit profile.
class MemberAccountProfileUpdateRequested extends MemberAccountEvent {
  final String fullName;
  final String phone;
  final String? dateOfBirth;
  final String? address;

  const MemberAccountProfileUpdateRequested({
    required this.fullName,
    required this.phone,
    this.dateOfBirth,
    this.address,
  });

  @override
  List<Object?> get props => [fullName, phone, dateOfBirth, address];
}