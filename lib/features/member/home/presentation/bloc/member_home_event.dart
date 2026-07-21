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
///
/// [notLoadedMessage] is the localized message shown in the rare case this
/// fires before home data has loaded — passed from the screen so the BLoC
/// stays context-free.
class MemberHomeWeightLogged extends MemberHomeEvent {
  final double weight;
  final String notLoadedMessage;

  const MemberHomeWeightLogged({
    required this.weight,
    required this.notLoadedMessage,
  });

  @override
  List<Object?> get props => [weight, notLoadedMessage];
}

/// Triggered when the user dismisses the weight tracker card.
class MemberHomeWeightCardDismissed extends MemberHomeEvent {
  const MemberHomeWeightCardDismissed();
}