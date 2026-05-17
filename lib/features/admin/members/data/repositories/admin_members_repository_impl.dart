// =============================================================================
// FILE: admin_members_repository_impl.dart
// PATH: lib/features/admin/members/data/repositories/admin_members_repository_impl.dart
// LAYER: Data Layer → Repositories (Concrete)
// TASK: GA-268 — added getMemberDetail()
// =============================================================================

import '../../../../../core/error/exceptions.dart';
import '../../domain/entities/member_attendance_item_entity.dart';
import '../../domain/entities/member_card_entity.dart';
import '../../domain/entities/member_detail_entity.dart';
import '../../domain/entities/member_list_result_entity.dart';
import '../../domain/entities/membership_package_entity.dart';
import '../../domain/repositories/admin_members_repository.dart';
import '../models/member_attendance_item_model.dart';
import '../models/member_card_model.dart';
import '../models/member_detail_model.dart';
import '../models/member_list_response_model.dart';
import '../models/membership_package_model.dart';
import '../services/admin_members_service.dart';

class AdminMembersRepositoryImpl implements AdminMembersRepository {
  final AdminMembersService service;

  AdminMembersRepositoryImpl({required this.service});

  // ---------------------------------------------------------------------------
  // getMembers (unchanged)
  // ---------------------------------------------------------------------------
  @override
  Future<MemberListResultEntity> getMembers({
    required int branchId,
    String status = '',
    String gender = '',
    String search = '',
    String sort   = 'newest',
    int page      = 1,
    int size      = 10,
  }) async {
    try {
      final json = await service.getMembers(
        branchId: branchId, status: status, gender: gender,
        search: search, sort: sort, page: page, size: size,
      );
      return _toResultEntity(MemberListResponseModel.fromJson(json));
    } on UnauthorizedException {
      throw Exception('Session expired. Please log in again.');
    } on ForbiddenException {
      throw Exception('You do not have permission to view members.');
    } on ServerException catch (e) {
      throw Exception('Server error: ${e.message}');
    } on NetworkException {
      throw Exception('No internet connection. Please try again.');
    }
  }

  // ---------------------------------------------------------------------------
  // getMemberDetail — GA-268
  // ---------------------------------------------------------------------------
  @override
  Future<MemberDetailEntity> getMemberDetail(int userId) async {
    try {
      final model = await service.getMemberDetail(userId);
      return _toDetailEntity(model);
    } on UnauthorizedException {
      throw Exception('Session expired. Please log in again.');
    } on ForbiddenException {
      throw Exception('You do not have permission to view this member.');
    } on ServerException catch (e) {
      throw Exception('Server error: ${e.message}');
    } on NetworkException {
      throw Exception('No internet connection. Please try again.');
    }
  }

  // ---------------------------------------------------------------------------
  // getMemberAttendance
  // ---------------------------------------------------------------------------
  @override
  Future<List<MemberAttendanceItemEntity>> getMemberAttendance(int userId) async {
    try {
      final models = await service.getMemberAttendance(userId);
      return models.map((m) => MemberAttendanceItemEntity(
        checkinId:       m.checkinId,
        date:            m.date,
        checkinTime:     m.checkinTime,
        checkoutTime:    m.checkoutTime,
        durationMinutes: m.durationMinutes,
        status:          m.status,
        checkinType:     m.checkinType,
      )).toList();
    } on UnauthorizedException {
      throw Exception('Session expired. Please log in again.');
    } on ForbiddenException {
      throw Exception('You do not have permission to view attendance.');
    } on ServerException catch (e) {
      throw Exception('Server error: ${e.message}');
    } on NetworkException {
      throw Exception('No internet connection.');
    }
  }

  // ---------------------------------------------------------------------------
  // blockMember (unchanged)
  // ---------------------------------------------------------------------------
  @override
  Future<void> blockMember(int userId, String reason) async {
    try {
      await service.blockMember(userId, reason);
    } on UnauthorizedException {
      throw Exception('Session expired. Please log in again.');
    } on ServerException catch (e) {
      throw Exception('Failed to block member: ${e.message}');
    } on NetworkException {
      throw Exception('No internet connection.');
    }
  }

  // ---------------------------------------------------------------------------
  // unblockMember (unchanged)
  // ---------------------------------------------------------------------------
  @override
  Future<void> unblockMember(int userId) async {
    try {
      await service.unblockMember(userId);
    } on UnauthorizedException {
      throw Exception('Session expired. Please log in again.');
    } on ServerException catch (e) {
      throw Exception('Failed to unblock member: ${e.message}');
    } on NetworkException {
      throw Exception('No internet connection.');
    }
  }

  // ---------------------------------------------------------------------------
  // deleteMember (unchanged)
  // ---------------------------------------------------------------------------
  @override
  Future<void> deleteMember(int userId) async {
    try {
      await service.deleteMember(userId);
    } on UnauthorizedException {
      throw Exception('Session expired. Please log in again.');
    } on ServerException catch (e) {
      throw Exception('Failed to delete member: ${e.message}');
    } on NetworkException {
      throw Exception('No internet connection.');
    }
  }

  // ---------------------------------------------------------------------------
  // bulkDeleteMembers (unchanged)
  // ---------------------------------------------------------------------------
  @override
  Future<void> bulkDeleteMembers(List<int> userIds) async {
    try {
      await service.bulkDeleteMembers(userIds);
    } on UnauthorizedException {
      throw Exception('Session expired. Please log in again.');
    } on ServerException catch (e) {
      throw Exception('Failed to bulk delete: ${e.message}');
    } on NetworkException {
      throw Exception('No internet connection.');
    }
  }

  // ===========================================================================
  // Mapping helpers
  // ===========================================================================

  MemberListResultEntity _toResultEntity(MemberListResponseModel model) {
    return MemberListResultEntity(
      items:      model.items.map(_toCardEntity).toList(),
      totalCount: model.totalCount,
      page:       model.page,
      size:       model.size,
      totalPages: model.totalPages,
    );
  }

  MemberCardEntity _toCardEntity(MemberCardModel model) {
    return MemberCardEntity(
      userId:           model.userId,
      fullName:         model.fullName,
      memberCode:       model.memberCode,
      phone:            model.phone,
      profileFileId:    model.profileFileId,
      membershipStatus: model.membershipStatus,
      planName:         model.planName,
      expiryDate:       model.expiryDate,
      dueAmount:        model.dueAmount,
      branchName:       model.branchName,
    );
  }

  MemberDetailEntity _toDetailEntity(MemberDetailModel model) {
    return MemberDetailEntity(
      userId:           model.userId,
      fullName:         model.fullName,
      phone:            model.phone,
      profileFileId:    model.profileFileId?.toString(),
      membershipStatus: model.membershipStatus,
      trainingType:     model.trainingType,
      gender:           model.gender,
      membershipPackage: _toPackageEntity(model.membershipPackage),
    );
  }

  MembershipPackageEntity _toPackageEntity(MembershipPackageModel model) {
    return MembershipPackageEntity(
      planName:      model.planName,
      totalAmount:   model.totalAmount,
      discountAmount: model.discountAmount,
      purchaseDate:  model.purchaseDate,
      paidAmount:    model.paidAmount,
      dueAmount:     model.dueAmount,
      remainingDays: model.remainingDays,
    );
  }
}