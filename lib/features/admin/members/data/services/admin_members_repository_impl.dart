// =============================================================================
// FILE: admin_members_repository_impl.dart
// LAYER: Data Layer → Repositories (Concrete Implementation)
// PURPOSE: Implements the AdminMembersRepository contract from the domain layer.
//          Bridges the gap between:
//            - The service (raw HTTP + JSON)
//            - The domain (pure entities + abstract repo)
//          Responsibilities:
//            1. Calls AdminMembersService for HTTP I/O
//            2. Parses raw JSON → Models (fromJson)
//            3. Maps Models → Entities (_toEntity helpers)
//            4. Catches HTTP exceptions → domain-level exceptions
//
// POSITION IN FLOW:
//   Use Case.call()
//     → AdminMembersRepository.getMembers()   ← abstract interface
//     → [this file] AdminMembersRepositoryImpl.getMembers()
//         → AdminMembersService.getMembers()  ← HTTP
//         ← raw JSON Map
//         → MemberListResponseModel.fromJson(json)
//         → _toResultEntity(model)
//     ← MemberListResultEntity returned up the chain
//
// RELATED FILES:
//   ← Implements:   admin_members_repository.dart  (domain abstract)
//   → Uses:         admin_members_service.dart      (HTTP layer)
//   → Uses models:  member_list_response_model.dart, member_card_model.dart
//   → Returns:      member_list_result_entity.dart, member_card_entity.dart
// =============================================================================

import '../../domain/entities/member_card_entity.dart';
import '../../domain/entities/member_list_result_entity.dart';
import '../../domain/repositories/admin_members_repository.dart';
import '../models/member_card_model.dart';
import '../models/member_list_response_model.dart';
import '../services/admin_members_service.dart';

class AdminMembersRepositoryImpl implements AdminMembersRepository {
  final AdminMembersService service;

  AdminMembersRepositoryImpl({required this.service});

  // ---------------------------------------------------------------------------
  // getMembers — fetches paginated member list, maps to entities.
  // ---------------------------------------------------------------------------
  @override
  Future<MemberListResultEntity> getMembers({
    required int branchId,
    String status = '',
    String gender = '',
    String search = '',
    String sort = 'newest',
    int page = 1,
    int size = 10,
  }) async {
    try {
      final json = await service.getMembers(
        branchId: branchId,
        status: status,
        gender: gender,
        search: search,
        sort: sort,
        page: page,
        size: size,
      );

      // Parse JSON envelope → response model → result entity.
      final responseModel = MemberListResponseModel.fromJson(json);
      return _toResultEntity(responseModel);
    } catch (e) {
      // Re-throw as a domain-level exception so BLoC can show a clean message.
      throw Exception('Failed to load members: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // blockMember — sends block request, expects updated member JSON in response.
  // ---------------------------------------------------------------------------
  @override
  Future<MemberCardEntity> blockMember(int userId, String reason) async {
    try {
      // Your API might return the updated member or just 200 OK.
      // Adjust based on your actual backend response shape.
      await service.blockMember(userId, reason);
      // TODO: If API returns updated member JSON, parse and return it.
      // For now we return a placeholder — replace with real response mapping.
      throw UnimplementedError('Map the API response to MemberCardEntity.');
    } catch (e) {
      throw Exception('Failed to block member: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // unblockMember — sends unblock request, returns updated member entity.
  // ---------------------------------------------------------------------------
  @override
  Future<MemberCardEntity> unblockMember(int userId) async {
    try {
      await service.unblockMember(userId);
      // TODO: Map API response to MemberCardEntity.
      throw UnimplementedError('Map the API response to MemberCardEntity.');
    } catch (e) {
      throw Exception('Failed to unblock member: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // deleteMember — sends delete request. Returns void (card removed from list).
  // ---------------------------------------------------------------------------
  @override
  Future<void> deleteMember(int userId) async {
    try {
      await service.deleteMember(userId);
    } catch (e) {
      throw Exception('Failed to delete member: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // bulkDeleteMembers — deletes multiple members in one request.
  // ---------------------------------------------------------------------------
  @override
  Future<void> bulkDeleteMembers(List<int> userIds) async {
    try {
      await service.bulkDeleteMembers(userIds);
    } catch (e) {
      throw Exception('Failed to bulk delete members: $e');
    }
  }

  // ===========================================================================
  // Private mapping helpers — convert data models → domain entities.
  // Kept here because the mapping concern belongs to the data→domain boundary.
  // ===========================================================================

  /// Maps MemberListResponseModel (data) → MemberListResultEntity (domain).
  MemberListResultEntity _toResultEntity(MemberListResponseModel model) {
    return MemberListResultEntity(
      items: model.items.map(_toEntity).toList(),
      totalCount: model.totalCount,
      page: model.page,
      size: model.size,
      totalPages: model.totalPages,
    );
  }

  /// Maps a single MemberCardModel (data) → MemberCardEntity (domain).
  MemberCardEntity _toEntity(MemberCardModel model) {
    return MemberCardEntity(
      userId: model.userId,
      fullName: model.fullName,
      memberCode: model.memberCode,
      phone: model.phone,
      profileFileId: model.profileFileId,
      membershipStatus: model.membershipStatus,
      planName: model.planName,
      expiryDate: model.expiryDate,
      dueAmount: model.dueAmount,
      branchName: model.branchName,
    );
  }
}