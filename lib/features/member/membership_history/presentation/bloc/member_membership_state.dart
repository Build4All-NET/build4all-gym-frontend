import '../../domain/entities/member_membership_entity.dart';

/*
 * Base state for the member membership history BLoC.
 */
abstract class MemberMembershipState {
  const MemberMembershipState();
}

/*
 * Initial state before the memberships request starts.
 */
class MemberMembershipInitial extends MemberMembershipState {
  const MemberMembershipInitial();
}

/*
 * Loading state shown when the screen first loads.
 */
class MemberMembershipLoading extends MemberMembershipState {
  const MemberMembershipLoading();
}

/*
 * Success state containing all memberships returned by the backend.
 *
 * An empty list is valid and will be handled by the screen
 * as the empty state.
 */
class MemberMembershipLoaded extends MemberMembershipState {
  final List<MemberMembershipEntity> memberships;

  const MemberMembershipLoaded({
    required this.memberships,
  });
}

/*
 * Error state shown when loading memberships fails.
 *
 * The message will later be converted into localized visible text
 * inside the presentation layer.
 */
class MemberMembershipError extends MemberMembershipState {
  final String message;

  const MemberMembershipError({
    required this.message,
  });
}