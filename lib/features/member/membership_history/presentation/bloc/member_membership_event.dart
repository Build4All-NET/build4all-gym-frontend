/*
 * Base event for the member membership history BLoC.
 */
abstract class MemberMembershipEvent {
  const MemberMembershipEvent();
}

/*
 * Triggered when the membership history screen opens.
 *
 * When status is null, all memberships are loaded.
 * A status can optionally be provided later.
 */
class MemberMembershipStarted extends MemberMembershipEvent {
  final String? status;

  const MemberMembershipStarted({
    this.status,
  });
}

/*
 * Triggered when the user performs pull-to-refresh.
 *
 * It reloads the same membership list from the backend.
 */
class MemberMembershipRefreshed extends MemberMembershipEvent {
  final String? status;

  const MemberMembershipRefreshed({
    this.status,
  });
}