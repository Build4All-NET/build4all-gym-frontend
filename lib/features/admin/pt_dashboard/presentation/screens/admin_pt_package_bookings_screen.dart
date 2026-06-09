import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../data/services/admin_pt_package_booking_service.dart';

class AdminPtPackageBookingsScreen extends StatefulWidget {
  const AdminPtPackageBookingsScreen({super.key});

  @override
  State<AdminPtPackageBookingsScreen> createState() =>
      _AdminPtPackageBookingsScreenState();
}

class _AdminPtPackageBookingsScreenState
    extends State<AdminPtPackageBookingsScreen> {
  final _service = AdminPtPackageBookingService();

  List<Map<String, dynamic>> _bookings = [];
  bool _loading = true;
  String? _error;
  final Set<int> _confirming = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await _service.getPendingCash();
      if (mounted) setState(() {
        _bookings = data;
        _loading = false;
      });
    } catch (e) {
      if (mounted) setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _confirmCash(int bookingId) async {
    setState(() => _confirming.add(bookingId));
    try {
      await _service.confirmCash(bookingId);
      if (mounted) {
        setState(() {
          _bookings.removeWhere((b) => (b['id'] as num?)?.toInt() == bookingId);
          _confirming.remove(bookingId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.trainer_cashPaymentConfirmed)),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _confirming.remove(bookingId));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c = tokens.colors;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.surface,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.navPtPackageBookings,
          style: tokens.typography.titleMedium.copyWith(
            color: c.label,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_outlined, color: c.label),
            onPressed: _loading ? null : _load,
          ),
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: c.primary))
          : _error != null
              ? _ErrorView(error: _error!, onRetry: _load, tokens: tokens)
              : _bookings.isEmpty
                  ? _EmptyView(tokens: tokens)
                  : RefreshIndicator(
                      onRefresh: _load,
                      color: c.primary,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _bookings.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, index) {
                          final b = _bookings[index];
                          final id = (b['id'] as num?)?.toInt() ?? 0;
                          return _BookingCard(
                            booking: b,
                            isConfirming: _confirming.contains(id),
                            tokens: tokens,
                            onConfirm: () => _confirmCash(id),
                          );
                        },
                      ),
                    ),
    );
  }
}

// ── Booking card ──────────────────────────────────────────────────────────────

class _BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  final bool isConfirming;
  final dynamic tokens;
  final VoidCallback onConfirm;

  const _BookingCard({
    required this.booking,
    required this.isConfirming,
    required this.tokens,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final c    = tokens.colors;
    final l10n = AppLocalizations.of(context)!;

    final id = (booking['id'] as num?)?.toInt() ?? 0;
    final totalAmount = (booking['totalAmount'] as num?)?.toDouble() ?? 0.0;
    final status = booking['status'] as String? ?? '';
    final paymentStatus = booking['paymentStatus'] as String? ?? '';
    final createdAt = booking['createdAt'] as String?;

    String formattedDate = '';
    if (createdAt != null) {
      try {
        formattedDate = DateFormat('yyyy-MM-dd HH:mm')
            .format(DateTime.parse(createdAt));
      } catch (_) {
        formattedDate = createdAt;
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.border.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3CD),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'CASH',
                  style: tokens.typography.bodySmall.copyWith(
                    color: const Color(0xFF856404),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: c.primary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: tokens.typography.bodySmall.copyWith(
                    color: c.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '\$ ${totalAmount.toStringAsFixed(2)}',
                style: tokens.typography.headlineSmall.copyWith(
                  color: c.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _Row(label: l10n.trainer_bookingId, value: '#$id', tokens: tokens),
          if (formattedDate.isNotEmpty)
            _Row(label: l10n.trainer_dateLabel, value: formattedDate, tokens: tokens),
          _Row(label: l10n.trainer_paymentStatusLabel, value: paymentStatus, tokens: tokens),
          const SizedBox(height: 16),
          SizedBox(
            height: 46,
            child: ElevatedButton.icon(
              onPressed: isConfirming ? null : onConfirm,
              icon: isConfirming
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: c.onPrimary,
                      ),
                    )
                  : const Icon(Icons.check_circle_outline, size: 18),
              label: Text(isConfirming ? l10n.trainer_confirming : l10n.trainer_confirmCashPayment),
              style: ElevatedButton.styleFrom(
                backgroundColor: c.success,
                foregroundColor: Colors.white,
                disabledBackgroundColor: c.success.withOpacity(0.5),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final dynamic tokens;

  const _Row({required this.label, required this.value, required this.tokens});

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: tokens.typography.bodySmall.copyWith(color: c.muted),
          ),
          Expanded(
            child: Text(
              value,
              style: tokens.typography.bodySmall.copyWith(
                color: c.label,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty / Error views ───────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  final dynamic tokens;

  const _EmptyView({required this.tokens});

  @override
  Widget build(BuildContext context) {
    final c    = tokens.colors;
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline, size: 56, color: c.success),
          const SizedBox(height: 16),
          Text(
            l10n.trainer_noPendingCashPayments,
            style: tokens.typography.titleMedium.copyWith(
              color: c.label,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.trainer_allPtPackagesConfirmed,
            style: tokens.typography.bodyMedium.copyWith(color: c.muted),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  final dynamic tokens;

  const _ErrorView({
    required this.error,
    required this.onRetry,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: c.danger),
          const SizedBox(height: 12),
          Text(error, style: tokens.typography.bodyMedium.copyWith(color: c.muted)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(AppLocalizations.of(context)!.retry),
          ),
        ],
      ),
    );
  }
}
