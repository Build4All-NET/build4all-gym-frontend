import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/admin_plans_usecases.dart';
import '../../data/services/admin_plans_remote_service.dart';
import '../../data/repositories/admin_plans_repository_impl.dart';
import '../bloc/admin_plans/admin_plans_bloc.dart';
import '../widgets/plan_stats_card_widget.dart';
import '../widgets/admin_plan_card_widget.dart';
import '../widgets/plan_form_bottom_sheet.dart';

/// Entry point — wrap this in a BlocProvider before pushing to it.
///
/// Example (from your admin nav bar):
/// ```dart
/// Navigator.push(context, MaterialPageRoute(
///   builder: (_) => BlocProvider(
///     create: (_) => AdminPlansBloc(
///       getStats: GetAdminPlanStatsUseCase(repository: AdminPlansRepositoryImpl(
///         remoteDatasource: AdminPlansRemoteDatasourceImpl())),
///       getPlans: GetAdminPlansUseCase(repository: AdminPlansRepositoryImpl(
///         remoteDatasource: AdminPlansRemoteDatasourceImpl())),
///       getPlanTypes: GetPlanTypesUseCase(repository: AdminPlansRepositoryImpl(
///         remoteDatasource: AdminPlansRemoteDatasourceImpl())),
///       deletePlan: DeletePlanUseCase(repository: AdminPlansRepositoryImpl(
///         remoteDatasource: AdminPlansRemoteDatasourceImpl())),
///     )..add(LoadAdminPlansEvent()),
///     child: const AdminPlansScreen(),
///   ),
/// ));
/// ```
class AdminPlansScreen extends StatefulWidget {
  const AdminPlansScreen({super.key});

  @override
  State<AdminPlansScreen> createState() => _AdminPlansScreenState();
}

class _AdminPlansScreenState extends State<AdminPlansScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;

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

  void _showDeleteDialog(int planId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Plan'),
        content:
        const Text('Are you sure you want to delete this plan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context
                  .read<AdminPlansBloc>()
                  .add(DeletePlanEvent(planId: planId));
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Color(0xFFD32F2F)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Plans',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocConsumer<AdminPlansBloc, AdminPlansState>(
        listener: (context, state) {
          if (state is AdminPlansError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xFFD32F2F),
              ),
            );
          }
          if (state is AdminPlansLoaded &&
              !state.isDeletingPlan &&
              state.deletingPlanId == null) {
            // Successful delete — show confirmation
            // Note: this fires on every load; guard with a flag if needed
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
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
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
                // ── Filter + Search row ────────────────────────────────────
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Row(
                    children: [
                      // Type filter dropdown
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButton<String?>(
                            value: state.activeTypeFilter,
                            isExpanded: true,
                            underline: const SizedBox.shrink(),
                            hint: const Text(
                              'All Types',
                              style: TextStyle(fontSize: 13),
                            ),
                            items: [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('All Types',
                                    style: TextStyle(fontSize: 13)),
                              ),
                              ...state.types.map(
                                    (t) => DropdownMenuItem(
                                  value: t,
                                  child: Text(t,
                                      style: const TextStyle(fontSize: 13)),
                                ),
                              ),
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
                          onChanged: _onSearchChanged,
                          style: const TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Search plans...',
                            hintStyle: TextStyle(
                                fontSize: 13, color: Colors.grey[400]),
                            prefixIcon: Icon(Icons.search,
                                size: 18, color: Colors.grey[400]),
                            filled: true,
                            fillColor: const Color(0xFFF5F5F5),
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
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

                // ── Body: stats + list ─────────────────────────────────────
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context
                          .read<AdminPlansBloc>()
                          .add(RefreshPlansEvent());
                    },
                    child: ListView(
                      children: [
                        // Stats cards
                        PlanStatsCardWidget(stats: state.stats),

                        // Plans list
                        if (state.plans.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(40),
                            child: Center(
                              child: Text(
                                'No plans found',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          )
                        else
                          ...state.plans.map((plan) => AdminPlanCardWidget(
                            plan: plan,
                            isDeleting: state.isDeletingPlan &&
                                state.deletingPlanId == plan.planId,
                            onEdit: () => PlanFormBottomSheet.show(
                              context,
                              existingPlan: plan,
                              onSuccess: () => context
                                  .read<AdminPlansBloc>()
                                  .add(RefreshPlansEvent()),
                            ),
                            onDelete: () => _showDeleteDialog(plan.planId),
                          )),

                        const SizedBox(height: 80), // FAB clearance
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
      // ── FAB — Add New Plan ───────────────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => PlanFormBottomSheet.show(
          context,
          onSuccess: () =>
              context.read<AdminPlansBloc>().add(RefreshPlansEvent()),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        icon: const Icon(Icons.add),
        label: const Text('Add Plan'),
      ),
    );
  }
}