// ─────────────────────────────────────────────────────────────────────────────
// FILE: pages/branch_detail_page.dart  (GA-428)
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/branches_bloc.dart';
import '../bloc/branches_event.dart';
import '../bloc/branches_state.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF1A1A2E)),
        title: const Text(
          'Branch Detail',
          style: TextStyle(
              color: Color(0xFF1A1A2E),
              fontWeight: FontWeight.w700,
              fontSize: 18),
        ),
      ),
      body: BlocBuilder<BranchesBloc, BranchesState>(
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
                            d.isActive ? 'Active' : 'Inactive',
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
                          label: 'PHONE',
                          value: d.phone!),
                    if (d.email != null) ...[
                      const Divider(height: 20),
                      _ContactRow(
                          icon: Icons.email_outlined,
                          color: const Color(0xFF8B5CF6),
                          label: 'EMAIL',
                          value: d.email!),
                    ],
                    if (d.address != null) ...[
                      const Divider(height: 20),
                      _LabelValue(label: 'ADDRESS', value: d.address!),
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
                          label: 'Members',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _MiniStatCard(
                          icon: Icons.fitness_center,
                          color: const Color(0xFF8B5CF6),
                          count: d.trainerCount,
                          label: 'Trainers',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _MiniStatCard(
                          icon: Icons.manage_accounts,
                          color: const Color(0xFF10B981),
                          count: d.staffCount,
                          label: 'Staff',
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
                                  'Monthly Revenue',
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
                            const Icon(Icons.chevron_right,
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