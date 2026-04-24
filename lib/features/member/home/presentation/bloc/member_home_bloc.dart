import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/member_home.dart';
import '../../domain/usecases/get_member_home_usecase.dart';
import '../../domain/usecases/log_weight_usecase.dart';
import 'member_home_event.dart';
import 'member_home_state.dart';

/// BLoC for the member home screen.
///
/// Why this exists:
/// - UI should not call use cases directly.
/// - BLoC receives UI events.
/// - BLoC calls use cases.
/// - BLoC emits states for the UI.
///
/// Flow:
/// UI event → BLoC → UseCase → Repository → Datasource → Backend
class MemberHomeBloc extends Bloc<MemberHomeEvent, MemberHomeState> {
  final GetMemberHomeUseCase getMemberHomeUseCase;
  final LogWeightUseCase logWeightUseCase;

  MemberHomeBloc({
    required this.getMemberHomeUseCase,
    required this.logWeightUseCase,
  }) : super(const MemberHomeInitial()) {
    on<MemberHomeLoadRequested>(_onLoadRequested);
    on<MemberHomeRefreshRequested>(_onRefreshRequested);
    on<MemberHomeWeightLogged>(_onWeightLogged);
    on<MemberHomeWeightCardDismissed>(_onWeightCardDismissed);
  }

  /// First screen load.
  ///
  /// Emits loading because the screen has no data yet.
  Future<void> _onLoadRequested(
      MemberHomeLoadRequested event,
      Emitter<MemberHomeState> emit,
      ) async {
    emit(const MemberHomeLoading());

    final result = await getMemberHomeUseCase();

    result.fold(
          (failure) {
        emit(MemberHomeError(message: failure.message));
      },
          (data) {
        emit(MemberHomeLoaded(data: data, showWeightCard: true));
      },
    );
  }

  /// Pull-to-refresh.
  ///
  /// Does NOT emit loading to avoid screen flicker.
  /// If refresh fails and old data exists, keep old data visible and emit error state.
  Future<void> _onRefreshRequested(
      MemberHomeRefreshRequested event,
      Emitter<MemberHomeState> emit,
      ) async {
    final currentData = _currentData;
    final currentShowWeightCard = _currentShowWeightCard;

    final result = await getMemberHomeUseCase();

    result.fold(
          (failure) {
        if (currentData != null) {
          emit(
            MemberHomeWeightLogError(
              data: currentData,
              showWeightCard: currentShowWeightCard,
              message: failure.message,
            ),
          );
        } else {
          emit(MemberHomeError(message: failure.message));
        }
      },
          (data) {
        emit(
          MemberHomeLoaded(
            data: data,
            showWeightCard: currentShowWeightCard,
          ),
        );
      },
    );
  }

  /// Logs a new weight.
  ///
  /// Does NOT emit loading.
  /// The home screen stays visible while the request happens.
  Future<void> _onWeightLogged(
      MemberHomeWeightLogged event,
      Emitter<MemberHomeState> emit,
      ) async {
    final currentData = _currentData;
    final currentShowWeightCard = _currentShowWeightCard;

    if (currentData == null) {
      emit(const MemberHomeError(message: 'Home data is not loaded yet.'));
      return;
    }

    final result = await logWeightUseCase(weight: event.weight);

    result.fold(
          (failure) {
        emit(
          MemberHomeWeightLogError(
            data: currentData,
            showWeightCard: currentShowWeightCard,
            message: failure.message,
          ),
        );
      },
          (_) {
        emit(
          MemberHomeWeightLogSuccess(
            data: currentData,
            showWeightCard: currentShowWeightCard,
          ),
        );
      },
    );
  }

  /// Hides the weight card for the current session only.
  void _onWeightCardDismissed(
      MemberHomeWeightCardDismissed event,
      Emitter<MemberHomeState> emit,
      ) {
    final currentData = _currentData;

    if (currentData == null) return;

    emit(
      MemberHomeLoaded(
        data: currentData,
        showWeightCard: false,
      ),
    );
  }

  /// Extracts current MemberHome data from any loaded-like state.
  MemberHome? get _currentData {
    final s = state;

    if (s is MemberHomeLoaded) return s.data;
    if (s is MemberHomeWeightLogSuccess) return s.data;
    if (s is MemberHomeWeightLogError) return s.data;

    return null;
  }

  /// Extracts current weight card visibility from any loaded-like state.
  bool get _currentShowWeightCard {
    final s = state;

    if (s is MemberHomeLoaded) return s.showWeightCard;
    if (s is MemberHomeWeightLogSuccess) return s.showWeightCard;
    if (s is MemberHomeWeightLogError) return s.showWeightCard;

    return true;
  }
}