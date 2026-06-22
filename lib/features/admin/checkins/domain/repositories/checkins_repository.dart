// =============================================================================
// FILE: checkins_repository.dart
// PATH: lib/features/admin/checkins/domain/repositories/checkins_repository.dart
// LAYER: Domain Layer → Repositories (Abstract Contract)
//
// PURPOSE:
//   Defines WHAT the feature can do with the backend — NOT how.
//   The concrete implementation (CheckinsRepositoryImpl) lives in the data layer.
//   The BLoC only sees this abstract class → keeps domain clean.
// =============================================================================

import '../entities/checkin.dart';
import '../entities/checkin_stats.dart';

abstract class CheckinsRepository {

  /// GET /api/admin/checkins/today?branchId=&search=
  /// Returns stats + today's check-in list, optionally filtered by [search].
  Future<({CheckinStats stats, List<Checkin> checkins})> getTodayCheckins({
    required int branchId,
    String? search,
  });

  /// POST /api/admin/checkins/scan
  /// Validates QR [token] and creates a check-in — or, if the member already
  /// has an active check-in today at this branch, checks them out instead
  /// (the backend toggles direction on rescan). Returns the member's name
  /// and whether this scan checked them OUT (for the snackbar wording).
  /// Throws (e.g. 403) when the member has no active plan, class booking,
  /// or PT session today — entry is denied.
  Future<({String memberName, bool checkedOut})> scanQr({
    required String token,
    required int    branchId,
  });

  /// PATCH /api/admin/checkins/{checkinId}/checkout?branchId=
  /// Marks the check-in as CHECKED_OUT. [branchId] must match the check-in's
  /// branch — the backend rejects cross-branch checkout attempts.
  Future<void> checkOut({required int checkinId, required int branchId});

  /// PATCH /api/admin/members/{userId}/block
  /// Sets the member's status to BLOCKED.
  Future<void> blockMember({
    required int    userId,
    required String reason,
  });
}

