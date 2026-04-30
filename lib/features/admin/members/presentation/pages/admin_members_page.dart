// =============================================================================
// FILE: admin_members_page.dart
// LAYER: Presentation Layer → Pages
// PURPOSE: Main admin members screen.
//
// LAYOUT (top → bottom):
//   • Dark Scaffold (0xFF0F1117)
//   • Top bar  : hamburger | branch selector chip | trash | notification bell
//   • Subtitle : "Viewing · <branch> · <address>"
//   • MembersSearchBarWidget
//   • MembersFilterBarWidget
//   • Body (BlocBuilder):
//       MembersInitial / MembersLoading → full-screen spinner
//       MembersLoaded                  → ListView of MemberCardWidget
//                                        + pagination footer when hasNextPage
//       MembersError                   → error message + retry button
//
// WIRING:
//   AdminMembersBloc requires constructor-injected use cases + branchId,
//   so it must be built externally (e.g. get_it). Pass it via [bloc].
//   This page wraps it with BlocProvider.value and immediately dispatches
//   MembersStarted(branchId, page: 1).
//
// RELATED FILES:
//   → bloc/admin_members_bloc.dart
//   → bloc/admin_members_event.dart   (part of bloc file)
//   → bloc/admin_members_state.dart   (part of bloc file)
//   → widgets/member_card_widget.dart
//   → widgets/members_search_bar_widget.dart
//   → widgets/members_filter_bar_widget.dart
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/admin_members_bloc.dart';
import '../widgets/member_card_widget.dart';
import '../widgets/members_filter_bar_widget.dart';
import '../widgets/members_search_bar_widget.dart';

// ---------------------------------------------------------------------------
// Design tokens shared within this file.
// ---------------------------------------------------------------------------
const _kAccent  = Color(0xFF6C8EEF);
const _kSurface = Color(0xFF1E2230);
const _kBorder  = Color(0xFF2E3348);
const _kBg      = Color(0xFF0F1117);

// ===========================================================================
// Entry-point widget
// ===========================================================================

/// Pass the DI-provided [bloc] and the current [branchId].
///
/// Example (router / parent widget):
/// ```dart
/// AdminMembersPage(
///   bloc: getIt<AdminMembersBloc>(),
///   branchId: 3,
/// )
/// ```
class AdminMembersPage extends StatelessWidget {
  const AdminMembersPage({
    super.key,
    required this.bloc,
    required this.branchId,
  });

  final AdminMembersBloc bloc;
  final int branchId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminMembersBloc>.value(
      // Dispatch initial load immediately after providing the bloc.
      value: bloc..add(MembersStarted(branchId: branchId, page: 1)),
      child: _AdminMembersView(branchId: branchId),
    );
  }
}

// ===========================================================================
// Internal view — has access to the BlocProvider above.
// ===========================================================================

class _AdminMembersView extends StatelessWidget {
  const _AdminMembersView({required this.branchId});

  final int branchId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Top bar ───────────────────────────────────────────────────
            _TopBar(branchId: branchId),

            // ── Subtitle row ──────────────────────────────────────────────
            // TODO: replace static strings with real branch data once you
            //       include a branch entity inside MembersLoaded.
            const _SubtitleRow(
              branchName: 'Main Branch',
              address: '123 Fitness St.',
            ),

            const SizedBox(height: 12),

            // ── Search bar ────────────────────────────────────────────────
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: MembersSearchBarWidget(),
            ),

            const SizedBox(height: 4),

            // ── Filter bar ────────────────────────────────────────────────
            const MembersFilterBarWidget(),

            const SizedBox(height: 4),

            // ── Body ──────────────────────────────────────────────────────
            Expanded(child: _MembersBody(branchId: branchId)),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// Top bar
// ===========================================================================

class _TopBar extends StatelessWidget {
  const _TopBar({required this.branchId});

  final int branchId;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          // Hamburger
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            tooltip: 'Menu', // TODO: AppLocalizations.of(context).menu
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),

          // Branch chip — centered
          const Expanded(child: _BranchChip()),

          // Bulk-delete trash
          // TODO: track selectedIds in your state and pass them here.
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white54),
            tooltip: 'Bulk Delete', // TODO: l10n
            onPressed: () {
              // Example when you add selection to MembersLoaded:
              // final state = context.read<AdminMembersBloc>().state;
              // if (state is MembersLoaded && state.selectedIds.isNotEmpty) {
              //   context.read<AdminMembersBloc>()
              //     .add(MembersBulkDeleteRequested(state.selectedIds));
              // }
            },
          ),

          // Notification bell
          _NotificationBell(isRtl: isRtl),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Branch selector chip
