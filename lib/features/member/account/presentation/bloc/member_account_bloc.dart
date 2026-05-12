import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/features/member/account/data/models/update_profile_request_model.dart';
import 'package:build4allgym/features/member/account/domain/usecases/get_member_account_usecase.dart';
import 'package:build4allgym/features/member/account/domain/usecases/update_profile_usecase.dart';

import 'member_account_event.dart';
import 'member_account_state.dart';

class MemberAccountBloc extends Bloc<MemberAccountEvent, MemberAccountState> {
  final GetMemberAccountUseCase getMemberAccountUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  MemberAccountBloc({
    required this.getMemberAccountUseCase,
    required this.updateProfileUseCase,
  }) : super(const MemberAccountInitial()) {
    on<MemberAccountStarted>(_onStarted);
    on<MemberAccountProfileUpdateRequested>(_onProfileUpdateRequested);
  }

  Future<void> _onStarted(
      MemberAccountStarted event,
      Emitter<MemberAccountState> emit,
      ) async {
    emit(const MemberAccountLoading());

    try {
      final account = await getMemberAccountUseCase();
      emit(MemberAccountLoaded(account));
    } catch (e) {
      emit(MemberAccountError(_cleanError(e)));
    }
  }

  Future<void> _onProfileUpdateRequested(
      MemberAccountProfileUpdateRequested event,
      Emitter<MemberAccountState> emit,
      ) async {
    emit(const ProfileUpdateLoading());

    try {
      final request = UpdateProfileRequestModel(
        dateOfBirth: event.dateOfBirth,
        address: event.address,
        gender: event.gender,
      );


      await updateProfileUseCase(request);

      emit(const ProfileUpdateSuccess());

      add(const MemberAccountStarted());
    } catch (e) {
      emit(ProfileUpdateError(_cleanError(e)));
    }
  }

  String _cleanError(Object error) {
    final text = error.toString().replaceFirst('Exception: ', '').trim();
    return text.isEmpty ? 'Something went wrong' : text;
  }
}