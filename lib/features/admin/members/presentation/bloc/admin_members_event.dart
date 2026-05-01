// =============================================================================
// FILE: admin_members_event.dart
// PATH: lib/features/admin/members/presentation/bloc/admin_members_event.dart
// TASK: GA-270 — added MemberDetailRequested
// =============================================================================

part of 'admin_members_bloc.dart';

abstract class AdminMembersEvent {
  const AdminMembersEvent();
}

class MembersStarted extends AdminMembersEvent {
  final int branchId;
  final int page;
  const MembersStarted({required this.branchId, this.page = 1});
}

class MembersSearchChanged extends AdminMembersEvent {
  final String query;
  const MembersSearchChanged(this.query);
}

class MembersStatusFilterChanged extends AdminMembersEvent {
  final String status;
  const MembersStatusFilterChanged(this.status);
}

class MembersSortChanged extends AdminMembersEvent {
  final String sort;
  const MembersSortChanged(this.sort);
}

class MembersGenderFilterChanged extends AdminMembersEvent {
  final String gender;
  const MembersGenderFilterChanged(this.gender);
}

// GA-270: Dispatched when admin taps a member card.
class MemberDetailRequested extends AdminMembersEvent {
  final int userId;
  const MemberDetailRequested(this.userId);
}

class MemberBlockRequested extends AdminMembersEvent {
  final int    userId;
  final String reason;
  const MemberBlockRequested({required this.userId, required this.reason});
}

class MemberUnblockRequested extends AdminMembersEvent {
  final int userId;
  const MemberUnblockRequested(this.userId);
}

class MemberDeleteRequested extends AdminMembersEvent {
  final int userId;
  const MemberDeleteRequested(this.userId);
}

class MembersBulkDeleteRequested extends AdminMembersEvent {
  final List<int> userIds;
  const MembersBulkDeleteRequested(this.userIds);
}