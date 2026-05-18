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
  /// Validates QR [token] and creates a check-in.
  /// Returns the checked-in member's full name (for the success snackbar).
  Future<String> scanQr({
    required String token,
    required int    branchId,
  });

  /// PATCH /api/admin/checkins/{checkinId}/checkout
  /// Marks the check-in as CHECKED_OUT.
  Future<void> checkOut(int checkinId);

  /// POST /api/admin/members/{userId}/freeze
  /// Creates a freeze record on the member's active membership.
  Future<void> freezeMember({
    required int    userId,
    required String fromDate,
    required String toDate,
    required String reason,
  });

  /// PATCH /api/admin/members/{userId}/block
  /// Sets the member's status to BLOCKED.
  Future<void> blockMember({
    required int    userId,
    required String reason,
  });
}

