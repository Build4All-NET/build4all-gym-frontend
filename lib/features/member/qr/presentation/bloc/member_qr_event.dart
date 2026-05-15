import 'package:equatable/equatable.dart';

/// Base class for all member QR events.
///
/// Events describe what happened:
/// - screen opened
/// - user refreshed
/// - token expired
abstract class MemberQrEvent extends Equatable {
  const MemberQrEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered when the member QR screen opens.
///
/// Example:
/// BlocProvider creates MemberQrBloc
/// then immediately dispatches:
///
/// add(const LoadMemberQr());
class LoadMemberQr extends MemberQrEvent {
  const LoadMemberQr();
}

/// Triggered when the QR needs a fresh token.
///
/// Used by:
/// - pull-to-refresh from UI
/// - auto-refresh timer when expiresAt is reached
///
/// Example:
/// context.read<MemberQrBloc>().add(const RefreshMemberQr());
class RefreshMemberQr extends MemberQrEvent {
  const RefreshMemberQr();
}