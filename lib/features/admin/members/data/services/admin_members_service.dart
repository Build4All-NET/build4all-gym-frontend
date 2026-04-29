// =============================================================================
// FILE: admin_members_service.dart
// LAYER: Data Layer → Services
// PURPOSE: Makes raw HTTP calls to the backend members API.
//          Only responsible for network I/O — no business logic here.
//          Returns decoded JSON Maps; the repository impl converts those
//          into models and then into entities.
//
// POSITION IN FLOW:
//   AdminMembersBloc (event)
//     → UseCase.call()
//     → AdminMembersRepositoryImpl.getMembers(...)
//         → [this file] AdminMembersService.getMembers(...)  ← HTTP call
//             ← raw JSON Map returned
//         ← MemberListResponseModel.fromJson(json)
//     ← MemberListResultEntity returned to BLoC
//
// RELATED FILES:
//   ← Called by:    admin_members_repository_impl.dart
//   → Returns raw JSON consumed by: member_list_response_model.dart
//   ↑ Depends on:   your existing ApiClient (adjust import path as needed)
// =============================================================================

// TODO: Replace this import with your actual ApiClient path.
// import '../../../core/network/api_client.dart';

/// Service class that encapsulates all HTTP calls for the Admin Members feature.
/// Inject this via your DI system (e.g. get_it) into the repository impl.
class AdminMembersService {
  // The shared HTTP client that handles base URL, auth headers, token refresh, etc.
  // Replace `dynamic` with your actual ApiClient type.
  final dynamic apiClient;

  AdminMembersService({required this.apiClient});

  // ---------------------------------------------------------------------------
  // GET /api/admin/members
  // Fetches a paginated, filtered list of members.
  //
  // Parameters:
  //   branchId  — filter to a specific branch (required by API)
  //   status    — "active" | "pending" | "blocked" | "" (all)
  //   gender    — "male" | "female" | "other" | "" (all)
  //   search    — free-text search on name, phone, member code
  //   sort      — "newest" | "oldest" | "alphabetical"
  //   page      — 1-based page number
  //   size      — records per page (default 10)
  //
  // Returns raw decoded JSON map (the full envelope with items + pagination).
  // ---------------------------------------------------------------------------
  Future<Map<String, dynamic>> getMembers({
    required int branchId,
    String status = '',
    String gender = '',
    String search = '',
    String sort = 'newest',
    int page = 1,
    int size = 10,
  }) async {
    // Build query parameters — omit empty values so API isn't sent blank strings.
    final queryParams = <String, String>{
      'branchId': branchId.toString(),
      'page': page.toString(),
      'size': size.toString(),
      'sort': sort,
      if (status.isNotEmpty) 'status': status,
      if (gender.isNotEmpty) 'gender': gender,
      if (search.isNotEmpty) 'search': search,
    };

    // TODO: Replace with your actual apiClient.get() call.
    // Example:
    //   final response = await apiClient.get(
    //     '/api/admin/members',
    //     queryParameters: queryParams,
    //   );
    //   return response.data as Map<String, dynamic>;

    // Placeholder — remove when wiring real ApiClient.
    throw UnimplementedError('Wire up your ApiClient here.');
  }

  // ---------------------------------------------------------------------------
  // PATCH /api/admin/members/{userId}/block
  // Blocks a member and records a reason.
  //
  // Parameters:
  //   userId — the member to block
  //   reason — required reason string shown to member / stored in audit log
  // ---------------------------------------------------------------------------
  Future<void> blockMember(int userId, String reason) async {
    // TODO: Replace with your actual apiClient.patch() call.
    // await apiClient.patch(
    //   '/api/admin/members/$userId/block',
    //   data: {'reason': reason},
    // );
    throw UnimplementedError('Wire up your ApiClient here.');
  }

  // ---------------------------------------------------------------------------
  // PATCH /api/admin/members/{userId}/unblock
  // Re-activates a previously blocked member.
  // ---------------------------------------------------------------------------
  Future<void> unblockMember(int userId) async {
    // TODO: Replace with your actual apiClient.patch() call.
    // await apiClient.patch('/api/admin/members/$userId/unblock');
    throw UnimplementedError('Wire up your ApiClient here.');
  }

  // ---------------------------------------------------------------------------
  // DELETE /api/admin/members/{userId}
  // Permanently deletes a single member record.
  // ---------------------------------------------------------------------------
  Future<void> deleteMember(int userId) async {
    // TODO: Replace with your actual apiClient.delete() call.
    // await apiClient.delete('/api/admin/members/$userId');
    throw UnimplementedError('Wire up your ApiClient here.');
  }

  // ---------------------------------------------------------------------------
  // DELETE /api/admin/members/bulk
  // Deletes multiple members in one request.
  //
  // Parameters:
  //   userIds — list of member IDs to delete
  // ---------------------------------------------------------------------------
  Future<void> bulkDeleteMembers(List<int> userIds) async {
    // TODO: Replace with your actual apiClient.delete() call.
    // await apiClient.delete(
    //   '/api/admin/members/bulk',
    //   data: {'userIds': userIds},
    // );
    throw UnimplementedError('Wire up your ApiClient here.');
  }
}