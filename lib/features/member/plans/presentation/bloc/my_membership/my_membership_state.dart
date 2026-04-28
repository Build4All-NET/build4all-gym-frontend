import '../../../domain/entities/my_membership_entity.dart';

abstract class MyMembershipState {}

class MyMembershipInitial extends MyMembershipState {}

class MyMembershipLoading extends MyMembershipState {}

class MyMembershipLoaded extends MyMembershipState {
  final MyMembershipEntity membership;

  MyMembershipLoaded({
    required this.membership,
  });
}

/// Member has no active plan yet
/// This is NOT an error state
class MyMembershipNotFound extends MyMembershipState {}

class MyMembershipError extends MyMembershipState {
  final String message;

  MyMembershipError({
    required this.message,
  });
}