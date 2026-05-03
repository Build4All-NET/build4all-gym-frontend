// PATH: lib/features/admin/plans/presentation/screens/admin_plans_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../AppBar/presentation/admin_app_bar.dart';
import '../../../AppBar/presentation/branch_cubit.dart';
import '../../../navigation/presentation/widgets/admin_navigation_drawer.dart';
import '../bloc/admin_plans/admin_plans_bloc.dart';
import '../widgets/plan_stats_card_widget.dart';
import '../widgets/admin_plan_card_widget.dart';
import '../widgets/plan_form_bottom_sheet.dart';

class AdminPlansScreen extends StatefulWidget {
  const AdminPlansScreen({super.key});

  @override
  State<AdminPlansScreen> createState() => _AdminPlansScreenState();
}

class _AdminPlansScreenState extends State<AdminPlansScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  // ── Branch state — driven by BranchCubit, no longer static ───────────────
  int? _selectedBranchId; // null = All Branches

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load branches from DB if not already loaded
      context.read<BranchCubit>().loadBranches();
      // Load plans
      context.read<AdminPlansBloc>().add(LoadAdminPlansEvent());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<AdminPlansBloc>().add(SearchPlansEvent(query: query));
    });
  }

  void _onBranchChanged(int? branchId) {
    setState(() => _selectedBranchId = branchId);
    // TODO: pass branchId to plans BLoC when plans support branch filtering
    // context.read<AdminPlansBloc>().add(LoadAdminPlansEvent(branchId: branchId));
  }

  void _showDeleteDialog(int planId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title:   const Text('Delete Plan'),
        content: const Text('Are you sure you want to delete this plan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child:     const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AdminPlansBloc>()
                  .add(DeletePlanEvent(planId: planId));
            },
            child: const Text('Delete',
                style: TextStyle(color: Color(0xFFD32F2F))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminNavigationDrawer(
        gymName:         'Build4All Gym',
        branchName:      'Downtown',
        adminName:       'Mounir',
        adminEmail:      'mounir@gym.com',
        avatarUrl:       null,
        initialActiveId: 'plans',
      ),
      backgroundColor: const Color(0xFFF8F9FA),

      body: SafeArea(
        child: Column(
          children: [

            // ── Shared AppBar — branches from DB via BranchCubit ──────────
            AdminAppBar(
              title:            'Plans',
              selectedBranchId: _selectedBranchId,
              onBranchChanged:  _onBranchChanged,
              onAddTap: () => PlanFormBottomSheet.show(
                context,
                onSuccess: () => context
                    .read<AdminPlansBloc>()
                    .add(RefreshPlansEvent()),
              ),
              notificationCount: 0, // TODO: wire to notifications BLoC
            ),

            // ── Body ──────────────────────────────────────────────────────
            Expanded(
              child: BlocConsumer<AdminPlansBloc, AdminPlansState>(
                listener: (context, state) {
                  if (state is AdminPlansError) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:         Text(state.message),
                      backgroundColor: const Color(0xFFD32F2F),
                    ));
                  }
                },
                builder: (context, state) {

                  if (state is AdminPlansLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is AdminPlansError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline,
                              size: 48, color: Colors.grey),
                          const SizedBox(height: 12),
                          Text(state.message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.grey)),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context
                                .read<AdminPlansBloc>()
                                .add(LoadAdminPlansEvent()),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is AdminPlansLoaded) {
                    return Column(
                      children: [

                        // ── Filter + Search row ────────────────────────────
                        Container(
                          color:   Colors.white,
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                          child: Row(
                            children: [
                              // Type filter dropdown
                              Expanded(
                                flex: 2,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                    color:        const Color(0xFFF5F5F5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: DropdownButton<String?>(
                                    value:      state.activeTypeFilter,
                                    isExpanded: true,
                                    underline:  const SizedBox.shrink(),
                                    hint: const Text('All Types',
                                        style: TextStyle(fontSize: 13)),
                                    items: [
                                      const DropdownMenuItem(
                                        value: null,
                                        child: Text('All Types',
                                            style: TextStyle(fontSize: 13)),
                                      ),
                                      ...state.types.map((t) =>
                                          DropdownMenuItem(
                                            value: t,
                                            child: Text(t,
                                                style: const TextStyle(
                                                    fontSize: 13)),
                                          )),
                                    ],
                                    onChanged: (v) => context
                                        .read<AdminPlansBloc>()
                                        .add(FilterByTypeEvent(type: v)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Search field
                              Expanded(
                                flex: 3,
                                child: TextField(
                                  controller: _searchController,
                                  onChanged:  _onSearchChanged,
                                  style: const TextStyle(fontSize: 13),
                                  decoration: InputDecoration(
                                    hintText: 'Search plans...',
                                    hintStyle: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[400]),
                                    prefixIcon: Icon(Icons.search,
                                        size:  18,
                                        color: Colors.grey[400]),
                                    filled:    true,
                                    fillColor: const Color(0xFFF5F5F5),
                                    contentPadding:
                                    const EdgeInsets.symmetric(
                                        vertical: 10),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ── Stats + Plan list ──────────────────────────────
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async => context
                                .read<AdminPlansBloc>()
                                .add(RefreshPlansEvent()),
                            child: ListView(
                              children: [
                                PlanStatsCardWidget(stats: state.stats),
                                if (state.plans.isEmpty)
                                  const Padding(
                                    padding: EdgeInsets.all(40),
                                    child: Center(
                                      child: Text('No plans found',
                                          style: TextStyle(
                                              color: Colors.grey)),
                                    ),
                                  )
                                else
                                  ...state.plans.map((plan) =>
                                      AdminPlanCardWidget(
                                        plan: plan,
                                        isDeleting: state.isDeletingPlan &&
                                            state.deletingPlanId ==
                                                plan.planId,
                                        onEdit: () =>
                                            PlanFormBottomSheet.show(
                                              context,
                                              existingPlan: plan,
                                              onSuccess: () => context
                                                  .read<AdminPlansBloc>()
                                                  .add(RefreshPlansEvent()),
                                            ),
                                        onDelete: () =>
                                            _showDeleteDialog(plan.planId),
                                      )),
                                const SizedBox(height: 80),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => PlanFormBottomSheet.show(
          context,
          onSuccess: () => context
              .read<AdminPlansBloc>()
              .add(RefreshPlansEvent()),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}