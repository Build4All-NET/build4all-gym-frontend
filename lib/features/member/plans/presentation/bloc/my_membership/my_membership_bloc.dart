import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_my_membership_usecase.dart';
import 'my_membership_event.dart';
import 'my_membership_state.dart';

/// BLoC responsible for loading the logged-in member's current membership.
///
/// This BLoC only calls the domain use case.
/// It does not access datasource or repository directly.
class MyMembershipBloc
    extends Bloc<MyMembershipEvent, MyMembershipState> {
  final GetMyMembershipUseCase getMyMembership;

  MyMembershipBloc({
    required this.getMyMembership,
  }) : super(MyMembershipInitial()) {
    /// Register handler for loading current membership.
    on<LoadMyMembershipEvent>(_onLoadMyMembership);
  }

  /// Handles LoadMyMembershipEvent.
  ///
  /// Flow:
  /// 1. Emit loading state
  /// 2. Call GetMyMembershipUseCase
  /// 3. If membership exists, emit MyMembershipLoaded
  /// 4. If membership is null, emit MyMembershipNotFound
  /// 5. If backend returns "no active membership", also emit NotFound
  Future<void> _onLoadMyMembership(
      LoadMyMembershipEvent event,
      Emitter<MyMembershipState> emit,
      ) async {
    emit(MyMembershipLoading());

    try {
      final membership = await getMyMembership();

      if (membership == null) {
        emit(MyMembershipNotFound());
      } else {
        emit(
          MyMembershipLoaded(
            membership: membership,
          ),
        );
      }
    } catch (e) {
      /// Backend returns 400 when no active membership.
      /// The datasource/repository should convert that to null,
      /// but this fallback keeps the UI safe.
      ///
      /// No active membership is a valid business state,
      /// not an error to show to the user.
      emit(MyMembershipNotFound());
    }
  }
}