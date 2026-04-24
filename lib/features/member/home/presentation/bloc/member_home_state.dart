import 'package:equatable/equatable.dart';

import '../../domain/entities/member_home.dart';

/// Base class for all member home states.
///
/// Why this exists:
/// The UI listens to states and rebuilds based on them.
/// Example:
/// - Loading → show loading indicator
/// - Loaded → show home data
/// - Error → show error message
abstract class MemberHomeState extends Equatable {
  const MemberHomeState();

  @override
  List<Object?> get props => [];
}

/// Initial empty state before anything happens.
class MemberHomeInitial extends MemberHomeState {
  const MemberHomeInitial();
}

/// Used only for first screen load.
/// Not used for refresh or weight logging to avoid UI flicker.
class MemberHomeLoading extends MemberHomeState {
  const MemberHomeLoading();
}

/// Main success state containing home screen data.
class MemberHomeLoaded extends MemberHomeState {
  final MemberHome data;

  /// Controls whether the weight tracker card is visible.
  /// If user dismisses it, this becomes false for the current session.
  final bool showWeightCard;

  const MemberHomeLoaded({
    required this.data,
    this.showWeightCard = true,
  });

  @override
  List<Object?> get props => [data, showWeightCard];
}

/// Used when the first home load fails.
class MemberHomeError extends MemberHomeState {
  final String message;

  const MemberHomeError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}

/// Emitted after weight is logged successfully.
///
/// Why it keeps data:
/// The screen should stay visible.
/// We do not want loading flicker after logging weight.
class MemberHomeWeightLogSuccess extends MemberHomeState {
  final MemberHome data;
  final bool showWeightCard;

  const MemberHomeWeightLogSuccess({
    required this.data,
    required this.showWeightCard,
  });

  @override
  List<Object?> get props => [data, showWeightCard];
}

/// Emitted when weight logging fails.
///
/// Why it keeps data:
/// The home screen should stay visible.
/// UI can show snackbar using this message.
class MemberHomeWeightLogError extends MemberHomeState {
  final MemberHome data;
  final bool showWeightCard;
  final String message;

  const MemberHomeWeightLogError({
    required this.data,
    required this.showWeightCard,
    required this.message,
  });

  @override
  List<Object?> get props => [data, showWeightCard, message];
}