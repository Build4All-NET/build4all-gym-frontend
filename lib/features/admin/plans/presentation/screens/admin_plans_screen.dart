// FILE: lib/features/admin/plans/presentation/screens/admin_plans_screen.dart

import 'dart:async';
import 'package:build4allgym/common/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../../AppBar/presentation/admin_app_bar.dart';
import '../../../AppBar/presentation/branch_cubit.dart';
import '../../../navigation/presentation/widgets/admin_navigation_drawer.dart';
import '../bloc/admin_plans/admin_plans_bloc.dart';
import '../widgets/plan_stats_card_widget.dart';
import '../widgets/admin_plan_card_widget.dart';
import '../widgets/plan_form_bottom_sheet.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';

class AdminPlansScreen extends StatefulWidget {
  const AdminPlansScreen({super.key});

  @override
  State<AdminPlansScreen> createState() => _AdminPlansScreenState();
}

class _AdminPlansScreenState extends State<AdminPlansScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  int? _selectedBranchId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BranchCubit>().loadBranches();
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
  }

  void _showDeleteDialog(int planId) {
    final c    = context.read<ThemeCubit>().state.tokens.colors;
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title:   Text(l10n.admin_plans_deleteTitle),
        content: Text(l10n.admin_plans_deleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child:     Text(l10n.general_cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AdminPlansBloc>()
                  .add(DeletePlanEvent(planId: planId));
            },
            child: Text(l10n.admin_plans_delete,
                style: TextStyle(color: c.danger)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;
    final card   = tokens.card;

    final profile = context.watch<AdminProfileCubit>().state;

    return Scaffold(
      drawer:  AdminNavigationDrawer(
        gymName:    profile.gymName,
        branchName: profile.branchName,
        adminName:  profile.adminName,
        adminEmail: profile.adminEmail,
        avatarUrl:  profile.avatarUrl,
        initialActiveId: 'plans',
      ),
      backgroundColor: c.background,

      body: SafeArea(
        child: Column(
          children: [

            AdminAppBar(
              title:             AppLocalizations.of(context)!.navPlans,
              selectedBranchId:  _selectedBranchId,
              onBranchChanged:   _onBranchChanged,
              onAddTap: () => PlanFormBottomSheet.show(
                context,
                onSuccess: () => context
                    .read<AdminPlansBloc>()
                    .add(RefreshPlansEvent()),
              ),
              notificationCount: 0,
            ),

            Expanded(
              child: BlocConsumer<AdminPlansBloc, AdminPlansState>(
                listener: (context, state) {
                  if (state is AdminPlansError) {
                    AppToast.error(context, state.message);
                  }
                },
                builder: (context, state) {

                  if (state is AdminPlansLoading) {
                    return Center(
                        child: CircularProgressIndicator(color: c.primary));
                  }

                  if (state is AdminPlansError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.error_outline,
                              size: 48, color: c.muted),
                          const SizedBox(height: 12),
                          Text(state.message,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: c.muted)),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context
                                .read<AdminPlansBloc>()
                                .add(LoadAdminPlansEvent()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: c.primary,
                              foregroundColor: c.onPrimary,
                            ),
                            child: Text(AppLocalizations.of(context)!.retry),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is AdminPlansLoaded) {
                    return Column(
                      children: [

                        // ── Filter + Search ────────────────────────────────
                        Container(
                          color:   c.surface,
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  padding:    const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color:        c.background,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: DropdownButton<String?>(
                                    value:      state.activeTypeFilter,
                                    isExpanded: true,
                                    underline:  const SizedBox.shrink(),
                                    hint: Text(AppLocalizations.of(context)!.admin_plans_allTypes,
                                        style: TextStyle(
                                            fontSize: 13, color: c.muted)),
                                    dropdownColor: c.surface,
                                    style: TextStyle(
                                        fontSize: 13, color: c.label),
                                    items: [
                                      DropdownMenuItem(
                                        value: null,
                                        child: Text(AppLocalizations.of(context)!.admin_plans_allTypes,
                                            style: TextStyle(
                                                fontSize:  13,
                                                color:     c.label)),
                                      ),
                                      ...state.types.map((t) =>
                                          DropdownMenuItem(
                                            value: t,
                                            child: Text(t,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color:    c.label)),
                                          )),
                                    ],
                                    onChanged: (v) => context
                                        .read<AdminPlansBloc>()
                                        .add(FilterByTypeEvent(type: v)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 3,
                                child: TextField(
                                  controller: _searchController,
                                  onChanged:  _onSearchChanged,
                                  style: TextStyle(
                                      fontSize: 13, color: c.label),
                                  decoration: InputDecoration(
                                    hintText:  AppLocalizations.of(context)!.admin_plans_searchHint,
                                    hintStyle: TextStyle(
                                        fontSize: 13, color: c.muted),
                                    prefixIcon: Icon(Icons.search,
                                        size: 18, color: c.muted),
                                    filled:    true,
                                    fillColor: c.background,
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

                        Expanded(
                          child: RefreshIndicator(
                            color:     c.primary,
                            onRefresh: () async => context
                                .read<AdminPlansBloc>()
                                .add(RefreshPlansEvent()),
                            child: ListView(
                              children: [
                                PlanStatsCardWidget(stats: state.stats),
                                if (state.plans.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.all(40),
                                    child: Center(
                                      child: Text(AppLocalizations.of(context)!.admin_plans_noPlans,
                                          style: TextStyle(
                                              color: c.muted)),
                                    ),
                                  )
                                else
                                  ...state.plans.map((plan) =>
                                      AdminPlanCardWidget(
                                        plan:       plan,
                                        isDeleting: state.isDeletingPlan &&
                                            state.deletingPlanId == plan.planId,
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
        backgroundColor: c.success,
        child: Icon(Icons.add, color: c.onPrimary),
      ),
    );
  }
}