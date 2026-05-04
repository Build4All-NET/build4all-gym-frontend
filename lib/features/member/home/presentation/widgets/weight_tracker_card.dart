import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

class WeightTrackerCard extends StatefulWidget {
  final VoidCallback onDismiss;
  final ValueChanged<double> onWeightSubmitted;

  const WeightTrackerCard({
    super.key,
    required this.onDismiss,
    required this.onWeightSubmitted,
  });

  @override
  State<WeightTrackerCard> createState() => _WeightTrackerCardState();
}

class _WeightTrackerCardState extends State<WeightTrackerCard> {
  final TextEditingController _controller = TextEditingController(text: '75.5');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitWeight() {
    final weight = double.tryParse(_controller.text.trim());
    if (weight == null || weight <= 0) return;

    widget.onWeightSubmitted(weight);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;

    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(tokens.spacing.lg),
        decoration: BoxDecoration(
          color: tokens.colors.success.withOpacity(0.10),
          borderRadius: BorderRadius.circular(22),
          border: Border(
            right: isRtl
                ? BorderSide(
              color: tokens.colors.success,
              width: 4,
            )
                : BorderSide.none,
            left: !isRtl
                ? BorderSide(
              color: tokens.colors.success,
              width: 4,
            )
                : BorderSide.none,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: tokens.colors.success,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.balance_rounded,
                    color: tokens.colors.onPrimary,
                    size: 30,
                  ),
                ),

                SizedBox(width: tokens.spacing.md),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.home_progressTracking,
                        textAlign: isRtl ? TextAlign.end : TextAlign.start,
                        style: tokens.typography.bodyMedium.copyWith(
                          color: tokens.colors.success,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: tokens.spacing.xs),
                      Text(
                        l10n.home_weightTrackerSubtitle,
                        textAlign: isRtl ? TextAlign.end : TextAlign.start,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: tokens.typography.bodySmall.copyWith(
                          color: tokens.colors.body,
                          height: 1.25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: tokens.spacing.sm),

                InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: widget.onDismiss,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: tokens.colors.surface.withOpacity(0.75),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      color: tokens.colors.muted,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: tokens.spacing.lg),

            SizedBox(
              height: 48,
              child: TextField(
                controller: _controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textAlign: isRtl ? TextAlign.right : TextAlign.left,
                decoration: InputDecoration(
                  hintText: l10n.home_weightHint,
                  filled: true,
                  fillColor: tokens.colors.surface.withOpacity(0.75),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: tokens.spacing.lg,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: tokens.colors.border.withOpacity(0.25),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: tokens.colors.border.withOpacity(0.25),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: tokens.colors.success,
                      width: 1.3,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: tokens.spacing.md),

            InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: _submitWeight,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: tokens.spacing.xl,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: tokens.colors.success,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  l10n.home_updateWeightNow,
                  style: tokens.typography.bodyMedium.copyWith(
                    color: tokens.colors.onPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),

    );
  }
}