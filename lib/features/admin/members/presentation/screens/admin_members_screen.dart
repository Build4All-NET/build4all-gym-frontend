// =============================================================================
// FILE: admin_members_page.dart
// LAYER: Presentation Layer → Pages
//
// CHANGES:
//   • Header redesigned to match AdminDashboardScreen exactly:
//       hamburger | branch pill (Expanded) | "Members" title | Spacer | bell
//   • All hardcoded colors replaced with Theme.of(context).colorScheme
//     so they are driven by the backend theme (ThemeCubit → ThemeData).
//   • branchName + address accepted as constructor params — no more hardcoding.
//   • SubtitleRow removed — branch name now lives inside the pill itself.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/app_router.dart';
import '../../../../../core/error/backend_error_code_translator.dart';
import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../../navigation/presentation/widgets/admin_navigation_drawer.dart';
import '../../../../../l10n/app_localizations.dart';
import '../bloc/admin_members_bloc.dart';
import '../widgets/member_card_widget.dart';
import '../widgets/members_filter_bar_widget.dart';
import '../widgets/members_search_bar_widget.dart';

// ===========================================================================
// Entry-point widget
// ===========================================================================

class AdminMembersPage extends StatelessWidget {
  const AdminMembersPage({
    super.key,
    required this.bloc,
    required this.branchId,
    required this.branchName, // ← no longer hardcoded
    this.address = '',
  });

  final AdminMembersBloc bloc;
  final int    branchId;
  final String branchName;
  final String address;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminMembersBloc>.value(
      value: bloc..add(MembersStarted(branchId: branchId, page: 1)),
      child: _AdminMembersView(
        branchId:   branchId,
        branchName: branchName,
        address:    address,
      ),
    );
  }
}

// ===========================================================================
// Internal view
// ===========================================================================

class _AdminMembersView extends StatelessWidget {
  const _AdminMembersView({
    required this.branchId,
    required this.branchName,
    required this.address,
  });

  final int    branchId;
  final String branchName;
  final String address;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final profile = context.watch<AdminProfileCubit>().state;

