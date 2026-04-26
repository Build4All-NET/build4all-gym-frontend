// ═══════════════════════════════════════════════════════════════════
// admin_dashboard_repository.dart  ─  DOMAIN REPOSITORY (ABSTRACT)
// ═══════════════════════════════════════════════════════════════════
//
// PURPOSE:
//   Defines the CONTRACT (interface) for fetching dashboard data.
//   This is an ABSTRACT class — it has no implementation here.
//   The actual implementation lives in the DATA layer:
//     data/repositories/admin_dashboard_repository_impl.dart
//
// WHY ABSTRACT?
//   The DOMAIN layer must NOT know where data comes from.
//   It doesn't care if data comes from:
//     - HTTP API (production)
//     - A mock/fake (testing)
//     - Local cache (offline mode)
//   By depending only on this abstract class, the use case works
//   identically in all three cases.
//
// EITHER TYPE:
//   Either<Failure, AdminDashboardSummary> is from the dartz package.
//   It forces you to handle BOTH outcomes before using the data:
//     Left(failure)  = something went wrong   → show error UI
//     Right(summary) = success                → show dashboard data
//   There is no try/catch in the BLoC — Either handles it cleanly.
//
//   ALTERNATIVE (if your project uses a custom Result type instead):
//   Replace Either<Failure, T> with your existing pattern.
// ═══════════════════════════════════════════════════════════════════

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart'; // Failure, ServerFailure, NetworkFailure, AuthFailure
import '../entities/admin_dashboard_summary.dart';

// Abstract class = a contract. No method bodies here, just signatures.
abstract class AdminDashboardRepository {

  // ── getDashboardSummary ───────────────────────────────────────────
  //
  // Called by GetAdminDashboardUseCase.
  // The `period` param maps to the ?period query string in the HTTP call.
  //
  // Returns:
  //   Left(ServerFailure)  → API returned 5xx or unexpected error
  //   Left(NetworkFailure) → No internet connection
  //   Left(AuthFailure)    → 401 Unauthorized or 403 Forbidden
  //   Right(summary)       → Success — use the data
  //
  // The `{String period = 'today'}` syntax means:
  //   - Named parameter (must be written as: getDashboardSummary(period: 'week'))
  //   - Has a default value → can be called WITHOUT the period argument
  //     and it will default to 'today'
  Future<Either<Failure, AdminDashboardSummary>> getDashboardSummary({
    String period = 'today',
  });
}