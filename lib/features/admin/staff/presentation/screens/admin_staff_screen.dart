// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/staff/presentation/screens/admin_staff_screen.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// dio() is a function in globals.dart that returns the singleton Dio instance
import 'package:build4allgym/core/network/globals.dart';

import '../../data/repositories/admin_staff_repository_impl.dart';
import '../../data/services/admin_staff_service.dart';
import '../../domain/usecases/create_staff_usecase.dart';
import '../../domain/usecases/get_staff_usecase.dart';
import '../../domain/usecases/remove_staff_usecase.dart';
import '../../domain/usecases/update_staff_usecase.dart';
import '../bloc/admin_staff_bloc.dart';
import '../bloc/admin_staff_event.dart';
import '../bloc/admin_staff_state.dart';
import '../widgets/add_edit_staff_dialog.dart';
import '../widgets/staff_card_widget.dart';
import '../widgets/staff_search_bar_widget.dart';

class AdminStaffScreen extends StatelessWidget {
  const AdminStaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        // dio() — call the function, it returns the singleton Dio instance
        // from globals.dart (creates it if not yet initialized)
        final service = AdminStaffService(dio());

        final repo = AdminStaffRepositoryImpl(service);
        return AdminStaffBloc(
          getStaff: GetStaffUseCase(repo),
          createStaff: CreateStaffUseCase(repo),
          updateStaff: UpdateStaffUseCase(repo),
          removeStaff: RemoveStaffUseCase(repo),
        )..add(const StaffStarted());
      },
      child: const _AdminStaffView(),
    );
  }
}

class _AdminStaffView extends StatelessWidget {
  const _AdminStaffView();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: _buildAppBar(context),
        body: BlocConsumer<AdminStaffBloc, AdminStaffState>(
          listener: (context, state) {
            if (state is StaffActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_successMessage(state.actionType)),
                  backgroundColor: const Color(0xFF16A34A),
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              );
            }
            if (state is StaffActionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: const Color(0xFFDC2626),
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is StaffLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is StaffError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Color(0xFFDC2626)),
                    const SizedBox(height: 12),
                    Text(state.message,
                        textAlign: TextAlign.center,
                        style:
                        const TextStyle(color: Color(0xFF64748B))),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => context
                          .read<AdminStaffBloc>()
                          .add(const StaffStarted()),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is StaffLoaded ||
                state is StaffActionLoading ||
                state is StaffActionSuccess ||
                state is StaffActionError) {
              final loaded = _lastLoaded(context);
              if (loaded == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StaffSearchBarWidget(),
                  Expanded(
                    child: loaded.staff.isEmpty
                        ? const Center(
                        child: Text('No staff members found.',
                            style:
                            TextStyle(color: Color(0xFF94A3B8))))
                        : ListView.builder(
                      padding: const EdgeInsets.only(
                          top: 4, bottom: 100),
                      itemCount: loaded.staff.length,
                      itemBuilder: (ctx, i) =>
                          StaffCardWidget(staff: loaded.staff[i]),
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _openAddDialog(context),
          backgroundColor: const Color(0xFF1E293B),
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 28),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    // TODO: replace with dynamic values from your branch BLoC/provider
    const String branchName = 'Mumbai Central';
    const String branchAddress = '123 MG Road, Mumbai';

    return PreferredSize(
      preferredSize: const Size.fromHeight(72),
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF1E293B)),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.storefront_outlined,
                    size: 16, color: Color(0xFF2563EB)),
                const SizedBox(width: 4),
                Text(branchName,
                    style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.w500)),
                const Text('Staff',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B))),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 13, color: Color(0xFF64748B)),
                const SizedBox(width: 2),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF64748B)),
                    children: [
                      const TextSpan(text: 'Viewing: '),
                      TextSpan(
                          text: branchName,
                          style: const TextStyle(
                              color: Color(0xFF2563EB),
                              fontWeight: FontWeight.w600)),
                      const TextSpan(text: '  |  $branchAddress'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF1E293B)),
            onPressed: () => _openAddDialog(context),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: Color(0xFF1E293B)),
                onPressed: () {},
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                      color: Color(0xFFDC2626),
                      shape: BoxShape.circle),
                  child: const Center(
                    child: Text('3',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openAddDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: context.read<AdminStaffBloc>(),
        child: const AddEditStaffDialog(),
      ),
    );
  }

  StaffLoaded? _lastLoaded(BuildContext context) {
    final s = context.read<AdminStaffBloc>().state;
    if (s is StaffLoaded) return s;
    return null;
  }

  String _successMessage(String actionType) {
    return switch (actionType) {
      'create' => 'Staff member added successfully',
      'update' => 'Staff member updated successfully',
      'remove' => 'Staff member removed successfully',
      _ => 'Action completed successfully',
    };
  }
}