import '../entities/member_membership_entity.dart';
import '../repositories/member_membership_repository.dart';

/*
 * Use case responsible for loading memberships
 * for the currently authenticated member.
 *
 * The use case keeps the BLoC independent from:
 * - The repository implementation
 * - HTTP requests
 * - JSON models
 * - JWT storage
 */
class GetMemberMembershipsUseCase {
  final MemberMembershipRepository _repository;

  const GetMemberMembershipsUseCase(
      this._repository,
      );

  /*
   * Loads all memberships when status is null.
   *
   * A status can optionally be provided later, for example:
   *
   * ACTIVE
   * EXPIRED
   * CANCELLED
   */
  Future<List<MemberMembershipEntity>> call({
    String? status,
  }) {
    return _repository.getMemberships(
      status: status,
    );
  }
}