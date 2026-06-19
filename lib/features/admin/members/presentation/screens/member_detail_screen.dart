// =============================================================================
// FILE: member_detail_page.dart
// PATH: lib/features/admin/members/presentation/pages/member_detail_page.dart
// TASK: GA-271
//
// Receives userId via constructor.
// Reuses the parent AdminMembersBloc via BlocProvider.of — no new BlocProvider.
// Dispatches MemberDetailRequested on init.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/app_router.dart';
import '../bloc/admin_members_bloc.dart';
import '../../../../../l10n/app_localizations.dart';
import '../widgets/member_info_section_widget.dart';
import '../widgets/membership_package_widget.dart';
import '../widgets/quick_actions_widget.dart';

class MemberDetailPage extends StatefulWidget {
  const MemberDetailPage({super.key, required this.userId});

  final int userId;

  @override
  State<MemberDetailPage> createState() => _MemberDetailPageState();
}

class _MemberDetailPageState extends State<MemberDetailPage> {
  @override
  void initState() {
    super.initState();
    // Dispatch immediately — BLoC already provided by parent AdminMembersPage.
    context.read<AdminMembersBloc>().add(MemberDetailRequested(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(userId: widget.userId),
            Expanded(child: _DetailBody(userId: widget.userId)),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// Top bar: back | title | notification bell
// ===========================================================================

class _TopBar extends StatelessWidget {
  const _TopBar({required this.userId});
  final int userId;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      color: cs.onPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            color: cs.onSurface,
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.admin_members_detailTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
          ),
          // Notification bell placeholder — same as other screens
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(AppRouter.adminNotifications),
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: cs.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                  Icons.notifications_none_rounded,
                  color: cs.onSurfaceVariant, size: 18),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

// ===========================================================================
// Body — driven by AdminMembersBloc detail states
// ===========================================================================

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.userId});
  final int userId;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlocBuilder<AdminMembersBloc, AdminMembersState>(
      buildWhen: (prev, curr) =>
      curr is MemberDetailLoading ||
          curr is MemberDetailLoaded  ||
          curr is MemberDetailError,
      builder: (context, state) {

        if (state is MemberDetailLoading) {
          return Center(child: CircularProgressIndicator(color: cs.primary));
        }

        if (state is MemberDetailError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56, height: 56,
                    decoration: BoxDecoration(
                      color: cs.errorContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.error_outline_rounded,
                        color: cs.error, size: 28),
                  ),
                  const SizedBox(height: 16),
                  Text(state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: cs.onSurface, fontSize: 14)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context
                        .read<AdminMembersBloc>()
                        .add(MemberDetailRequested(userId)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: Text(AppLocalizations.of(context)!.retry),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is MemberDetailLoaded) {
          final member = state.member;
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Member info section (avatar, name, status, phone, gender)
                MemberInfoSectionWidget(member: member),
                const SizedBox(height: 16),
                // 2. Quick actions grid (Call, WhatsApp, SMS, Attendance, Renew, Block)
                QuickActionsWidget(member: member),
                const SizedBox(height: 16),
                // 3. Membership package details
                MembershipPackageWidget(
                    package: member.membershipPackage),
              ],
            ),
          );
        }

        // Fallback — shouldn't be visible
        return const SizedBox.shrink();
      },
    );
  }
}