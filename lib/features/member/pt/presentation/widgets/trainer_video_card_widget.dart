import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/config/env.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../domain/entities/trainer_video_entity.dart';

class TrainerVideoCardWidget extends StatelessWidget {
  final TrainerVideoEntity video;
  final VoidCallback? onTap;
  final bool isLocked;

  const TrainerVideoCardWidget({
    super.key,
    required this.video,
    this.onTap,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return InkWell(
      onTap: isLocked ? null : onTap,
      borderRadius: BorderRadius.circular(tokens.card.radius),
      child: Container(
        width: 155.0,
        margin: EdgeInsetsDirectional.only(
          end: tokens.spacing.md,
        ),
        decoration: BoxDecoration(
          color: tokens.colors.surface,
          borderRadius: BorderRadius.circular(tokens.card.radius),
          border: Border.all(
            color: tokens.colors.border.withOpacity(0.12),
          ),
          boxShadow: tokens.card.showShadow
              ? [
            BoxShadow(
              color: tokens.colors.label.withOpacity(0.06),
              blurRadius: 12.0,
              offset: const Offset(0.0, 5.0),
            ),
          ]
              : null,
        ),
        child: Column(
          crossAxisAlignment:
          isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(tokens.card.radius),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 95.0,
                    width: double.infinity,
                    child: video.thumbnailUrl != null &&
                        video.thumbnailUrl!.trim().isNotEmpty
                        ? Image.network(
                      _resolveMediaUrl(video.thumbnailUrl!),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _thumbnailPlaceholder(context),
                    )
                        : _thumbnailPlaceholder(context),
                  ),

                  if (isLocked)
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                        child: Container(
                          color: Colors.black.withOpacity(0.45),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lock_rounded,
                                color: Colors.white,
                                size: 26.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      width: 38.0,
                      height: 38.0,
                      decoration: BoxDecoration(
                        color: tokens.colors.label.withOpacity(0.48),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: tokens.colors.surface,
                        size: 30.0,
                      ),
                    ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(tokens.spacing.sm),
              child: Column(
                crossAxisAlignment:
                isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: isRtl ? TextAlign.right : TextAlign.left,
                    style: tokens.typography.bodySmall.copyWith(
                      color: isLocked
                          ? tokens.colors.muted
                          : tokens.colors.label,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  if (video.duration != null &&
                      video.duration!.trim().isNotEmpty) ...[
                    SizedBox(height: tokens.spacing.xs),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      textDirection:
                      isRtl ? TextDirection.rtl : TextDirection.ltr,
                      children: [
                        Icon(
                          isLocked
                              ? Icons.lock_outline_rounded
                              : Icons.schedule_rounded,
                          size: 13.0,
                          color: tokens.colors.muted,
                        ),
                        SizedBox(width: tokens.spacing.xs),
                        Text(
                          isLocked ? '- : --' : video.duration!,
                          style: tokens.typography.bodySmall.copyWith(
                            color: tokens.colors.muted,
                            fontSize: 11.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _thumbnailPlaceholder(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return Container(
      color: tokens.colors.primary.withOpacity(0.10),
      child: Icon(
        Icons.play_circle_outline_rounded,
        color: tokens.colors.primary,
        size: 38.0,
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
