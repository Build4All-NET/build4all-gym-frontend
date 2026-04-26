import 'package:equatable/equatable.dart';

/// Base class for all member home events.
///
/// Why this exists:
/// BLoC receives events from the UI and reacts to them.
/// Example:
/// - screen opens → MemberHomeLoadRequested
/// - user refreshes → MemberHomeRefreshRequested
/// - user logs weight → MemberHomeWeightLogged
abstract class MemberHomeEvent extends Equatable {
  const MemberHomeEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered when the member home screen opens for the first time.
class MemberHomeLoadRequested extends MemberHomeEvent {
  const MemberHomeLoadRequested();
}

/// Triggered when the user pulls down to refresh the home screen.
class MemberHomeRefreshRequested extends MemberHomeEvent {
  const MemberHomeRefreshRequested();
}

/// Triggered when the user submits a new weight.
///
/// Example:
/// weight = 75.5
class MemberHomeWeightLogged extends MemberHomeEvent {
  final double weight;

  const MemberHomeWeightLogged({
    required this.weight,
  });

  @override
  List<Object?> get props => [weight];
}

/// Triggered when the user dismisses the weight tracker card.
class MemberHomeWeightCardDismissed extends MemberHomeEvent {
  const MemberHomeWeightCardDismissed();
}