    return Scaffold(
      drawer: SafeArea(
        child: AdminNavigationDrawer(
        gymName:    profile.gymName,
        branchName: profile.branchName,
        adminName:  profile.adminName,
        adminEmail: profile.adminEmail,
        avatarUrl:  profile.avatarUrl,
        initialActiveId: 'members',
      ),
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header — same structure as AdminDashboardScreen ────────────
            _MembersAppBar(branchName: branchName),

            // ── Search ─────────────────────────────────────────────────────
            const MembersSearchBarWidget(),

            const SizedBox(height: 4),

            // ── Filters ────────────────────────────────────────────────────
            const MembersFilterBarWidget(),

            const SizedBox(height: 4),

            // ── Body ───────────────────────────────────────────────────────
            Expanded(child: _MembersBody(branchId: branchId)),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// Header — mirrors AdminDashboardScreen._buildAppBar() exactly.
//
// Layout: [hamburger] [branch pill — Expanded] [Members] [Spacer] [bell]
// ===========================================================================

class _MembersAppBar extends StatelessWidget {
  const _MembersAppBar({required this.branchName});

  final String branchName;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      color: cs.onPrimary, // white — same as dashboard
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Hamburger — same as dashboard
          Builder(
            builder: (ctx) => IconButton(
              icon:      const Icon(Icons.menu_rounded),
              color:     cs.onSurface,
              onPressed: () => Scaffold.of(ctx).openDrawer(),
            ),
          ),

          const SizedBox(width: 10),

          // Branch pill — same visual style as dashboard
          Expanded(child: _BranchPill(branchName: branchName)),

          // Screen title — same style as dashboard's "Dashboard" text
          Text(
            AppLocalizations.of(context)!.navMembers,
            style: TextStyle(
              fontSize:   17,
              fontWeight: FontWeight.w700,
              color:      cs.onSurface,
            ),
          ),

          const Spacer(),

          // Notification bell — same widget as dashboard
          const _NotificationBell(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Branch pill — identical look to dashboard's branch PopupMenuButton pill.
// Color is tinted from cs.primary (same formula as dashboard's 0xFFEFF6FF).
// ---------------------------------------------------------------------------

class _BranchPill extends StatelessWidget {
  const _BranchPill({required this.branchName});

  final String branchName;

  @override
  Widget build(BuildContext context) {
    final cs      = Theme.of(context).colorScheme;
    final pillBg  = cs.primary.withOpacity(0.08); // light tint like dashboard
    final pillFg  = cs.primary;

    return GestureDetector(
      onTap: () {
        // TODO: show branch picker → dispatch MembersStarted(branchId: newId)
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color:        pillBg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on_rounded, size: 14, color: pillFg),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                branchName,
                style: TextStyle(
                  fontSize:   13,
                  fontWeight: FontWeight.w600,
                  color:      pillFg,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 3),
            Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: pillFg),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Notification bell — identical to dashboard's bell.
// ---------------------------------------------------------------------------

class _NotificationBell extends StatelessWidget {
  const _NotificationBell();

  // TODO: drive count from a notifications BLoC.
  static const int _count = 0;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(AppRouter.adminNotifications),
      child: Stack(
        children: [
          Container(
            width:  36,
            height: 36,
            decoration: BoxDecoration(
              color:        cs.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              color: cs.onSurfaceVariant,
              size:  18,
            ),
          ),
          if (_count > 0)
            PositionedDirectional(
              top: 2,
              end: 2,
              child: Container(
                width:  16,
                height: 16,
                decoration: BoxDecoration(
                  color: cs.error,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    _count > 99 ? '99+' : '$_count',
                    style: const TextStyle(
                      color:      Colors.white,
                      fontSize:   9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ===========================================================================
// _MembersBody — StatefulWidget caching last MembersLoaded.
// ===========================================================================

class _MembersBody extends StatefulWidget {
  const _MembersBody({required this.branchId});

  final int branchId;

  @override
  State<_MembersBody> createState() => _MembersBodyState();
}

class _MembersBodyState extends State<_MembersBody> {
  MembersLoaded? _lastLoaded;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlocBuilder<AdminMembersBloc, AdminMembersState>(
      builder: (context, state) {
        if (state is MembersLoaded) _lastLoaded = state;

        if (state is MembersInitial || state is MembersLoading) {
          return Center(
            child: CircularProgressIndicator(color: cs.primary),
          );
        }

        if (state is MembersError && _lastLoaded == null) {
          return _buildError(
              context, translateBackendErrorCode(AppLocalizations.of(context)!, state.errorCode));
        }

        final loaded = _lastLoaded;

        if (loaded == null) {
          return Center(child: CircularProgressIndicator(color: cs.primary));
        }

        if (loaded.members.isEmpty) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.admin_members_noMembers,
              style: TextStyle(
                color:    cs.onSurface.withOpacity(0.4),
                fontSize: 14,
              ),
            ),
          );
        }
        return _MembersList(state: loaded, branchId: widget.branchId);
      },
    );
  }

  Widget _buildError(BuildContext context, String message) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Same error container style as dashboard
            Container(
              width:  56,
              height: 56,
              decoration: BoxDecoration(
                color:        cs.errorContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.error_outline_rounded, color: cs.error, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: cs.onSurface, fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context
                  .read<AdminMembersBloc>()
                  .add(MembersStarted(branchId: widget.branchId, page: 1)),
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: cs.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// Infinite-scroll list
// ===========================================================================

class _MembersList extends StatefulWidget {
  const _MembersList({required this.state, required this.branchId});

  final MembersLoaded state;
  final int           branchId;

  @override
  State<_MembersList> createState() => _MembersListState();
}

class _MembersListState extends State<_MembersList> {
  late final ScrollController _scroll;
  bool _isPaginating = false;

  @override
  void initState() {
    super.initState();
    _scroll = ScrollController()..addListener(_onScroll);
  }

  @override
  void didUpdateWidget(_MembersList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.currentPage != widget.state.currentPage) {
      _isPaginating = false;
    }
  }

  @override
  void dispose() {
    _scroll
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxExtent = _scroll.position.maxScrollExtent;
    final current   = _scroll.offset;
    const threshold = 250.0;

    if (current >= maxExtent - threshold &&
        widget.state.hasNextPage &&
        !_isPaginating) {
      _isPaginating = true;
      context.read<AdminMembersBloc>().add(
        MembersStarted(
          branchId: widget.branchId,
          page:     widget.state.currentPage + 1,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs         = Theme.of(context).colorScheme;
    final members    = widget.state.members;
    final showFooter = widget.state.hasNextPage;

    return ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.only(top: 4, bottom: 24),
      itemCount: members.length + (showFooter ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == members.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color:       cs.primary,
              ),
            ),
          );
        }
        return MemberCardWidget(member: members[index]);
      },
    );
  }
}