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
    required int branchId,
    String? search,
  }) =>
      repository.getTodayCheckins(branchId: branchId, search: search);
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. ScanQrCheckinUseCase
//    Called after the camera reads a QR code.
//    Returns the member's full name to show in the success snackbar.
// ─────────────────────────────────────────────────────────────────────────────
class ScanQrCheckinUseCase {
  final CheckinsRepository repository;
  ScanQrCheckinUseCase(this.repository);

  Future<String> call({required String token, required int branchId}) =>
      repository.scanQr(token: token, branchId: branchId);
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. CheckOutMemberUseCase
//    Admin taps "Out" on a member card.
// ─────────────────────────────────────────────────────────────────────────────
class CheckOutMemberUseCase {
  final CheckinsRepository repository;
  CheckOutMemberUseCase(this.repository);

  Future<void> call(int checkinId) => repository.checkOut(checkinId);
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. FreezeMemberUseCase
//    Admin fills the freeze bottom sheet and taps Confirm.
// ─────────────────────────────────────────────────────────────────────────────
class FreezeMemberUseCase {
  final CheckinsRepository repository;
  FreezeMemberUseCase(this.repository);

  Future<void> call({
    required int    userId,
    required String fromDate,
    required String toDate,
    required String reason,
  }) =>
      repository.freezeMember(
        userId:   userId,
        fromDate: fromDate,
        toDate:   toDate,
        reason:   reason,
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// 5. BlockMemberUseCase
//    Admin confirms the block dialog.
// ─────────────────────────────────────────────────────────────────────────────
class BlockMemberUseCase {
  final CheckinsRepository repository;
  BlockMemberUseCase(this.repository);

  Future<void> call({required int userId, required String reason}) =>
      repository.blockMember(userId: userId, reason: reason);
}
