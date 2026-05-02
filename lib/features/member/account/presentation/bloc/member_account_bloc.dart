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

  // Handles MemberAccountStarted — loads account data on screen init.
  Future<void> _onStarted(
      MemberAccountStarted event,
      Emitter<MemberAccountState> emit,
      ) async {
    // Show loading spinner while fetching account data.
    emit(const MemberAccountLoading());

    try {
      // Call use case to fetch account from repository.
      final account = await getMemberAccountUseCase();

      // Emit loaded state with full account data.
      emit(MemberAccountLoaded(account));
    } catch (e) {
      // Emit error state with message for retry UI.
      emit(MemberAccountError(e.toString()));
    }
  }

  // Handles MemberAccountProfileUpdateRequested — sends PATCH request.
  Future<void> _onProfileUpdateRequested(
      MemberAccountProfileUpdateRequested event,
      Emitter<MemberAccountState> emit,
      ) async {
    // Disable save button while update is in flight.
    emit(const ProfileUpdateLoading());

    try {
      // Build request model from event fields.
      final request = UpdateProfileRequestModel(
        fullName: event.fullName,
        phone: event.phone,
        dateOfBirth: event.dateOfBirth,
        address: event.address,
      );

      // Call use case to send PATCH request.
      await updateProfileUseCase(request);

      // Emit success — triggers snackbar in UI.
      emit(const ProfileUpdateSuccess());

      // Re-dispatch MemberAccountStarted to refresh account data.
      add(const MemberAccountStarted());
    } catch (e) {
      // Emit error — shows inline error message in UI.
      emit(ProfileUpdateError(e.toString()));
    }
  }
}