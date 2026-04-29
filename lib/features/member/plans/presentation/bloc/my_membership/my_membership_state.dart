import '../../../domain/entities/my_membership_entity.dart';

/// Base class for all current membership states.
///
/// The UI listens to these states to decide what to show
/// at the top of the plans screen.
abstract class MyMembershipState {}

/// Initial state before any action happens.
class MyMembershipInitial extends MyMembershipState {}

/// Loading state while the current membership is being fetched.
class MyMembershipLoading extends MyMembershipState {}

/// Success state when the member has an active membership.
class MyMembershipLoaded extends MyMembershipState {
  final MyMembershipEntity membership;

  MyMembershipLoaded({
    required this.membership,
  });
}

/// Valid state when the member has no active plan yet.
///
/// This is NOT an error.
/// The UI should simply show nothing at the top of the plans screen.
class MyMembershipNotFound extends MyMembershipState {}

/// Real error state for unexpected failures.
class MyMembershipError extends MyMembershipState {
  final String message;

  MyMembershipError({
    required this.message,
  });
}