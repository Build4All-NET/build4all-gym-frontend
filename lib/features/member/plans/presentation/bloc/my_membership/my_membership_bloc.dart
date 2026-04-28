import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_my_membership_usecase.dart';
import 'my_membership_event.dart';
import 'my_membership_state.dart';

class MyMembershipBloc
    extends Bloc<MyMembershipEvent, MyMembershipState> {
  final GetMyMembershipUseCase getMyMembership;

  MyMembershipBloc({
    required this.getMyMembership,
  }) : super(MyMembershipInitial()) {
    on<LoadMyMembershipEvent>(_onLoadMyMembership);
  }

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
      /// backend returns 400 when no active membership
      /// datasource converts it to null
      emit(MyMembershipNotFound());
    }
  }
}