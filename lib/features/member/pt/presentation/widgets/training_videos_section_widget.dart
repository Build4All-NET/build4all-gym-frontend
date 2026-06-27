import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../domain/entities/trainer_video_entity.dart';
import '../screens/trainer_video_player_screen.dart';
import 'trainer_video_card_widget.dart';

class TrainingVideosSectionWidget extends StatelessWidget {
  final List<TrainerVideoEntity> videos;
  final bool isSubscribed;

  const TrainingVideosSectionWidget({
    super.key,
    required this.videos,
    this.isSubscribed = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(tokens.spacing.md),
      decoration: BoxDecoration(
        color: tokens.colors.surface,
        borderRadius: BorderRadius.circular(22.0),
        border: Border.all(
          color: tokens.colors.border.withValues(alpha:0.12),
        ),
        boxShadow: tokens.card.showShadow
            ? [
          BoxShadow(
            color: tokens.colors.label.withValues(alpha:0.05),
            blurRadius: 14.0,
            offset: const Offset(0.0, 6.0),
          ),
        ]
            : null,
      ),
      child: Column(
        crossAxisAlignment:
        isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Icon(
                Icons.play_circle_outline_rounded,
                color: tokens.colors.primary,
                size: 22.0,
              ),
              SizedBox(width: tokens.spacing.sm),
              Text(
                l10n.ptTrainingVideosTitle,
                style: tokens.typography.bodyMedium.copyWith(
                  color: tokens.colors.label,
                  fontWeight: FontWeight.w900,
                  fontSize: 17.0,
                ),
              ),
            ],
          ),
          SizedBox(height: tokens.spacing.md),
          if (videos.isEmpty)
            const _EmptyVideosState()
          else ...[
            if (!isSubscribed) _LockedBanner(isRtl: isRtl),
            if (!isSubscribed) SizedBox(height: tokens.spacing.sm),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: videos.length,
              separatorBuilder: (_, __) => SizedBox(
                height: tokens.spacing.sm,
              ),
              itemBuilder: (context, index) {
                final video = videos[index];

                return TrainerVideoCardWidget(
                  video: video,
                  isLocked: !isSubscribed,
                  onTap: () {
                    final videoUrl = video.videoUrl.trim();

                    debugPrint('OPEN VIDEO URL: $videoUrl');

                    if (videoUrl.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.ptTrainingVideosMissingUrl),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TrainerVideoPlayerScreen(
                          video: video,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _LockedBanner extends StatelessWidget {
  final bool isRtl;

  const _LockedBanner({required this.isRtl});

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: tokens.spacing.md,
        vertical: tokens.spacing.sm + 2.0,
      ),
      decoration: BoxDecoration(
        color: tokens.colors.primary.withValues(alpha:0.08),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: tokens.colors.primary.withValues(alpha:0.18),
        ),
      ),
      child: Row(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1.0),
            child: Icon(
              Icons.lock_rounded,
              color: tokens.colors.primary,
              size: 16.0,
            ),
          ),
          SizedBox(width: tokens.spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment:
              isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.ptVideosLockedTitle,
                  textAlign: isRtl ? TextAlign.right : TextAlign.left,
                  style: tokens.typography.bodySmall.copyWith(
                    color: tokens.colors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 13.0,
                  ),
                ),
                SizedBox(height: 2.0),
                Text(
                  l10n.ptVideosLockedSubtitle,
                  textAlign: isRtl ? TextAlign.right : TextAlign.left,
                  style: tokens.typography.bodySmall.copyWith(
                    color: tokens.colors.primary.withValues(alpha:0.75),
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyVideosState extends StatelessWidget {
  const _EmptyVideosState();

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: tokens.spacing.lg,
        horizontal: tokens.spacing.md,
      ),
      decoration: BoxDecoration(
        color: tokens.colors.background,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: tokens.colors.border.withValues(alpha:0.10),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.video_library_outlined,
            color: tokens.colors.muted,
            size: 36.0,
          ),
          SizedBox(height: tokens.spacing.sm),
          Text(
            l10n.ptTrainingVideosEmpty,
            textAlign: TextAlign.center,
            style: tokens.typography.bodySmall.copyWith(
              color: tokens.colors.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
