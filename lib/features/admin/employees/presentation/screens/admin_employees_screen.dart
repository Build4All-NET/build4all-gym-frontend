// FILE: lib/features/admin/employees/presentation/screens/admin_employees_screen.dart

import 'dart:async';
import 'package:build4allgym/common/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../../AppBar/presentation/admin_app_bar.dart';
import '../../../navigation/presentation/widgets/admin_navigation_drawer.dart';
import '../bloc/admin_employees/admin_employees_bloc.dart';
import '../widgets/admin_employee_card_widget.dart';
import '../widgets/employee_form_bottom_sheet.dart';
import '../widgets/pay_employee_dialog.dart';
import '../widgets/employee_payment_history_sheet.dart';
import '../../domain/entities/employee_entity.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';

class AdminEmployeesScreen extends StatefulWidget {
  const AdminEmployeesScreen({super.key});

  @override
  State<AdminEmployeesScreen> createState() => _AdminEmployeesScreenState();
}

class _AdminEmployeesScreenState extends State<AdminEmployeesScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminEmployeesBloc>().add(LoadAdminEmployeesEvent());
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
      context.read<AdminEmployeesBloc>().add(SearchEmployeesEvent(query: query));
    });
  }

  List<String> _currentTypes() {
    final state = context.read<AdminEmployeesBloc>().state;
    return state is AdminEmployeesLoaded ? state.types : <String>[];
  }

  void _showDeleteDialog(EmployeeEntity employee) {
    final c = context.read<ThemeCubit>().state.tokens.colors;
    final l10n = AppLocalizations.of(context)!;
    final displayName = (employee.fullName == null || employee.fullName!.isEmpty)
        ? l10n.admin_employees_thisEmployee
        : employee.fullName!;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.admin_employees_removeEmployeeTitle),
        content: Text(l10n.admin_employees_removeEmployeeConfirm(displayName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.general_cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AdminEmployeesBloc>().add(DeleteEmployeeEvent(employeeId: employee.employeeId));
            },
            child: Text(l10n.admin_employees_remove, style: TextStyle(color: c.danger)),
          ),
        ],
      ),
    );
  }

  void _openAddEmployeeSheet() {
    EmployeeFormBottomSheet.show(
      context,
      availableTypes: _currentTypes(),
      onSuccess: () {
        context.read<AdminEmployeesBloc>().add(RefreshEmployeesEvent());
      },
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
        initialActiveId: 'employees',
      ),
      backgroundColor: c.background,
      body: SafeArea(
        child: Column(
          children: [
            AdminAppBar(
              title: l10n.navEmployees,
              onAddTap: _openAddEmployeeSheet,
              notificationCount: 0,
            ),
            Expanded(
              child: BlocConsumer<AdminEmployeesBloc, AdminEmployeesState>(
                listener: (context, state) {
                  if (state is AdminEmployeesError) {
                    AppToast.error(context, state.message);
                  }
                },
                builder: (context, state) {
                  if (state is AdminEmployeesLoading) {
                    return Center(child: CircularProgressIndicator(color: c.primary));
                  }

                  if (state is AdminEmployeesError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.error_outline, size: 48, color: c.muted),
                          const SizedBox(height: 12),
                          Text(state.message, textAlign: TextAlign.center, style: TextStyle(color: c.muted)),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context.read<AdminEmployeesBloc>().add(LoadAdminEmployeesEvent()),
                            style: ElevatedButton.styleFrom(backgroundColor: c.primary, foregroundColor: c.onPrimary),
                            child: Text(l10n.retry),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is AdminEmployeesLoaded) {
                    return Column(
                      children: [
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
                                    value: state.activeTypeFilter,
                                    isExpanded: true,
                                    underline: const SizedBox.shrink(),
                                    hint: Text(l10n.admin_employees_allTypes, style: TextStyle(fontSize: 13, color: c.muted)),
                                    dropdownColor: c.surface,
                                    style: TextStyle(fontSize: 13, color: c.label),
                                    items: [
                                      DropdownMenuItem<String?>(
                                        value: null,
                                        child: Text(l10n.admin_employees_allTypes, style: TextStyle(fontSize: 13, color: c.label)),
                                      ),
                                      ...state.types.map(
                                        (t) => DropdownMenuItem<String?>(
                                          value: t,
                                          child: Text(formatEmployeeType(t), style: TextStyle(fontSize: 13, color: c.label)),
                                        ),
                                      ),
                                    ],
                                    onChanged: (v) {
                                      context.read<AdminEmployeesBloc>().add(FilterByTypeEvent(employeeType: v));
                                    },
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
                                    hintText: l10n.admin_employees_searchHint,
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
                        Container(
                          color: c.surface,
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: Row(
                            children: [
                              _StatusChip(
                                label: l10n.admin_employees_filterAll,
                                selected: state.activeStatusFilter == null,
                                onTap: () => context.read<AdminEmployeesBloc>().add(FilterByStatusEvent()),
                              ),
                              const SizedBox(width: 8),
                              _StatusChip(
                                label: l10n.admin_employees_filterActive,
                                selected: state.activeStatusFilter == 'active',
                                onTap: () => context.read<AdminEmployeesBloc>().add(FilterByStatusEvent(status: 'active')),
                              ),
                              const SizedBox(width: 8),
                              _StatusChip(
                                label: l10n.admin_employees_filterInactive,
                                selected: state.activeStatusFilter == 'inactive',
                                onTap: () => context.read<AdminEmployeesBloc>().add(FilterByStatusEvent(status: 'inactive')),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: RefreshIndicator(
                            color: c.primary,
                            onRefresh: () async {
                              context.read<AdminEmployeesBloc>().add(RefreshEmployeesEvent());
                            },
                            child: ListView(
                              children: [
                                if (state.employees.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.all(40),
                                    child: Center(
                                      child: Text(l10n.admin_employees_noEmployeesYet, style: TextStyle(color: c.muted)),
                                    ),
                                  )
                                else
                                  ...state.employees.map(
                                    (employee) => AdminEmployeeCardWidget(
                                      employee: employee,
                                      isDeleting: state.isDeletingEmployee && state.deletingEmployeeId == employee.employeeId,
                                      isPaying: state.isPayingEmployee && state.payingEmployeeId == employee.employeeId,
                                      onEdit: () {
                                        EmployeeFormBottomSheet.show(
                                          context,
                                          existingEmployee: employee,
                                          availableTypes: state.types,
                                          onSuccess: () {
                                            context.read<AdminEmployeesBloc>().add(RefreshEmployeesEvent());
                                          },
                                        );
                                      },
                                      onDelete: () => _showDeleteDialog(employee),
                                      onPay: () => PayEmployeeDialog.show(context, employee: employee),
                                      onViewHistory: () => EmployeePaymentHistorySheet.show(context, employee: employee),
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
        onPressed: _openAddEmployeeSheet,
        backgroundColor: c.success,
        child: Icon(Icons.add, color: c.onPrimary),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _StatusChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.read<ThemeCubit>().state.tokens.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? c.primary.withOpacity(0.12) : c.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? c.primary : c.border.withOpacity(0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? c.primary : c.muted,
          ),
        ),
      ),
    );
  }
}
