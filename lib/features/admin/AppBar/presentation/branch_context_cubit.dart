// FILE: lib/features/admin/AppBar/presentation/branch_context_cubit.dart
//
// PURPOSE:
//   Single source of truth for "which branch is currently selected" across
//   every admin/trainer PT screen (Dashboard, Sessions, Packages, Services,
//   Schedule, Availability, Income, Booking requests).
//
//   Previously each screen resolved its own "current branch" independently —
//   some read AdminProfileCubit.state.branchId (which was actually populated
//   from the tenant id, not a real branch id — see admin_profile_cubit.dart),
//   others hardcoded `?? 1` as a fallback. Neither reflected the admin's
//   actual branch selection, and changing the branch on one screen had no
//   effect on any other screen.
//
//   `null` means "All branches" — valid only for read-only aggregate views
//   (e.g. the owner's multi-branch dashboard). Any create/update/book screen
//   must require a non-null, tenant-verified branchId before submitting.
//
// USAGE:
//   Provided once at the app root (see app.dart) so the selection survives
//   navigation between screens instead of resetting per-route.
import 'package:flutter_bloc/flutter_bloc.dart';

class BranchContextCubit extends Cubit<int?> {
  BranchContextCubit() : super(null);

  /// Sets the actively selected branch. Pass the real branchId returned by
  /// the backend's branch list — never a hardcoded literal.
  void select(int branchId) => emit(branchId);

  /// "All branches" — only meaningful for read-only aggregate screens.
  void clear() => emit(null);
}
