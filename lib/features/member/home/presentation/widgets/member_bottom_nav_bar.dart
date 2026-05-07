import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

class MemberBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const MemberBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.read<ThemeCubit>().state.tokens;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: tokens.colors.surface,
      elevation: 0,
      selectedItemColor: tokens.colors.primary,
      unselectedItemColor: tokens.colors.muted,
      selectedLabelStyle: tokens.typography.bodySmall.copyWith(
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: tokens.typography.bodySmall.copyWith(
        fontWeight: FontWeight.w500,
      ),
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined),
          activeIcon: const Icon(Icons.home_rounded),
          label: l10n.memberBottomNavHome,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.credit_card_outlined),
          activeIcon: const Icon(Icons.credit_card_rounded),
          label: l10n.memberBottomNavPlans,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.qr_code_2_rounded),
          activeIcon: const Icon(Icons.qr_code_2_rounded),
          label: l10n.memberBottomNavQr,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.calendar_today_outlined),
          activeIcon: const Icon(Icons.calendar_today_rounded),
          label: l10n.memberBottomNavClasses,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person_outline_rounded),
          activeIcon: const Icon(Icons.person_rounded),
          label: l10n.memberBottomNavAccount,
        ),
      ],
    );
  }
}