import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../../AppBar/presentation/admin_app_bar.dart';
import '../../../navigation/presentation/widgets/admin_navigation_drawer.dart';
import '../../domain/entities/gym_reception_entity.dart';
import '../bloc/gym_reception_cubit.dart';
import '../bloc/gym_reception_state.dart';
import '../widgets/member_picker_for_reception_sheet.dart';

class AdminGymReceptionScreen extends StatefulWidget {
  const AdminGymReceptionScreen({super.key});

  @override
  State<AdminGymReceptionScreen> createState() => _AdminGymReceptionScreenState();
}

class _AdminGymReceptionScreenState extends State<AdminGymReceptionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
          (_) => context.read<GymReceptionCubit>().load(),
    );
  }

  Future<void> _confirmRemove(GymReceptionEntity staff) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final c = context.read<ThemeCubit>().state.tokens.colors;
        return AlertDialog(
          backgroundColor: c.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Remove Reception Role',
              style: TextStyle(color: c.primary, fontWeight: FontWeight.bold)),
          content: Text(
            '${staff.fullName} will lose the Reception role and see the Member dashboard on next login.',
            style: TextStyle(color: c.error),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('Cancel', style: TextStyle(color: c.error)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Remove',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
    if (confirmed == true && mounted) {
      context.read<GymReceptionCubit>().removeReception(staff.userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens  = context.watch<ThemeCubit>().state.tokens;
    final c       = tokens.colors;
    final profile = context.watch<AdminProfileCubit>().state;

    return Scaffold(
      backgroundColor: c.background,
      drawer: AdminNavigationDrawer(
        gymName:         profile.gymName,
        branchName:      profile.branchName,
        adminName:       profile.adminName,
        adminEmail:      profile.adminEmail,
        avatarUrl:       profile.avatarUrl,
        initialActiveId: 'reception_staff',
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: SafeArea(
          bottom: false,
          child: AdminAppBar(title: 'Reception Staff'),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => MemberPickerForReceptionSheet.show(
          context,
          onAssigned: () => context.read<GymReceptionCubit>().reload(),
        ),
        backgroundColor: c.primary,
        icon: const Icon(Icons.person_add_alt_1_rounded, color: Colors.white),
        label: const Text('Add Staff',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),

      body: BlocConsumer<GymReceptionCubit, GymReceptionState>(
        listener: (context, state) {
          if (state is GymReceptionRemoveError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.shade700,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GymReceptionLoading) {
            return Center(child: CircularProgressIndicator(color: c.primary));
          }

          if (state is GymReceptionError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.wifi_off_rounded, color: c.error, size: 48),
                  const SizedBox(height: 12),
                  Text('Could not load reception staff',
                      style: TextStyle(color: c.primary, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(state.message,
                      style: TextStyle(color: c.error, fontSize: 12),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.read<GymReceptionCubit>().load(),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: c.primary,
                        foregroundColor: Colors.white),
                  ),
                ],
              ),
            );
          }

          final staff = _resolveList(state);
          final removingId = state is GymReceptionRemoving
              ? state.removingUserId
              : null;

          if (staff.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_outline,
                      color: c.error, size: 56),
                  const SizedBox(height: 16),
                  Text('No Reception Staff Yet',
                      style: TextStyle(
                          color: c.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    'Tap "Add Staff" to assign a member\nthe Reception role.',
                    style: TextStyle(color: c.error, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: c.primary,
            onRefresh: () => context.read<GymReceptionCubit>().reload(),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              itemCount: staff.length,
              itemBuilder: (_, i) => _ReceptionCard(
                staff:      staff[i],
                isRemoving: removingId == staff[i].userId,
                onRemove:   () => _confirmRemove(staff[i]),
              ),
            ),
          );
        },
      ),
    );
  }

  List<GymReceptionEntity> _resolveList(GymReceptionState state) {
    if (state is GymReceptionLoaded)      return state.staff;
    if (state is GymReceptionRemoving)    return state.staff;
    if (state is GymReceptionRemoveError) return state.staff;
    return [];
  }
}

class _ReceptionCard extends StatelessWidget {
  final GymReceptionEntity staff;
  final bool               isRemoving;
  final VoidCallback       onRemove;

  const _ReceptionCard({
    required this.staff,
    required this.isRemoving,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;

    String assignedLabel = '';
    try {
      final dt = DateTime.parse(staff.assignedAt);
      assignedLabel = 'Staff since ${DateFormat('MMM d, yyyy').format(dt)}';
    } catch (_) {
      assignedLabel = 'Reception Staff';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(tokens.card.radius),
        border: Border.all(color: c.border.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: c.primary.withOpacity(0.15),
              child: Text(
                staff.initials,
                style: TextStyle(
                    color: c.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(staff.fullName,
                      style: TextStyle(
                          color: c.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 15)),
                  const SizedBox(height: 3),
                  if (staff.phone.isNotEmpty)
                    Row(
                      children: [
                        Icon(Icons.phone_outlined, color: c.error, size: 13),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(staff.phone,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: c.error, fontSize: 12)),
                        ),
                      ],
                    ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, color: c.error, size: 13),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(assignedLabel,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: c.error, fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: c.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text('RECEPTION',
                  style: TextStyle(
                      color: c.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5)),
            ),

            isRemoving
                ? const SizedBox(
              width: 24, height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : IconButton(
              icon: Icon(Icons.person_remove_outlined,
                  color: Colors.red.shade400, size: 22),
              tooltip: 'Remove Reception Role',
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}
