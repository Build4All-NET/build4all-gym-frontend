import 'package:flutter/material.dart';

/// Empty state used when the member has no invoices.
class MemberInvoiceEmptyView extends StatelessWidget {
  final dynamic tokens;
  final String title;
  final String subtitle;

  const MemberInvoiceEmptyView({
    super.key,
    required this.tokens,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long_outlined, color: c.muted, size: 56),
            const SizedBox(height: 16),
            Text(
              title,
              style: tokens.typography.titleMedium.copyWith(
                color: c.label,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: tokens.typography.bodyMedium.copyWith(color: c.muted),
            ),
          ],
        ),
      ),
    );
  }
}