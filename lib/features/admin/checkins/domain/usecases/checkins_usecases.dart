// =============================================================================
// FILE: checkins_usecases.dart
// PATH: lib/features/admin/checkins/domain/usecases/checkins_usecases.dart
// LAYER: Domain Layer → Use Cases
//
// PURPOSE:
//   One file holds all 5 thin use-case classes for the checkins feature.
//   Each class has a single `call()` method so the BLoC can invoke it as
//   `await getCheckins(branchId: id)`.
//
//   Keeping them in one file avoids 5 separate imports in the router/DI.
// =============================================================================

import '../entities/checkin.dart';
import '../entities/checkin_stats.dart';
import '../repositories/checkins_repository.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 1. GetTodayCheckinsUseCase
//    Called on screen load and after each search keystroke (debounced).
// ─────────────────────────────────────────────────────────────────────────────
class GetTodayCheckinsUseCase {
  final CheckinsRepository repository;
  GetTodayCheckinsUseCase(this.repository);

  Future<({CheckinStats stats, List<Checkin> checkins})> call({
    int?      branchId,
    String?   search,
    DateTime? date,
  }) =>
      repository.getTodayCheckins(branchId: branchId, search: search, date: date);
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. ScanQrCheckinUseCase
//    Called after the camera reads a QR code. The backend toggles direction
//    on rescan, so this can come back as either a check-in or a check-out.
// ─────────────────────────────────────────────────────────────────────────────
class ScanQrCheckinUseCase {
  final CheckinsRepository repository;
  ScanQrCheckinUseCase(this.repository);

  Future<({String memberName, bool checkedOut})> call({
    required String token,
    required int    branchId,
  }) =>
      repository.scanQr(token: token, branchId: branchId);
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. CheckOutMemberUseCase
//    Admin taps "Out" on a member card.
// ─────────────────────────────────────────────────────────────────────────────
class CheckOutMemberUseCase {
  final CheckinsRepository repository;
  CheckOutMemberUseCase(this.repository);

  Future<void> call({required int checkinId, required int branchId}) =>
      repository.checkOut(checkinId: checkinId, branchId: branchId);
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. BlockMemberUseCase
//    Admin confirms the block dialog.
// ─────────────────────────────────────────────────────────────────────────────
class BlockMemberUseCase {
  final CheckinsRepository repository;
  BlockMemberUseCase(this.repository);

  Future<void> call({required int userId, required String reason}) =>
      repository.blockMember(userId: userId, reason: reason);
}
