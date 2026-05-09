import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';

import '../../domain/entities/pt_package_entity.dart';
import '../bloc/pt_package_booking_bloc.dart';
import '../bloc/pt_package_booking_event.dart';

/// Scrollable PT package cards.
///
/// Logic stays the same:
/// - User selects one package.
/// - Bloc receives PtPackageSelected(package).
/// - No packageType logic.
/// - The displayed title comes from package.name.
/// - Sessions/duration/price come from numeric fields.
class PtPackageSelectorWidget extends StatelessWidget {
  final List<PtPackageEntity> packages;
  final PtPackageEntity? selectedPackage;

  const PtPackageSelectorWidget({
    super.key,
    required this.packages,
    required this.selectedPackage,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: isRtl,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: tokens.spacing.xs,
      ),
      child: IntrinsicHeight(
        child: Row(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int index = 0; index < packages.length; index++) ...[
              _PackageCard(
                package: packages[index],
                isSelected: selectedPackage?.id == packages[index].id,
                onTap: () {
                  context.read<PtPackageBookingBloc>().add(
                    PtPackageSelected(packages[index]),
                  );
                },
              ),
              if (index != packages.length - 1)
                SizedBox(width: tokens.spacing.md),
            ],
          ],
        ),
      ),
    );
  }
}

/// One package card.
///
/// Figma-style:
/// - selected card is green
/// - unselected cards are white
/// - package name is the main title
/// - no logic based on packageType/name/language
class _PackageCard extends StatelessWidget {
  final PtPackageEntity package;
  final bool isSelected;
  final VoidCallback onTap;

  const _PackageCard({
    required this.package,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    // Sale exists only when backend sent salePrice and finalPrice is lower.
    final hasSale =
        package.salePrice != null && package.finalPrice < package.price;

    // Example:
    // price = 160
    // finalPrice = 140
    // discount = 13%
    final discountPercent = hasSale && package.price > 0
        ? (((package.price - package.finalPrice) / package.price) * 100).round()
        : 0;

    final backgroundColor =
    isSelected ? tokens.colors.primary : tokens.colors.surface;

    final mainTextColor =
    isSelected ? tokens.colors.onPrimary : tokens.colors.label;

    final mutedTextColor = isSelected
        ? tokens.colors.onPrimary.withOpacity(0.82)
        : tokens.colors.muted;

    final priceColor =
    isSelected ? tokens.colors.onPrimary : tokens.colors.primary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        // Fixed width so the card does NOT shrink/grow when selected.
        width: 265.0,
        padding: EdgeInsets.all(tokens.spacing.lg),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(26.0),
          border: Border.all(
            color: isSelected
                ? tokens.colors.primary
                : tokens.colors.border.withOpacity(0.18),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: tokens.colors.label.withOpacity(
                isSelected ? 0.16 : 0.07,
              ),
              blurRadius: isSelected ? 24.0 : 14.0,
              offset: const Offset(0.0, 8.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
          isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Package name from backend/admin/PT.
            Text(
              package.name,
              textAlign: isRtl ? TextAlign.right : TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tokens.typography.bodyMedium.copyWith(
                color: mainTextColor,
                fontWeight: FontWeight.w900,
                fontSize: isSelected ? 21.0 : 17.0,
              ),
            ),

            SizedBox(height: tokens.spacing.xs),

            // Sessions + duration.
            // Language-safe: uses numeric fields, not packageType.
            Text(
              '${package.numberOfSessions} ${l10n.ptPackageSessions} • '
                  '${package.daysAvailable} ${l10n.ptPackageDays}',
              textAlign: isRtl ? TextAlign.right : TextAlign.left,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tokens.typography.bodySmall.copyWith(
                color: mutedTextColor,
                fontWeight: FontWeight.w700,
                fontSize: 13.0,
              ),
            ),

            SizedBox(height: tokens.spacing.md),
// Weekly days limit block.
// Shows how many training days/week the member can choose.
// Example:
// minDaysPerWeek = 1
// maxDaysPerWeek = 2
//
// UI:
// 1 - 2
// days/week
            Row(
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              mainAxisAlignment:
              isRtl ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Container(
                  width: 44.0,
                  height: 44.0,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? tokens.colors.onPrimary.withOpacity(0.14)
                        : tokens.colors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Icon(
                    Icons.calendar_view_week_rounded,
                    color: isSelected
                        ? tokens.colors.onPrimary
                        : tokens.colors.primary,
                    size: 22.0,
                  ),
                ),

                SizedBox(width: tokens.spacing.sm),

                Column(
                  crossAxisAlignment:
                  isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      package.minDaysPerWeek == package.maxDaysPerWeek
                          ? package.minDaysPerWeek.toString()
                          : '${package.minDaysPerWeek} - ${package.maxDaysPerWeek}',
                      style: tokens.typography.bodyMedium.copyWith(
                        color: mainTextColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 24.0,
                      ),
                    ),

                    Text(
                      package.minDaysPerWeek == package.maxDaysPerWeek
                          ? l10n.ptPackageDaysPerWeekExact(package.minDaysPerWeek)
                          : l10n.ptPackageDaysPerWeekRange(
                        package.minDaysPerWeek,
                        package.maxDaysPerWeek,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tokens.typography.bodySmall.copyWith(
                        color: mutedTextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 11.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: tokens.spacing.md),

            // Divider like Figma.
            Container(
              height: 1.0,
              color: isSelected
                  ? tokens.colors.onPrimary.withOpacity(0.18)
                  : tokens.colors.border.withOpacity(0.18),
            ),

            SizedBox(height: tokens.spacing.md),

            // Price area.
            //
            // Final result:
            // top row:    [-13%]                 $160
            // bottom row: $140   Final price
            Column(
              crossAxisAlignment:
              isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // Top row: discount badge + old crossed price.
                if (hasSale)
                  Row(
                    textDirection:
                    isRtl ? TextDirection.rtl : TextDirection.ltr,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Discount percentage pill.
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: tokens.spacing.sm,
                          vertical: tokens.spacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? tokens.colors.onPrimary.withOpacity(0.15)
                              : tokens.colors.primary.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(999.0),
                        ),
                        child: Text(
                          '-$discountPercent%',
                          style: tokens.typography.bodySmall.copyWith(
                            color: isSelected
                                ? tokens.colors.onPrimary
                                : tokens.colors.primary,
                            fontWeight: FontWeight.w900,
                            fontSize: 11.0,
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Old price.
                      Text(
                        '\$${package.price.toStringAsFixed(0)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: tokens.typography.bodySmall.copyWith(
                          color: mutedTextColor,
                          decoration: TextDecoration.lineThrough,
                          fontWeight: FontWeight.w700,
                          fontSize: 11.0,
                        ),
                      ),
                    ],
                  ),

                if (hasSale) SizedBox(height: tokens.spacing.sm),

                // Bottom row: final price + label on same level.
                Row(
                  textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Final price.
                    Text(
                      '\$${package.finalPrice.toStringAsFixed(0)}',
                      textAlign: isRtl ? TextAlign.right : TextAlign.left,
                      style: tokens.typography.headlineSmall.copyWith(
                        color: priceColor,
                        fontWeight: FontWeight.w900,
                        fontSize: isSelected ? 30.0 : 25.0,
                      ),
                    ),

                    SizedBox(width: tokens.spacing.sm),

                    // Final price label beside the price.
                    Flexible(
                      child: Text(
                        l10n.ptPackageFinalPrice,
                        textAlign: isRtl ? TextAlign.right : TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: tokens.typography.bodySmall.copyWith(
                          color: mutedTextColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}