// ─────────────────────────────────────────────────────────────────────────────
// FILE: pages/branch_detail_page.dart  (GA-428)
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/branches_bloc.dart';
import '../bloc/branches_event.dart';
import '../bloc/branches_state.dart';
import 'add_branch_page.dart';
import '../../../../../l10n/app_localizations.dart';

class BranchDetailPage extends StatefulWidget {
  final String branchId;
  const BranchDetailPage({super.key, required this.branchId});

  @override
  State<BranchDetailPage> createState() => _BranchDetailPageState();
}

class _BranchDetailPageState extends State<BranchDetailPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<BranchesBloc>()
        .add(LoadBranchDetail(widget.branchId));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF1A1A2E)),
        title: Text(
          l10n.admin_branches_detailTitle,
          style: const TextStyle(
              color: Color(0xFF1A1A2E),
              fontWeight: FontWeight.w700,
              fontSize: 18),
        ),
        actions: [
          BlocBuilder<BranchesBloc, BranchesState>(
            buildWhen: (_, curr) => curr is BranchDetailLoaded,
            builder: (context, state) {
              if (state is! BranchDetailLoaded) return const SizedBox.shrink();
              final detail = state.detail;
              return Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Color(0xFF3B82F6)),
                    onPressed: () async {
                      final updated = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<BranchesBloc>(),
                            child: AddBranchPage(existing: detail),
                          ),
                        ),
                      );
                      if (updated == true && context.mounted) {
                        context.read<BranchesBloc>().add(LoadBranchDetail(widget.branchId));
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () => _confirmDelete(context, detail.name),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocListener<BranchesBloc, BranchesState>(
        listenWhen: (_, curr) =>
            curr is BranchDeleted || curr is BranchDeleteError || curr is BranchDeleting,
        listener: (context, state) {
          if (state is BranchDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.admin_branches_deletedSuccess),
                backgroundColor: const Color(0xFF10B981),
              ),
            );
            Navigator.pop(context, true);
          } else if (state is BranchDeleteError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        },
        child: BlocBuilder<BranchesBloc, BranchesState>(
        // Guard: only rebuild this page from detail states
        buildWhen: (prev, curr) =>
        curr is BranchDetailLoading ||
            curr is BranchDetailLoaded ||
            curr is BranchDetailError,
        builder: (context, state) {
          if (state is BranchDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is BranchDetailError) {
            return Center(child: Text(state.message));
          }
          if (state is BranchDetailLoaded) {
            final d = state.detail;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header card (blue gradient) ─────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF6366F1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.business,
                              color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                d.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (d.city != null) ...[
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on,
                                        color: Colors.white70, size: 14),
                                    const SizedBox(width: 4),
                                    Text(d.city!,
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14)),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: d.isActive
                                ? const Color(0xFF10B981)
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            d.isActive ? l10n.admin_branches_statusActive : l10n.admin_branches_statusInactive,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  // ── Contact & Address card ──────────────────────────────
                  _InfoCard(children: [
                    if (d.phone != null)
                      _ContactRow(
                          icon: Icons.phone_outlined,
                          color: const Color(0xFF3B82F6),
                          label: l10n.admin_branches_phoneLabel,
                          value: d.phone!),
                    if (d.email != null) ...[
                      const Divider(height: 20),
                      _ContactRow(
                          icon: Icons.email_outlined,
                          color: const Color(0xFF8B5CF6),
                          label: l10n.admin_branches_emailLabel,
                          value: d.email!),
                    ],
                    if (d.address != null) ...[
                      const Divider(height: 20),
                      _LabelValue(label: l10n.admin_branches_addressLabel, value: d.address!),
                    ],
                  ]),
                  const SizedBox(height: 12),
                  // ── Stats row: Members / Trainers / Staff ───────────────
                  Row(
                    children: [
                      Expanded(
                        child: _MiniStatCard(
                          icon: Icons.people,
                          color: const Color(0xFF3B82F6),
                          count: d.memberCount,
                          label: l10n.navMembers,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _MiniStatCard(
                          icon: Icons.fitness_center,
                          color: const Color(0xFF8B5CF6),
                          count: d.trainerCount,
                          label: l10n.admin_branches_trainers,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _MiniStatCard(
                          icon: Icons.manage_accounts,
                          color: const Color(0xFF10B981),
                          count: d.staffCount,
                          label: l10n.navStaff,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // ── Hours + Revenue footer ──────────────────────────────
                  _InfoCard(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                color: Colors.grey[500], size: 18),
                            const SizedBox(width: 8),
                            Text(
                              d.hoursDisplay,
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 14),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  l10n.admin_branches_monthlyRevenue,
                                  style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 11),
                                ),
                                Text(
                                  '₹${_formatRevenue(d.monthlyRevenue)}',
                                  style: const TextStyle(
                                    color: Color(0xFF10B981),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 4),
                            Icon(
                                Directionality.of(context) == TextDirection.rtl
                                    ? Icons.chevron_left
                                    : Icons.chevron_right,
                                color: Colors.grey),
                          ],
                        ),
                      ],
                    ),
                  ]),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
        ),
    );
  }

  void _confirmDelete(BuildContext context, String branchName) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.admin_branches_deleteTitle),
        content: Text(l10n.admin_branches_deleteConfirmMessage(branchName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.general_cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<BranchesBloc>().add(DeleteBranch(widget.branchId));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: Text(l10n.admin_branches_deleteAction),
          ),
        ],
      ),
    );
  }

  String _formatRevenue(double v) {
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}K';
    return v.toStringAsFixed(0);
  }
}

// Helper widgets for the detail page
class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  const _ContactRow(
      {required this.icon,
        required this.color,
        required this.label,
        required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: TextStyle(color: Colors.grey[500], fontSize: 11)),
          Text(value,
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w500)),
        ]),
      ],
    );
  }
}

class _LabelValue extends StatelessWidget {
  final String label;
  final String value;
  const _LabelValue({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: TextStyle(
              color: Colors.grey[500],
              fontSize: 11,
              fontWeight: FontWeight.w600)),
      const SizedBox(height: 4),
      Text(value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
    ]);
  }
}

class _MiniStatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int count;
  final String label;
  const _MiniStatCard(
      {required this.icon,
        required this.color,
        required this.count,
        required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 6),
        Text('$count',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w700, color: color)),
        Text(label,
            style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ]),
    );
  }
}