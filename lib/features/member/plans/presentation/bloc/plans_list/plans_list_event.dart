/// Base class for all plans list events.
///
/// We use full BLoC here, not Cubit.
/// That means the UI sends Events, and the BLoC emits States.
abstract class PlansListEvent {}

/// Fired when the plans screen is opened.
///
/// The screen should dispatch this event in initState
/// to load the active plans from the backend.
class LoadPlansEvent extends PlansListEvent {}