// FILE: lib/features/admin/trainers/presentation/widgets/member_picker_for_trainer_sheet.dart
//
// PURPOSE:
//   Bottom sheet that lets an admin search for and pick an existing member,
//   then assign them the TRAINER gym role in one tap.
//
// HOW IT WORKS:
//   1. Opens → fetches first page of members (no filter).
//   2. Admin types in search bar → debounced re-fetch.
//   3. Tapping a member → shows an inline confirmation row.
//   4. Admin taps "Confirm" → calls POST /api/admin/members/{id}/gym-role.
//   5. On success → pops sheet and calls onAssigned() so the parent
//      can reload the trainer list.
//
// SELF-CONTAINED:
//   Manages its own loading/error state. Calls services directly — no BLoC
//   needed since this is a one-off action sheet (same pattern as
//   add_edit_trainer_bottom_sheet.dart).
//
// HOW TO OPEN (from AdminTrainersScreen):
//   MemberPickerForTrainerSheet.show(
//     context,
//     onAssigned: () => context.read<AdminTrainersBloc>().add(const TrainersReload()),
//   );

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../core/config/env.dart';
import '../../../members/data/models/member_card_model.dart';
import '../../../members/data/services/admin_members_service.dart';
import '../../data/services/admin_trainers_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemberPickerForTrainerSheet extends StatefulWidget {
  /// Called after role assignment succeeds, with the assigned member's info.
  final void Function(int userId, String name) onAssigned;

  const MemberPickerForTrainerSheet({super.key, required this.onAssigned});

  // ── Static show helper ─────────────────────────────────────────────────────
  static Future<void> show(
      BuildContext context, {
        required void Function(int userId, String name) onAssigned,
      }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MemberPickerForTrainerSheet(onAssigned: onAssigned),
    );
  }

  @override
  State<MemberPickerForTrainerSheet> createState() =>
      _MemberPickerForTrainerSheetState();
}

