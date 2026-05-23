import 'package:flutter/material.dart';

/// Small reusable badge used for invoice status, type, and refund status.
///
/// No hardcoded text here.
/// The parent widget sends the already-localized text.
class MemberInvoiceBadge extends StatelessWidget {
  final String text;
  final Color color;
  final dynamic tokens;

  const MemberInvoiceBadge({
    super.key,
    required this.text,
    required this.color,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: tokens.typography.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 9.5,
        ),
      ),
    );
  }
}