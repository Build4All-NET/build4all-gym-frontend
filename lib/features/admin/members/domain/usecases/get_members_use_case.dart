// =============================================================================
// FILE: get_members_use_case.dart
// LAYER: Domain Layer → Use Cases
// PURPOSE: Single-responsibility class for fetching the paginated member list.
//          Sits between the BLoC and the repository. The BLoC only talks to
//          usecases — never directly to the repository or service.
//          Holds no state; just orchestrates the call and returns the result.
//
// POSITION IN FLOW:
//   AdminMembersBloc (on MembersStarted event)
//     → [this file] GetMembersUseCase.call(...)
//     → AdminMembersRepository.getMembers(...)   ← abstract
//     ← AdminMembersRepositoryImpl does HTTP + mapping
//     ← MemberListResultEntity returned to BLoC
//
// RELATED FILES:
//   → Depends on: admin_members_repository.dart (abstract)
//   ← Called by:  admin_members_bloc.dart (_onMembersStarted)
// =============================================================================

import '../entities/member_list_result_entity.dart';
import '../repositories/admin_members_repository.dart';

class GetMembersUseCase {
  final AdminMembersRepository repository;

  GetMembersUseCase(this.repository);

  /// The single entry point. Named `call` so we can invoke it as `useCase(...)`.
  Future<MemberListResultEntity> call({
    required int branchId,
    String status = '',
    String gender = '',
    String search = '',
    String sort = 'newest',
    int page = 1,
    int size = 10,
  }) {
    return repository.getMembers(
      branchId: branchId,
      status: status,
      gender: gender,
      search: search,
      sort: sort,
      page: page,
      size: size,
    );
  }
}

