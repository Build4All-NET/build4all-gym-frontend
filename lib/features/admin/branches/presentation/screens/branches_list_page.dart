// ─────────────────────────────────────────────────────────────────────────────
// FILE: pages/branches_list_page.dart  (GA-427)
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../../AppBar/presentation/admin_app_bar.dart';
import '../../../navigation/presentation/widgets/admin_navigation_drawer.dart';
import '../bloc/branches_bloc.dart';
import '../bloc/branches_event.dart';
import '../bloc/branches_state.dart';
import '../widgets/branch_card.dart';
import '../widgets/branch_stat_card.dart';
import 'branch_detail_page.dart';
import 'add_branch_page.dart';

class BranchesListPage extends StatefulWidget {
  const BranchesListPage({super.key});

  @override
  State<BranchesListPage> createState() => _BranchesListPageState();
}

class _BranchesListPageState extends State<BranchesListPage> {
  final _searchController = TextEditingController();
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    context.read<BranchesBloc>().add(const LoadBranches());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<AdminProfileCubit>().state;

    return Scaffold(
      drawer:  AdminNavigationDrawer(
        gymName:    profile.gymName,
        branchName: profile.branchName,
        adminName:  profile.adminName,
        adminEmail: profile.adminEmail,
        avatarUrl:  profile.avatarUrl,
        initialActiveId: 'branches',
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: SafeArea(
          child: AdminAppBar(
            title: 'Branches',

            // ➤ Add button (same logic you had)
            onAddTap: () async {
              final created = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<BranchesBloc>(),
                    child: const AddBranchPage(),
                  ),
                ),
              );

              if (created == true && mounted) {
                context.read<BranchesBloc>().add(const LoadBranches());
              }
            },

            // ➤ Branch selector
            selectedBranchId: null, // or your selected value if you manage it
            onBranchChanged: (branchId) {
              // you can hook this later to filter API
              print('Selected branch: $branchId');
            },

            // ➤ Notifications (optional)
            notificationCount: 0,
            onNotificationTap: () {},

            // ➤ Extra actions (optional)
            actions: const [],
          ),
        ),
      ),
      body: BlocBuilder<BranchesBloc, BranchesState>(
        buildWhen: (prev, curr) =>
        curr is BranchesLoading ||
            curr is BranchesLoaded ||
            curr is BranchesError,
        builder: (context, state) {
          if (state is BranchesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is BranchesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context
                        .read<BranchesBloc>()
                        .add(const LoadBranches()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state is BranchesLoaded) {
            return RefreshIndicator(
              onRefresh: () async =>
                  context.read<BranchesBloc>().add(const LoadBranches()),
              child: CustomScrollView(
                slivers: [
                  // ── Stats Section ────────────────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Column(
                        children: [
                          BranchStatCard(
                            label: 'Active Branches',
                            value: '${state.stats.activeBranches}',
                            icon: Icons.business,
                            iconBgColor: const Color(0xFF3B82F6).withOpacity(0.12),
                            iconColor: const Color(0xFF3B82F6),
                          ),
                          const SizedBox(height: 8),
                          BranchStatCard(
                            label: 'Total Members',
                            value: '${state.stats.totalMembers}',
                            icon: Icons.people,
                            iconBgColor: const Color(0xFF10B981).withOpacity(0.12),
                            iconColor: const Color(0xFF10B981),
                          ),
                          const SizedBox(height: 8),
                          BranchStatCard(
                            label: 'Monthly Revenue',
                            value: '₹${_formatRevenue(state.stats.monthlyRevenue)}',
                            icon: Icons.trending_up,
                            iconBgColor: const Color(0xFF8B5CF6).withOpacity(0.12),
                            iconColor: const Color(0xFF8B5CF6),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // ── Search + Filter Section ──────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            // Search field
                            TextField(
                              controller: _searchController,
                              onChanged: (v) => context
                                  .read<BranchesBloc>()
                                  .add(SearchBranches(v)),
                              decoration: InputDecoration(
                                hintText:
                                'Search by branch name or location.',
                                hintStyle: TextStyle(
                                    color: Colors.grey[400], fontSize: 14),
                                prefixIcon: Icon(Icons.search,
                                    color: Colors.grey[400]),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.grey[200]!),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.grey[200]!),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Status dropdown
                            DropdownButtonFormField<String?>(
                              value: _selectedStatus,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.grey[200]!),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.grey[200]!),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                              ),
                              items: const [
                                DropdownMenuItem(
                                    value: null,
                                    child: Text('All Status')),
                                DropdownMenuItem(
                                    value: 'ACTIVE',
                                    child: Text('Active')),
                                DropdownMenuItem(
                                    value: 'INACTIVE',
                                    child: Text('Inactive')),
                              ],
                              onChanged: (v) {
                                setState(() => _selectedStatus = v);
                                context
                                    .read<BranchesBloc>()
                                    .add(FilterBranchesByStatus(v));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // ── Branch List ──────────────────────────────────────────
                  if (state.branches.isEmpty)
                    const SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'No branches found',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (ctx, i) => BranchCard(
                          branch: state.branches[i],
                          onTap: () async {
                            final changed = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<BranchesBloc>(),
                                  child: BranchDetailPage(
                                      branchId:
                                      state.branches[i].branchId),
                                ),
                              ),
                            );
                            if (changed == true && context.mounted) {
                              context.read<BranchesBloc>().add(const LoadBranches());
                            }
                          },
                        ),
                        childCount: state.branches.length,
                      ),
                    ),
                  const SliverPadding(
                      padding: EdgeInsets.only(bottom: 24)),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  String _formatRevenue(double v) {
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}K';
    return v.toStringAsFixed(0);
  }
}