class _MemberPickerForTrainerSheetState
    extends State<MemberPickerForTrainerSheet> {
  // ── Services ───────────────────────────────────────────────────────────────
  final _membersService  = AdminMembersService();
  final _trainersService = AdminTrainersService();

  // ── State ──────────────────────────────────────────────────────────────────
  final _searchController = TextEditingController();
  Timer?  _debounce;

  List<MemberCardModel> _members     = [];
  bool    _loading                   = false;
  String? _error;

  // Tracks which userId is currently pending confirmation
  int?    _pendingUserId;

  // Tracks which userId is being assigned (shows spinner on that row)
  int?    _assigningUserId;
  String? _assignError;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _fetchMembers();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  // ── Data ───────────────────────────────────────────────────────────────────

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), _fetchMembers);
  }

  Future<void> _fetchMembers() async {
    setState(() {
      _loading = true;
      _error   = null;
      _pendingUserId  = null;
      _assigningUserId = null;
    });
    try {
      final raw = await _membersService.getMembers(
        branchId: 1,           // branchId=1 loads all — backend ignores it when tenantId scopes
        search:   _searchController.text.trim(),
        size:     30,
        page:     1,
        // includeStaff defaults to false — exclude owners/admins/trainers/reception
        // from the picker so only plain members can be promoted.
      );
      final items = (raw['items'] as List<dynamic>? ?? [])
          .map((j) => MemberCardModel.fromJson(j as Map<String, dynamic>))
          .toList();
      if (mounted) setState(() { _members = items; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = e.toString(); });
    }
  }

  // ── Actions ─────────────────────────────────────────────────────────────────

  void _onMemberTapped(MemberCardModel member) {
    setState(() {
      // Toggle confirmation row — tap again to cancel
      _pendingUserId = (_pendingUserId == member.userId) ? null : member.userId;
      _assignError   = null;
    });
  }

  Future<void> _confirmAssign(MemberCardModel member) async {
    setState(() {
      _assigningUserId = member.userId;
      _assignError     = null;
    });
    try {
      await _trainersService.assignGymRole(member.userId, 'TRAINER');
      if (!mounted) return;
      Navigator.pop(context);
      widget.onAssigned(member.userId, member.fullName);
    } catch (e) {
      if (mounted) {
        setState(() {
          _assigningUserId = null;
          _assignError     = 'Failed to assign role. Please try again.';
        });
      }
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;
    final mq     = MediaQuery.of(context);

    return Container(
      height: mq.size.height * 0.85,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // ── Handle ──────────────────────────────────────────────────────────
          const SizedBox(height: 10),
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: c.border.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // ── Header ──────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: c.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.person_add_alt_1_rounded,
                      color: c.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Promote Member to Trainer',
                        style: TextStyle(
                          color: c.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
                    Text('Pick a member to assign the Trainer role',
                        style: TextStyle(color: c.muted, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Search bar ───────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: c.primary),
              decoration: InputDecoration(
                hintText: 'Search by name or phone…',
                hintStyle: TextStyle(color: c.muted),
                prefixIcon: Icon(Icons.search_rounded, color: c.muted),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear_rounded, color: c.muted),
                  onPressed: () {
                    _searchController.clear();
                    _fetchMembers();
                  },
                )
                    : null,
                filled: true,
                fillColor: c.background,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: c.border.withOpacity(0.2)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: c.border.withOpacity(0.2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: c.primary),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ── Info note ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: c.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: c.primary, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'The member will see the Trainer dashboard the next time they log in.',
                      style: TextStyle(color: c.primary, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // ── Global assign error ──────────────────────────────────────────────
          if (_assignError != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(_assignError!,
                  style: TextStyle(color: c.error ?? Colors.red, fontSize: 12)),
            ),

          // ── List ─────────────────────────────────────────────────────────────
          Expanded(child: _buildList(c, tokens)),

          SizedBox(height: mq.padding.bottom + 8),
        ],
      ),
    );
  }

  Widget _buildList(dynamic c, dynamic tokens) {
    if (_loading) {
      return Center(child: CircularProgressIndicator(color: c.primary));
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, color: c.muted, size: 40),
            const SizedBox(height: 8),
            Text('Could not load members',
                style: TextStyle(color: c.muted)),
            const SizedBox(height: 8),
            TextButton(onPressed: _fetchMembers, child: const Text('Retry')),
          ],
        ),
      );
    }
    if (_members.isEmpty) {
      return Center(
        child: Text('No members found',
            style: TextStyle(color: c.muted)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _members.length,
      itemBuilder: (_, i) => _buildMemberRow(_members[i], c),
    );
  }

  Widget _buildMemberRow(MemberCardModel member, dynamic c) {
    final isPending   = _pendingUserId == member.userId;
    final isAssigning = _assigningUserId == member.userId;

    return Column(
      children: [
        // ── Member row ───────────────────────────────────────────────────────
        InkWell(
          onTap: isAssigning ? null : () => _onMemberTapped(member),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isPending
                  ? c.primary.withOpacity(0.06)
                  : c.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isPending
                    ? c.primary.withOpacity(0.4)
                    : c.border.withOpacity(0.15),
              ),
            ),
            child: Row(
              children: [
                // Avatar with initial
                CircleAvatar(
                  radius: 20,
                  backgroundColor: c.primary.withOpacity(0.15),
                  child: Text(
                    member.fullName.isNotEmpty
                        ? member.fullName[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                        color: c.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
                const SizedBox(width: 12),

                // Name + phone
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(member.fullName,
                          style: TextStyle(
                              color: c.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14)),
                      const SizedBox(height: 2),
                      Text(
                        member.phone.isNotEmpty
                            ? member.phone
                            : member.memberCode,
                        style:
                        TextStyle(color: c.muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),

                // Status chip
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _statusColor(member.membershipStatus, c)
                        .withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    member.membershipStatus.toUpperCase(),
                    style: TextStyle(
                      color: _statusColor(member.membershipStatus, c),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Chevron / loading
                isAssigning
                    ? SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: c.primary),
                )
                    : Icon(
                  isPending
                      ? Icons.expand_less_rounded
                      : Icons.chevron_right_rounded,
                  color: c.muted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),

        // ── Confirmation row (slides in when pending) ────────────────────────
        if (isPending)
          Container(
            margin: const EdgeInsets.only(bottom: 4, left: 8, right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: c.primary.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: Colors.orange, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Assign Trainer role to ${member.fullName}?',
                    style: TextStyle(
                        color: c.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 8),

                // Cancel
                TextButton(
                  onPressed: () =>
                      setState(() => _pendingUserId = null),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                  ),
                  child: Text('Cancel',
                      style: TextStyle(color: c.muted, fontSize: 13)),
                ),

                // Confirm
                ElevatedButton(
                  onPressed: () => _confirmAssign(member),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: c.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Confirm',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Color _statusColor(String status, dynamic c) {
    switch (status.toLowerCase()) {
      case 'active':   return Colors.green;
      case 'expired':  return Colors.red;
      case 'frozen':   return Colors.blue;
      default:         return Colors.grey;
    }
  }
}