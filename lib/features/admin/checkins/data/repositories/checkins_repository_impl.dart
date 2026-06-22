// =============================================================================
// FILE: checkins_repository_impl.dart
// PATH: lib/features/admin/checkins/data/repositories/checkins_repository_impl.dart
// LAYER: Data Layer → Repositories (Concrete)
//
// PURPOSE:
//   Implements the abstract CheckinsRepository contract from the domain layer.
//   Calls the data source, maps models → entities, and converts exceptions into
//   user-friendly messages that the BLoC can display directly.
// =============================================================================

import '../../../../../core/error/exceptions.dart';
import '../models/CheckinStatsModel.dart';
import '../../domain/entities/checkin.dart';
import '../../domain/entities/checkin_stats.dart';
import '../../domain/repositories/checkins_repository.dart';
import '../models/checkin_model.dart';
import '../services/CheckinsRemoteDataSource.dart';

class CheckinsRepositoryImpl implements CheckinsRepository {
  final CheckinsRemoteDataSource dataSource;

  CheckinsRepositoryImpl(this.dataSource);

  // ── getTodayCheckins ───────────────────────────────────────────────────────
  @override
  Future<({CheckinStats stats, List<Checkin> checkins})> getTodayCheckins({
    required int branchId,
    String? search,
  }) async {
    try {
      final json = await dataSource.getTodayCheckins(
        branchId: branchId,
        search: search,
      );

      final stats = CheckinStatsModel.fromJson(json).toEntity();

      final rawList = json['checkins'] as List<dynamic>? ?? [];

      final checkins = rawList
          .map((e) =>
          CheckinModel.fromJson(e as Map<String, dynamic>).toEntity())
          .toList();

      return (
      stats: stats,
      checkins: checkins,
      );

    } on UnauthorizedException {
      throw Exception('Session expired. Please log in again.');
    } on ForbiddenException {
      throw Exception("You don't have permission to view check-ins.");
    } on ServerException catch (e) {
      throw Exception('Server error: ${e.message}');
    } on NetworkException {
      throw Exception('No internet connection. Please try again.');
    }
  }

  // ── scanQr ─────────────────────────────────────────────────────────────────
  @override
  Future<({String memberName, bool checkedOut})> scanQr({
    required String token,
    required int    branchId,
  }) async {
    try {
      final json = await dataSource.scanQr(token: token, branchId: branchId);
      final fullName = json['fullName'] as String? ?? 'Member';
      final status   = json['status']   as String? ?? 'ACTIVE';
      return (memberName: fullName, checkedOut: status == 'CHECKED_OUT');
    } on UnauthorizedException {
      throw Exception('Session expired. Please log in again.');
    } on ForbiddenException catch (e) {
      final msg = e.message.isNotEmpty ? e.message : 'Member is blocked and cannot check in.';
      throw Exception(msg);
    } on ServerException catch (e) {
      // Surface specific conflict messages (token used, expired, duplicate check-in).
      throw Exception(e.message);
    } on NetworkException {
      throw Exception('No internet connection. Please try again.');
    }
  }

  // ── checkOut ───────────────────────────────────────────────────────────────
  @override
  Future<void> checkOut({required int checkinId, required int branchId}) async {
    try {
      await dataSource.checkOut(checkinId: checkinId, branchId: branchId);
    } on UnauthorizedException {
      throw Exception('Session expired. Please log in again.');
    } on ForbiddenException catch (e) {
      final msg = e.message.isNotEmpty
          ? e.message
          : "You don't have permission to perform this action.";
      throw Exception(msg);
    } on ServerException catch (e) {
      throw Exception(e.message);
    } on NetworkException {
      throw Exception('No internet connection. Please try again.');
    }
  }

  // ── blockMember ────────────────────────────────────────────────────────────
  @override
  Future<void> blockMember({required int userId, required String reason}) async {
    try {
      await dataSource.blockMember(userId: userId, reason: reason);
    } on UnauthorizedException {
      throw Exception('Session expired. Please log in again.');
    } on ForbiddenException {
      throw Exception("You don't have permission to block members.");
    } on ServerException catch (e) {
      throw Exception(e.message);
    } on NetworkException {
      throw Exception('No internet connection. Please try again.');
    }
  }
}
