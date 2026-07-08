import '../entities/member_membership_entity.dart';

/*
 * Domain contract for loading memberships that belong
 * to the currently authenticated member.
 *
 * The domain layer does not know:
 * - Dio
 * - API URLs
 * - JWT tokens
 * - JSON models
 *
 * These details are handled by the data layer.
 */
abstract class MemberMembershipRepository {
  /*
   * Loads all memberships for the logged-in user.
   *
   * The backend extracts userId and tenantId from the JWT.
   *
   * The optional status can be used later to filter memberships,
   * for example:
   *
   * ACTIVE
   * EXPIRED
   * CANCELLED
   *
   * When status is null, all memberships are returned.
   */
  Future<List<MemberMembershipEntity>> getMemberships({
    String? status,
  });
}