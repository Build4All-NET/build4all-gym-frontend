import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../domain/entities/session_card_entity.dart';
import '../bloc/sessions_bloc.dart';
import '../bloc/sessions_event.dart';

class SessionCardWidget extends StatelessWidget {
  final SessionCardEntity session;

  const SessionCardWidget({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final isLowSeats = session.availableSeats <= 3;
    final difficultyColor = _difficultyColor(context, session.difficultyLevel);

    final imageBox = ClipRRect(
      borderRadius: BorderRadius.circular(tokens.card.radius),
      child: session.imageFileId != null
          ? Image.network(
        'http://localhost:8080/api/files/${session.imageFileId}',
        width: 96,
        height: 96,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return _buildImagePlaceholder(context);
        },
      )
          : _buildImagePlaceholder(context),
    );

    final content = Expanded(
      child: Column(
        crossAxisAlignment:
        isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            session.className,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: isArabic ? TextAlign.right : TextAlign.left,
            style: tokens.typography.titleMedium.copyWith(
              fontWeight: FontWeight.w800,
              color: tokens.colors.label,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            session.trainerName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: isArabic ? TextAlign.right : TextAlign.left,
            style: tokens.typography.bodyMedium.copyWith(
              color: tokens.colors.body,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            alignment: isArabic ? WrapAlignment.end : WrapAlignment.start,
            spacing: 8,
            runSpacing: 6,
            children: [
              _InfoChip(
                text: session.roomName == null || session.roomName!.isEmpty
                    ? '-'
                    : l10n.memberSessionsRoom(session.roomName!),
              ),
              _InfoChip(
                text: l10n.memberSessionsMinute(session.durationMinutes),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment:
            isArabic ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              _Badge(
                text: _difficultyLabel(context, session.difficultyLevel),
                color: difficultyColor,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.memberSessionsSeatsAvailable(session.availableSeats),
                style: tokens.typography.bodySmall.copyWith(
                  color:
                  isLowSeats ? tokens.colors.danger : tokens.colors.success,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 260;
              final buttonWidth =
              (constraints.maxWidth * 0.48).clamp(110.0, 170.0);

              if (isNarrow) {
                return Column(
                  crossAxisAlignment: isArabic
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${session.price.toStringAsFixed(2)}',
                      style: tokens.typography.titleMedium.copyWith(
                        color: tokens.colors.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 38,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<SessionsBloc>().add(
                            SessionBookRequested(session.sessionId),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tokens.colors.primary,
                          foregroundColor: tokens.colors.onPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              tokens.button.radius,
                            ),
                          ),
                        ),
                        child: Text(
                          l10n.memberSessionsBookNow,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: tokens.button.textSize,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textDirection:
                isArabic ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  Text(
                    '\$${session.price.toStringAsFixed(2)}',
                    style: tokens.typography.titleMedium.copyWith(
                      color: tokens.colors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(
                    width: buttonWidth,
                    height: 38,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<SessionsBloc>().add(
                          SessionBookRequested(session.sessionId),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tokens.colors.primary,
                        foregroundColor: tokens.colors.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            tokens.button.radius,
                          ),
                        ),
                      ),
                      child: Text(
                        l10n.memberSessionsBookNow,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: tokens.button.textSize,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          )
        ],
      ),
    );

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: tokens.spacing.lg,
        vertical: tokens.spacing.sm,
      ),
      padding: EdgeInsets.all(tokens.card.padding),
      decoration: BoxDecoration(
        color: tokens.colors.surface,
        borderRadius: BorderRadius.circular(tokens.card.radius),
        border: tokens.card.showBorder
            ? Border.all(color: tokens.colors.border.withOpacity(0.18))
            : null,
        boxShadow: tokens.card.showShadow
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ]
            : null,
      ),
      child: Row(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageBox,
          SizedBox(width: tokens.spacing.md),
          content,
        ],
      ),
    );
  }
  Widget _buildImagePlaceholder(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        color: tokens.colors.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(tokens.card.radius),
      ),
      child: Icon(
        Icons.fitness_center,
        color: tokens.colors.primary,
        size: 34,
      ),
    );
  }
  Color _difficultyColor(BuildContext context, String level) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    switch (level.toUpperCase()) {
      case 'BEGINNER':
        return tokens.colors.success;
      case 'INTERMEDIATE':
        return Colors.orange;
      case 'ADVANCED':
        return tokens.colors.danger;
      default:
        return tokens.colors.muted;
    }
  }

  String _difficultyLabel(BuildContext context, String level) {
    final l10n = AppLocalizations.of(context)!;

    switch (level.toUpperCase()) {
      case 'BEGINNER':
        return l10n.memberSessionsDifficultyBeginner;
      case 'INTERMEDIATE':
        return l10n.memberSessionsDifficultyIntermediate;
      case 'ADVANCED':
        return l10n.memberSessionsDifficultyAdvanced;
      default:
        return level;
    }
  }
}

class _InfoChip extends StatelessWidget {
  final String text;

  const _InfoChip({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: tokens.colors.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: tokens.typography.bodySmall.copyWith(
          color: tokens.colors.body,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;

  const _Badge({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: tokens.typography.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}