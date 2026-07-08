import '../../domain/entities/member_membership_entity.dart';
import '../../domain/repositories/member_membership_repository.dart';
import '../services/member_membership_service.dart';

/*
 * Data-layer implementation of MemberMembershipRepository.
 *
 * Flow:
 *
 * BLoC
 * -> Use case
 * -> MemberMembershipRepository
 * -> MemberMembershipRepositoryImpl
 * -> MemberMembershipService
 * -> GET /api/member/memberships
 */
class MemberMembershipRepositoryImpl
    implements MemberMembershipRepository {
  final MemberMembershipService _service;

  const MemberMembershipRepositoryImpl(
      this._service,
      );

  /*
   * Loads all memberships for the currently authenticated member.
   *
   * userId and tenantId are not passed from Flutter.
   * The backend extracts them from the JWT.
   */
  @override
  Future<List<MemberMembershipEntity>> getMemberships({
    String? status,
  }) async {
    final models = await _service.getMemberships(
      status: status,
    );

    /*
     * MemberMembershipModel extends MemberMembershipEntity,
     * but we return a domain-typed list so the presentation layer
     * does not depend on data-layer models.
     */
    return List<MemberMembershipEntity>.from(models);
  }
}