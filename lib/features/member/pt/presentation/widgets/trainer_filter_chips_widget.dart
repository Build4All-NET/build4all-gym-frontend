import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../bloc/member_pt_bloc.dart';

class TrainerFilterChipsWidget extends StatelessWidget {
  final List<String> specialties;
  final String? activeSpecialtyFilter;
  final bool favoritesOnly;
  final int favoriteCount;

  const TrainerFilterChipsWidget({
    super.key,
    required this.specialties,
    required this.activeSpecialtyFilter,
    required this.favoritesOnly,
    required this.favoriteCount,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final chips = <Widget>[
      // ── الكل ──────────────────────────────────────────────────
      _FilterChip(
        label: l10n.ptAll,
        isActive: activeSpecialtyFilter == null && !favoritesOnly,
        onTap: () => context
            .read<MemberPtBloc>()
            .add(const TrainersSpecialtyFilterChanged(null)),
      ),
      // ── المفضلة ───────────────────────────────────────────────
      _FavoritesChip(
        label: favoriteCount > 0
            ? l10n.ptFavoritesWithCount(favoriteCount)
            : l10n.ptFavorites,
        isActive: favoritesOnly,
        onTap: () => context
            .read<MemberPtBloc>()
            .add(const TrainersFavoritesFilterToggled()),
      ),
      // ── Dynamic specialty chips ───────────────────────────────
      ...specialties.map(
            (specialty) => _FilterChip(
          label: specialty,
          isActive: activeSpecialtyFilter == specialty,
          onTap: () => context
              .read<MemberPtBloc>()
              .add(TrainersSpecialtyFilterChanged(specialty)),
        ),
      ),
    ];

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: tokens.spacing.lg),
        reverse: isRtl,
        itemCount: chips.length,
        separatorBuilder: (_, __) => SizedBox(width: tokens.spacing.sm),
        itemBuilder: (_, index) => chips[index],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? tokens.colors.primary : tokens.colors.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isActive
                ? tokens.colors.primary
                : tokens.colors.border.withOpacity(0.3),
          ),
          boxShadow: isActive
              ? [
            BoxShadow(
              color: tokens.colors.primary.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: Text(
          label,
          style: tokens.typography.bodySmall.copyWith(
            color: isActive ? tokens.colors.onPrimary : tokens.colors.body,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _FavoritesChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FavoritesChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? tokens.colors.primary : tokens.colors.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isActive
                ? tokens.colors.primary
                : tokens.colors.border.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              size: 14,
              color:
              isActive ? tokens.colors.onPrimary : tokens.colors.danger,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: tokens.typography.bodySmall.copyWith(
                color:
                isActive ? tokens.colors.onPrimary : tokens.colors.body,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}