import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_member_build4all_profile_usecase.dart';
import 'member_build4all_profile_event.dart';
import 'member_build4all_profile_state.dart';

class MemberBuild4AllProfileBloc
    extends Bloc<MemberBuild4AllProfileEvent, MemberBuild4AllProfileState> {
  final GetMemberBuild4AllProfileUseCase getProfileUseCase;

  MemberBuild4AllProfileBloc({
    required this.getProfileUseCase,
  }) : super(const MemberBuild4AllProfileInitial()) {
    on<MemberBuild4AllProfileStarted>(_onStarted);
    on<MemberBuild4AllProfileRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onStarted(
      MemberBuild4AllProfileStarted event,
      Emitter<MemberBuild4AllProfileState> emit,
      ) async {
    await _load(emit);
  }

  Future<void> _onRefreshRequested(
      MemberBuild4AllProfileRefreshRequested event,
      Emitter<MemberBuild4AllProfileState> emit,
      ) async {
    await _load(emit);
  }

  Future<void> _load(
      Emitter<MemberBuild4AllProfileState> emit,
      ) async {
    emit(const MemberBuild4AllProfileLoading());

    try {
      final profile = await getProfileUseCase();
      emit(MemberBuild4AllProfileLoaded(profile));
    } catch (e) {
      emit(MemberBuild4AllProfileError(_cleanError(e)));
    }
  }

  String _cleanError(Object error) {
    final text = error.toString().replaceFirst('Exception: ', '').trim();
    return text.isEmpty ? 'Failed to load Build4All profile' : text;
  }
}