// =============================================================================
// FILE: member_list_result_entity.dart
// LAYER: Domain Layer → Entities
// PURPOSE: Wraps a paginated page of members in a pure domain object.
//          The BLoC uses this to know if more screens exist (for infinite scroll)
//          and to accumulate screens across MembersStarted events.
//
// POSITION IN FLOW:
//   MemberListResponseModel (data layer)
//     → AdminMembersRepositoryImpl._toResultEntity()
//     → [this file] MemberListResultEntity
//     → GetMembersUseCase returns this to AdminMembersBloc
//     → BLoC emits MembersLoaded with the accumulated list
//
// RELATED FILES:
//   ← Mapped from: member_list_response_model.dart (via repository impl)
//   ← Contains:    List<MemberCardEntity>
//   → Returned by: get_members_use_case.dart
//   → Used by:     admin_members_bloc.dart to build MembersLoaded state
// =============================================================================

import 'member_card_entity.dart';

class MemberListResultEntity {
  /// Members for the current page (NOT cumulative — bloc accumulates them).
  final List<MemberCardEntity> items;

  /// Total matching members across ALL screens.
  final int totalCount;

  /// Current 1-based page number just fetched.
  final int page;

  /// Records-per-page used in this request.
  final int size;

  /// Total number of screens — used to know when infinite scroll should stop.
  final int totalPages;

  const MemberListResultEntity({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.size,
    required this.totalPages,
  });

  /// True when there are more screens to load (used by BLoC for infinite scroll).
  bool get hasNextPage => page < totalPages;
}