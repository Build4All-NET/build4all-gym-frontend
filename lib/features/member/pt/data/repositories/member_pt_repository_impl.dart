import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/trainer_card_entity.dart';
import '../../domain/entities/trainer_filter_options_entity.dart';
import '../../domain/entities/toggle_favorite_response_entity.dart';
import '../../domain/entities/trainer_list_response_entity.dart';
import '../../domain/repositories/member_pt_repository.dart';
import '../services/member_pt_service.dart';

class MemberPtRepositoryImpl implements MemberPtRepository {
  final MemberPtService _service;

  MemberPtRepositoryImpl({required MemberPtService service})
      : _service = service;

  // ── getTrainers ───────────────────────────────────────────────────────────
  @override
  Future<({TrainerListResponseEntity? data, Failure? failure})> getTrainers({
    String? specialtyFilter,
    bool favoritesOnly = false,
  }) async {
    try {
      final model = await _service.getTrainers(
        specialtyFilter: specialtyFilter,
        favoritesOnly: favoritesOnly,
      );
      return (data: model.toEntity(), failure: null);
    } on UnauthorizedException {
      return (
      data: null,
      failure: const AuthFailure('Session expired. Please log in again.'),
      );
    } on ForbiddenException {
      return (data: null, failure: const AuthFailure('Access denied.'));
    } on ServerException catch (e) {
      return (data: null, failure: ServerFailure(e.message));
    } on NetworkException {
      return (data: null, failure: const NetworkFailure('No internet connection.'));
    }
  }

  // ── getFilterOptions ──────────────────────────────────────────────────────
  @override
  Future<({TrainerFilterOptionsEntity? data, Failure? failure})>
  getFilterOptions() async {
    try {
      final model = await _service.getFilterOptions();
      return (data: model.toEntity(), failure: null);
    } on UnauthorizedException {
      return (
      data: null,
      failure: const AuthFailure('Session expired. Please log in again.'),
      );
    } on ForbiddenException {
      return (data: null, failure: const AuthFailure('Access denied.'));
    } on ServerException catch (e) {
      return (data: null, failure: ServerFailure(e.message));
    } on NetworkException {
      return (data: null, failure: const NetworkFailure('No internet connection.'));
    }
  }

  // ── toggleFavoriteTrainer ─────────────────────────────────────────────────
  @override
  Future<({ToggleFavoriteResponseEntity? data, Failure? failure})>
  toggleFavoriteTrainer(int trainerId) async {
    try {
      final model = await _service.toggleFavoriteTrainer(trainerId);
      return (data: model.toEntity(), failure: null);
    } on UnauthorizedException {
      return (
      data: null,
      failure: const AuthFailure('Session expired. Please log in again.'),
      );
    } on ForbiddenException {
      return (data: null, failure: const AuthFailure('Access denied.'));
    } on ServerException catch (e) {
      return (data: null, failure: ServerFailure(e.message));
    } on NetworkException {
      return (data: null, failure: const NetworkFailure('No internet connection.'));
    }
  }
}