// FILE: lib/features/admin/expenses/presentation/screens/admin_expenses_screen.dart

import 'dart:async';
import 'package:build4allgym/common/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../../AppBar/presentation/admin_app_bar.dart';
import '../../../AppBar/presentation/branch_cubit.dart';
import '../../../navigation/presentation/widgets/admin_navigation_drawer.dart';
import '../bloc/admin_expenses/admin_expenses_bloc.dart';
import '../widgets/expense_stats_card_widget.dart';
import '../widgets/admin_expense_card_widget.dart';
import '../widgets/expense_form_bottom_sheet.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';

class AdminExpensesScreen extends StatefulWidget {
  const AdminExpensesScreen({super.key});

  @override
  State<AdminExpensesScreen> createState() => _AdminExpensesScreenState();
}

class _AdminExpensesScreenState extends State<AdminExpensesScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BranchCubit>().loadBranches();
      context.read<AdminExpensesBloc>().add(LoadAdminExpensesEvent());
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
      context.read<AdminExpensesBloc>().add(SearchExpensesEvent(query: query));
    });
  }

  // Used by callers outside the BlocConsumer's builder (AppBar, FAB) where
  // the loaded state isn't directly in scope.
  List<String> _currentCategories() {
    final state = context.read<AdminExpensesBloc>().state;
    return state is AdminExpensesLoaded ? state.categories : <String>[];
  }

  void _showDeleteDialog(int expenseId) {
    final c = context.read<ThemeCubit>().state.tokens.colors;
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.admin_expenses_deleteTitle),
        content: Text(l10n.admin_expenses_deleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.general_cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AdminExpensesBloc>().add(DeleteExpenseEvent(expenseId: expenseId));
            },
            child: Text(l10n.admin_expenses_delete, style: TextStyle(color: c.danger)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final l10n = AppLocalizations.of(context)!;

    final profile = context.watch<AdminProfileCubit>().state;

    return Scaffold(
      drawer: AdminNavigationDrawer(
        gymName: profile.gymName,
        branchName: profile.branchName,
        adminName: profile.adminName,
        adminEmail: profile.adminEmail,
        avatarUrl: profile.avatarUrl,
        initialActiveId: 'expenses',
      ),
      backgroundColor: c.background,
      body: SafeArea(
        child: Column(
          children: [
            AdminAppBar(
              title: l10n.navExpenses,
              onAddTap: () => ExpenseFormBottomSheet.show(
                context,
                availableCategories: _currentCategories(),
                onSuccess: () => context.read<AdminExpensesBloc>().add(RefreshExpensesEvent()),
              ),
              notificationCount: 0,
            ),
            Expanded(
              child: BlocConsumer<AdminExpensesBloc, AdminExpensesState>(
                listener: (context, state) {
                  if (state is AdminExpensesError) {
                    AppToast.error(context, state.message);
                  }
                },
                builder: (context, state) {
                  if (state is AdminExpensesLoading) {
                    return Center(child: CircularProgressIndicator(color: c.primary));
                  }

                  if (state is AdminExpensesError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.error_outline, size: 48, color: c.muted),
                          const SizedBox(height: 12),
                          Text(state.message,
                              textAlign: TextAlign.center, style: TextStyle(color: c.muted)),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () =>
                                context.read<AdminExpensesBloc>().add(LoadAdminExpensesEvent()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: c.primary,
                              foregroundColor: c.onPrimary,
                            ),
                            child: Text(l10n.retry),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is AdminExpensesLoaded) {
                    return Column(
                      children: [
                        // ── Filter + Search ────────────────────────────────
                        Container(
                          color: c.surface,
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: c.background,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: DropdownButton<String?>(
                                    value: state.activeCategoryFilter,
                                    isExpanded: true,
                                    underline: const SizedBox.shrink(),
                                    hint: Text(l10n.admin_expenses_allCategories,
                                        style: TextStyle(fontSize: 13, color: c.muted)),
                                    dropdownColor: c.surface,
                                    style: TextStyle(fontSize: 13, color: c.label),
                                    items: [
                                      DropdownMenuItem(
                                        value: null,
                                        child: Text(l10n.admin_expenses_allCategories,
                                            style: TextStyle(fontSize: 13, color: c.label)),
                                      ),
                                      ...state.categories.map((cat) => DropdownMenuItem(
                                            value: cat,
                                            child: Text(formatExpenseCategory(cat),
                                                style: TextStyle(fontSize: 13, color: c.label)),
                                          )),
                                    ],
                                    onChanged: (v) => context
                                        .read<AdminExpensesBloc>()
                                        .add(FilterByCategoryEvent(category: v)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 3,
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: _onSearchChanged,
                                  style: TextStyle(fontSize: 13, color: c.label),
                                  decoration: InputDecoration(
                                    hintText: l10n.admin_expenses_searchHint,
                                    hintStyle: TextStyle(fontSize: 13, color: c.muted),
                                    prefixIcon: Icon(Icons.search, size: 18, color: c.muted),
                                    filled: true,
                                    fillColor: c.background,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
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
                            color: c.primary,
                            onRefresh: () async =>
                                context.read<AdminExpensesBloc>().add(RefreshExpensesEvent()),
                            child: ListView(
                              children: [
                                ExpenseStatsCardWidget(stats: state.stats),
                                if (state.expenses.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.all(40),
                                    child: Center(
                                      child: Text(l10n.admin_expenses_noExpenses,
                                          style: TextStyle(color: c.muted)),
                                    ),
                                  )
                                else
                                  ...state.expenses.map((expense) => AdminExpenseCardWidget(
                                        expense: expense,
                                        isDeleting: state.isDeletingExpense &&
                                            state.deletingExpenseId == expense.expenseId,
                                        onEdit: () => ExpenseFormBottomSheet.show(
                                          context,
                                          existingExpense: expense,
                                          availableCategories: state.categories,
                                          onSuccess: () => context
                                              .read<AdminExpensesBloc>()
                                              .add(RefreshExpensesEvent()),
                                        ),
                                        onDelete: () => _showDeleteDialog(expense.expenseId),
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
        onPressed: () => ExpenseFormBottomSheet.show(
          context,
          availableCategories: _currentCategories(),
          onSuccess: () => context.read<AdminExpensesBloc>().add(RefreshExpensesEvent()),
        ),
        backgroundColor: c.success,
        child: Icon(Icons.add, color: c.onPrimary),
      ),
    );
  }
}