// ---------------------------------------------------------------------------

class _BranchChip extends StatelessWidget {
  const _BranchChip();

  @override
  Widget build(BuildContext context) {
    // TODO: Drive branchName from your branch entity / DI once available.
    const branchName = 'Main Branch';

    return Center(
      child: GestureDetector(
        onTap: () {
          // TODO: Show branch picker → dispatch MembersStarted(branchId: newId)
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: _kSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _kBorder),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.store_outlined, size: 18, color: _kAccent),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  branchName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 6),
              Icon(Icons.expand_more, size: 18, color: Colors.white54),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Notification bell + badge
// ---------------------------------------------------------------------------

class _NotificationBell extends StatelessWidget {
  const _NotificationBell({required this.isRtl});

  final bool isRtl;

  // TODO: drive count from your notifications state / DI.
  static const int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          tooltip: 'Notifications', // TODO: l10n
          onPressed: () {
            // TODO: navigate to notifications screen.
          },
        ),
        if (_count > 0)
          Positioned(
            top: 6,
            right: isRtl ? null : 6,
            left:  isRtl ? 6    : null,
            child: _Badge(count: _count),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Red pill badge
// ---------------------------------------------------------------------------

class _Badge extends StatelessWidget {
  const _Badge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE53935),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          height: 1.6,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// ===========================================================================
// Subtitle row  "Viewing · Branch Name · Address"
// ===========================================================================

class _SubtitleRow extends StatelessWidget {
  const _SubtitleRow({
    required this.branchName,
    required this.address,
  });

  final String branchName;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Text(
            'Viewing', // TODO: AppLocalizations.of(context).viewing
            style: TextStyle(fontSize: 12, color: Colors.white38),
          ),
          _dot,
          Text(
            branchName,
            style: const TextStyle(
              fontSize: 12,
              color: _kAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (address.isNotEmpty) ...[
            _dot,
            Flexible(
              child: Text(
                address,
                style: const TextStyle(fontSize: 12, color: Colors.white38),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget get _dot => const Padding(
    padding: EdgeInsets.symmetric(horizontal: 4),
    child: Text(
      '·',
      style: TextStyle(fontSize: 12, color: Colors.white24),
    ),
  );
}

// ===========================================================================
// Body — driven by AdminMembersBloc state
// ===========================================================================

class _MembersBody extends StatelessWidget {
  const _MembersBody({required this.branchId});

  final int branchId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminMembersBloc, AdminMembersState>(
      builder: (context, state) {
        // ── Initial / first-page loading ─────────────────────────────────
        if (state is MembersInitial || state is MembersLoading) {
          return const Center(
            child: CircularProgressIndicator(color: _kAccent),
          );
        }

        // ── Error ────────────────────────────────────────────────────────
        if (state is MembersError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Color(0xFFE57373),
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFE57373),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context
                        .read<AdminMembersBloc>()
                        .add(MembersStarted(branchId: branchId, page: 1)),
                    child: const Text(
                      'Retry', // TODO: l10n
                      style: TextStyle(color: _kAccent),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // ── Loaded ───────────────────────────────────────────────────────
        if (state is MembersLoaded) {
          if (state.members.isEmpty) {
            return const Center(
              child: Text(
                'No members found.', // TODO: l10n
                style: TextStyle(color: Colors.white38, fontSize: 14),
              ),
            );
          }
          return _MembersList(state: state, branchId: branchId);
        }

        return const SizedBox.shrink();
      },
    );
  }
}

// ===========================================================================
// Infinite-scroll list
// ===========================================================================

class _MembersList extends StatefulWidget {
  const _MembersList({
    required this.state,
    required this.branchId,
  });

  final MembersLoaded state;
  final int branchId;

  @override
  State<_MembersList> createState() => _MembersListState();
}

class _MembersListState extends State<_MembersList> {
  late final ScrollController _scroll;

  /// Guard against firing multiple pagination events before the next page lands.
  bool _isPaginating = false;

  @override
  void initState() {
    super.initState();
    _scroll = ScrollController()..addListener(_onScroll);
  }

  @override
  void didUpdateWidget(_MembersList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset guard once BLoC has emitted the next page.
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
          page: widget.state.currentPage + 1,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final members    = widget.state.members;
    final showFooter = widget.state.hasNextPage;

    return ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.only(top: 4, bottom: 24),
      itemCount: members.length + (showFooter ? 1 : 0),
      itemBuilder: (context, index) {
        // Footer spinner while the next page loads.
        if (index == members.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: _kAccent,
              ),
            ),
          );
        }

        return MemberCardWidget(member: members[index]);
      },
    );
  }
}