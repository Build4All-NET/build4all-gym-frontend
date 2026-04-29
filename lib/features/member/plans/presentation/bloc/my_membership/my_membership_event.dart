/// Base class for all current membership events.
///
/// This is full BLoC, not Cubit.
/// The UI sends events, and the BLoC emits states.
abstract class MyMembershipEvent {}

/// Fired when the plans screen opens.
///
/// Used to load the current active membership of the logged-in member.
class LoadMyMembershipEvent extends MyMembershipEvent {}