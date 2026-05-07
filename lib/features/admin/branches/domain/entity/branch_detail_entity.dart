// ─────────────────────────────────────────────────────────────────────────────
// FILE: features/admin/branches/domain/entity/branch_detail_entity.dart
// Full detail shown on Branch Detail screen
// ─────────────────────────────────────────────────────────────────────────────
import 'package:equatable/equatable.dart';

class BranchDetailEntity extends Equatable {
  final String branchId;
  final String name;
  final String? city;
  final String status;
  final String? phone;
  final String? email;
  final String? address;
  final String? openingTime;
  final String? closingTime;
  final int memberCount;
  final int trainerCount;
  final int staffCount;
  final double monthlyRevenue;

  const BranchDetailEntity({
    required this.branchId,
    required this.name,
    this.city,
    required this.status,
    this.phone,
    this.email,
    this.address,
    this.openingTime,
    this.closingTime,
    required this.memberCount,
    required this.trainerCount,
    required this.staffCount,
    required this.monthlyRevenue,
  });

  bool get isActive => status == 'ACTIVE';

  // Format operating hours as "6 AM - 10 PM" for display
  String get hoursDisplay {
    if (openingTime == null || closingTime == null) return '—';
    return '${_toAmPm(openingTime!)} - ${_toAmPm(closingTime!)}';
  }

  String _toAmPm(String hhmm) {
    final parts = hhmm.split(':');
    final h = int.parse(parts[0]);
    final suffix = h >= 12 ? 'PM' : 'AM';
    final display = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    return '$display $suffix';
  }

  @override
  List<Object?> get props => [branchId, status];
}
