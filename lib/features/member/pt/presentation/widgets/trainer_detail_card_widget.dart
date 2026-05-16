import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/config/env.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../domain/entities/trainer_detail_entity.dart';

class TrainerDetailCardWidget extends StatelessWidget {
  final TrainerDetailEntity trainer;
  final VoidCallback? onFavoritePressed;
  final bool isFavoriteLoading;

  const TrainerDetailCardWidget({
    super.key,
    required this.trainer,
    this.onFavoritePressed,
    this.isFavoriteLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: tokens.colors.surface,
        borderRadius: BorderRadius.circular(22.0),
        border: Border.all(
          color: tokens.colors.border.withOpacity(0.10),
        ),
        boxShadow: [
          BoxShadow(
            color: tokens.colors.label.withOpacity(0.06),
            blurRadius: 18.0,
            offset: const Offset(0.0, 6.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(tokens.spacing.md),
            child: Row(
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    end: tokens.spacing.sm,
                    top: tokens.spacing.xs,
                  ),
                  child: GestureDetector(
                    onTap: isFavoriteLoading ? null : onFavoritePressed,
                    behavior: HitTestBehavior.opaque,
                    child: SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child: isFavoriteLoading
                          ? Center(
                        child: SizedBox(
                          width: 18.0,
                          height: 18.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            color: tokens.colors.primary,
                          ),
                        ),
                      )
                          : Icon(
                        trainer.isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: trainer.isFavorite
                            ? tokens.colors.danger
                            : tokens.colors.muted,
                        size: 24.0,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: isRtl
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        trainer.fullName,
                        textAlign: isRtl ? TextAlign.right : TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: tokens.typography.bodyMedium.copyWith(
                          color: tokens.colors.label,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      if (trainer.branchName != null &&
                          trainer.branchName!.trim().isNotEmpty) ...[
                        SizedBox(height: tokens.spacing.xs),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 15.0,
                              color: tokens.colors.primary,
                            ),
                            SizedBox(width: tokens.spacing.xs),
                            Flexible(
                              child: Text(
                                trainer.branchName!,
                                textAlign: isRtl ? TextAlign.right : TextAlign.left,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: tokens.typography.bodySmall.copyWith(
                                  color: tokens.colors.body,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],

                      SizedBox(height: tokens.spacing.sm),

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        textDirection:
                        isRtl ? TextDirection.rtl : TextDirection.ltr,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: tokens.colors.success,
                            size: 18.0,
                          ),
                          SizedBox(width: tokens.spacing.xs),
                          Text(
                            trainer.rating.toStringAsFixed(1),
                            style: tokens.typography.bodySmall.copyWith(
                              color: tokens.colors.label,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(width: tokens.spacing.xs),
                          Text(
                            '• ${trainer.reviewCount}',
                            style: tokens.typography.bodySmall.copyWith(
                              color: tokens.colors.muted,
                            ),
                          ),
                        ],
                      ),

                      if (trainer.certifications != null &&
                          trainer.certifications!.isNotEmpty) ...[
                        SizedBox(height: tokens.spacing.md),
                        Wrap(
                          spacing: tokens.spacing.sm,
                          runSpacing: tokens.spacing.sm,
                          textDirection:
                          isRtl ? TextDirection.rtl : TextDirection.ltr,
                          children: trainer.certifications!
                              .map(
                                (cert) => _CertChip(
                              label: cert,
                              tokens: tokens,
                            ),
                          )
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),

                SizedBox(width: tokens.spacing.sm),

                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: SizedBox(
                    width: 90.0,
                    height: 90.0,
                    child: trainer.photoUrl != null &&
                        trainer.photoUrl!.trim().isNotEmpty
                        ? Image.network(
                      _resolveMediaUrl(trainer.photoUrl!),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _imagePlaceholder(tokens),
                    )
                        : _imagePlaceholder(tokens),
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: tokens.spacing.md,
            ),
            decoration: BoxDecoration(
              color: tokens.colors.primary.withOpacity(0.10),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(22.0),
              ),
            ),
            child: Text(
              '${trainer.pricePerSession.toStringAsFixed(0)}\$ / ${l10n.ptDetailSession}',
              textAlign: TextAlign.center,
              style: tokens.typography.bodyMedium.copyWith(
                color: tokens.colors.primary,
                fontWeight: FontWeight.w800,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder(dynamic tokens) {
    return Container(
      color: tokens.colors.primary.withOpacity(0.10),
      child: Icon(
        Icons.person_rounded,
        color: tokens.colors.primary,
        size: 44.0,
      ),
    );
  }

  String _resolveMediaUrl(String rawUrl) {
    if (rawUrl.startsWith('http://') || rawUrl.startsWith('https://')) {
      return rawUrl;
    }

    if (rawUrl.startsWith('/')) {
      return '${Env.apiProjectBaseUrl}$rawUrl';
    }

    return '${Env.apiProjectBaseUrl}/$rawUrl';
  }
}
class _CertChip extends StatelessWidget {
  final String label;
  final dynamic tokens;

  const _CertChip({
    required this.label,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return ConstrainedBox(
      constraints: BoxConstraints(
        // Arabic needs more width. English stays the same.
        maxWidth: isRtl ? 230.0 : 160.0,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: tokens.spacing.sm,
          vertical: tokens.spacing.xs,
        ),
        decoration: BoxDecoration(
          color: tokens.colors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: tokens.colors.primary.withOpacity(0.25),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Icon(
              Icons.workspace_premium_rounded,
              size: 13.0,
              color: tokens.colors.primary,
            ),
            SizedBox(width: tokens.spacing.xs),
            Flexible(
              child: Text(
                label,
                maxLines: isRtl ? 2 : 1,
                overflow: TextOverflow.ellipsis,
                softWrap: isRtl,
                textAlign: isRtl ? TextAlign.right : TextAlign.left,
                style: tokens.typography.bodySmall.copyWith(
                  color: tokens.colors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}