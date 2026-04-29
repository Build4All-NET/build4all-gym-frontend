import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../navigation/presentation/widgets/admin_navigation_drawer.dart';
import '../../domain/usecases/admin_plans_usecases.dart';
import '../../data/services/admin_plans_remote_service.dart';
import '../../data/repositories/admin_plans_repository_impl.dart';
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

  final List<String> _branchOptions = ['All Branches', 'Mumbai Central', 'Andheri West'];
  String _selectedBranch = 'Mumbai Central';

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
        content: const Text('Are you sure you want to delete this plan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AdminPlansBloc>().add(DeletePlanEvent(planId: planId));
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

  Widget _buildAppBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu_rounded),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          const SizedBox(width: 10),

          // ── Branch selector pill ──────────────────────────────────────────
          Expanded(
            child: PopupMenuButton<String>(
              offset: const Offset(0, 44),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              color: Colors.white,
              elevation: 8,
              onSelected: (value) => setState(() => _selectedBranch = value),
              itemBuilder: (context) => _branchOptions
                  .map((branch) => PopupMenuItem<String>(
                value: branch,
                child: Row(
                  children: [
                    Icon(
                      branch == 'All Branches'
                          ? Icons.business_rounded
                          : Icons.location_on_rounded,
                      size: 16,
                      color: const Color(0xFF3B82F6),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      branch,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: _selectedBranch == branch
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: const Color(0xFF374151),
                      ),
                    ),
                    const Spacer(),
                    if (_selectedBranch == branch)
                      const Icon(Icons.check_rounded,
                          size: 16, color: Color(0xFF3B82F6)),
                  ],
                ),
              ))
                  .toList(),
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on_rounded,
                            size: 13, color: Color(0xFF3B82F6)),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            _selectedBranch,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1D4ED8),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 3),
                        const Icon(Icons.keyboard_arrow_down_rounded,
                            size: 15, color: Color(0xFF3B82F6)),
                      ],
                    ),
                    Text(
                      'Mumbai',
                      style: TextStyle(
                          fontSize: 10, color: Colors.blue[300]),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // ── Title ─────────────────────────────────────────────────────────
          const Text(
            'Plans',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const Spacer(),

          // ── Add button ────────────────────────────────────────────────────
          GestureDetector(
            onTap: () => PlanFormBottomSheet.show(
              context,
              onSuccess: () =>
                  context.read<AdminPlansBloc>().add(RefreshPlansEvent()),
            ),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.add_rounded,
                  color: Color(0xFF374151), size: 20),
            ),
          ),
          const SizedBox(width: 8),

          // ── Notification bell ─────────────────────────────────────────────
          Stack(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.notifications_none_rounded,
                    color: Color(0xFF374151), size: 18),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminNavigationDrawer(
        gymName: 'Build4All Gym',       // TODO: pull from AuthBloc/UserBloc state
        branchName: 'Downtown',          // TODO: pull from AuthBloc/UserBloc state
        adminName: 'Mounir',             // TODO: pull from AuthBloc/UserBloc state
        adminEmail: 'mounir@gym.com',    // TODO: pull from AuthBloc/UserBloc state
        avatarUrl: null,                 // null = shows initials
      ),
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: BlocConsumer<AdminPlansBloc, AdminPlansState>(
                listener: (context, state) {
                  if (state is AdminPlansError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: const Color(0xFFD32F2F),
                      ),
                    );
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
                        // ── Filter + Search row ──────────────────────────
                        Container(
                          color: Colors.white,
                          padding:
                          const EdgeInsets.fromLTRB(16, 12, 16, 12),
                          child: Row(
                            children: [
                              // Type filter dropdown
                              Expanded(
                                flex: 2,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F5F5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: DropdownButton<String?>(
                                    value: state.activeTypeFilter,
                                    isExpanded: true,
                                    underline: const SizedBox.shrink(),
                                    hint: const Text('All Types',
                                        style: TextStyle(fontSize: 13)),
                                    items: [
                                      const DropdownMenuItem(
                                        value: null,
                                        child: Text('All Types',
                                            style:
                                            TextStyle(fontSize: 13)),
                                      ),
                                      ...state.types.map(
                                            (t) => DropdownMenuItem(
                                          value: t,
                                          child: Text(t,
                                              style: const TextStyle(
                                                  fontSize: 13)),
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
                                        fontSize: 13,
                                        color: Colors.grey[400]),
                                    prefixIcon: Icon(Icons.search,
                                        size: 18,
                                        color: Colors.grey[400]),
                                    filled: true,
                                    fillColor: const Color(0xFFF5F5F5),
                                    contentPadding:
                                    const EdgeInsets.symmetric(
                                        vertical: 10),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ── Body: stats + list ───────────────────────────
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
                                  ...state.plans.map(
                                        (plan) => AdminPlanCardWidget(
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
                                    ),
                                  ),
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
          onSuccess: () =>
              context.read<AdminPlansBloc>().add(RefreshPlansEvent()),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}