import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';

/*
 * Small tab button used at the top of My Bookings screen.
 *
 * Design matches Figma:
 * - Both tabs live inside a shared pill container (surface bg + shadow).
 * - Selected tab: white/surface pill with shadow, dark label text.
 * - Unselected tab: transparent, muted label text.
 * - No border on unselected state.
 * - Colors come from ThemeCubit tokens only — nothing hardcoded.
 */
class MemberBookingTabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const MemberBookingTabButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? tokens.colors.background
                : Colors.transparent,
            borderRadius: BorderRadius.circular(
              tokens.button.radius - 2,
            ),
            boxShadow: selected
                ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ]
                : null,
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: tokens.typography.bodyMedium.copyWith(
              color: selected
                  ? tokens.colors.label
                  : tokens.colors.muted,
              fontWeight:
              selected ? FontWeight.w800 : FontWeight.w600,
              fontSize: tokens.button.textSize,
            ),
          ),
        ),
      ),
    );
  }
}