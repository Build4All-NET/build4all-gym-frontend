import 'dart:async';
import 'dart:convert';

import 'package:build4allgym/common/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../core/config/env.dart';
import '../../../members/data/models/member_card_model.dart';
import '../../../members/data/services/admin_members_service.dart';
import '../../../trainers/data/services/admin_trainers_service.dart';
import '../../../../../l10n/app_localizations.dart';

class MemberPickerForReceptionSheet extends StatefulWidget {
  final VoidCallback onAssigned;

  const MemberPickerForReceptionSheet({super.key, required this.onAssigned});

  static Future<void> show(
      BuildContext context, {
        required VoidCallback onAssigned,
      }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MemberPickerForReceptionSheet(onAssigned: onAssigned),
    );
  }

  @override
  State<MemberPickerForReceptionSheet> createState() =>
      _MemberPickerForReceptionSheetState();
}

class _MemberPickerForReceptionSheetState
    extends State<MemberPickerForReceptionSheet> {
  final _membersService  = AdminMembersService();
  final _trainersService = AdminTrainersService();

  final _searchController = TextEditingController();
  Timer?  _debounce;

  List<MemberCardModel> _members     = [];
  bool    _loading                   = false;
  String? _error;

  int?    _pendingUserId;
  int?    _assigningUserId;
  String? _assignError;

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
        // branchId omitted (null) so every branch's members are searchable
        // when assigning reception staff — a literal branchId is NOT
        // ignored by the backend (it filters by it when present), so
        // hardcoding one would have hidden every other branch's members.
        search:   _searchController.text.trim(),
        size:     30,
        page:     1,
        // A user can hold both the Trainer and Reception roles at once, so
        // include trainers here — otherwise they'd disappear from this picker
        // and couldn't be promoted to Reception too. Owners/admins/business
        // staff and existing Reception users stay hidden.
        includeTrainers: true,
      );
      final items = (raw['items'] as List<dynamic>? ?? [])
          .map((j) => MemberCardModel.fromJson(j as Map<String, dynamic>))
          .toList();
      if (mounted) setState(() { _members = items; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = e.toString(); });
    }
  }

  void _onMemberTapped(MemberCardModel member) {
    setState(() {
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
      await _trainersService.assignGymRole(member.userId, 'RECEPTION');
      if (!mounted) return;
      Navigator.pop(context);
      widget.onAssigned();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.admin_staff_assignedReceptionSuccess(member.fullName),
          ),
          backgroundColor: Colors.green.shade700,
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _assigningUserId = null;
          _assignError     = AppLocalizations.of(context)!.adminMemberPicker_assignRoleFailed;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;
    final mq     = MediaQuery.of(context);
    final l10n   = AppLocalizations.of(context)!;

    return Container(
      height: mq.size.height * 0.85,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: c.border.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

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
                    Text(l10n.admin_staff_assignReceptionTitle,
                        style: TextStyle(
                          color: c.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
                    Text(l10n.admin_staff_assignReceptionSubtitle,
                        style: TextStyle(color: c.muted, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: c.primary),
              decoration: InputDecoration(
                hintText: l10n.adminMemberPicker_searchHint,
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
                      l10n.admin_staff_receptionDashboardNotice,
                      style: TextStyle(color: c.primary, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          if (_assignError != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(_assignError!,
                  style: TextStyle(color: c.error ?? Colors.red, fontSize: 12)),
            ),

          Expanded(child: _buildList(c, tokens, l10n)),

          SizedBox(height: mq.padding.bottom + 8),
        ],
      ),
    );
  }

  Widget _buildList(dynamic c, dynamic tokens, AppLocalizations l10n) {
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
            Text(l10n.adminMemberPicker_couldNotLoad,
                style: TextStyle(color: c.muted)),
            const SizedBox(height: 8),
            TextButton(onPressed: _fetchMembers, child: Text(l10n.retry)),
          ],
        ),
      );
    }
    if (_members.isEmpty) {
      return Center(
        child: Text(l10n.adminMemberPicker_noMembersFound,
            style: TextStyle(color: c.muted)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _members.length,
      itemBuilder: (_, i) => _buildMemberRow(_members[i], c, l10n),
    );
  }

  Widget _buildMemberRow(MemberCardModel member, dynamic c, AppLocalizations l10n) {
    final isPending   = _pendingUserId == member.userId;
    final isAssigning = _assigningUserId == member.userId;

    return Column(
      children: [
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

        if (isPending)
          Container(
            margin: const EdgeInsetsDirectional.only(bottom: 4, start: 8, end: 8),
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
                    l10n.admin_staff_confirmAssignReception(member.fullName),
                    style: TextStyle(
                        color: c.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 8),

                TextButton(
                  onPressed: () =>
                      setState(() => _pendingUserId = null),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                  ),
                  child: Text(l10n.general_cancel,
                      style: TextStyle(color: c.muted, fontSize: 13)),
                ),

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
                  child: Text(l10n.general_confirm,
                      style: const TextStyle(
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
