import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../domain/entities/session_card_entity.dart';
import '../bloc/sessions_bloc.dart';
import '../bloc/sessions_event.dart';
import '../screens/session_detail_screen.dart';

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
        errorBuilder: (_, __, ___) => _buildImagePlaceholder(context),
      )
          : _buildImagePlaceholder(context),
    );

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: tokens.spacing.sm,
        vertical: tokens.spacing.sm,
      ),
      decoration: BoxDecoration(
        color: tokens.colors.surface,
        borderRadius: BorderRadius.circular(tokens.card.radius),
        border: Border.all(color: tokens.colors.primary.withOpacity(0.15)),
        boxShadow: tokens.card.showShadow
            ? [
          BoxShadow(
            color: tokens.colors.primary.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ]
            : null,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(tokens.card.padding),
            child: Row(
              textDirection:
              isArabic ? TextDirection.rtl : TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                imageBox,
                SizedBox(width: tokens.spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: isArabic
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      // Difficulty badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: difficultyColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          _difficultyLabel(context, session.difficultyLevel),
                          style: tokens.typography.bodySmall.copyWith(
                            color: difficultyColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        session.className,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign:
                        isArabic ? TextAlign.right : TextAlign.left,
                        style: tokens.typography.titleMedium.copyWith(
                          fontWeight: FontWeight.w800,
                          color: tokens.colors.label,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isArabic
                            ? 'مع ${session.trainerName}'
                            : 'with ${session.trainerName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign:
                        isArabic ? TextAlign.right : TextAlign.left,
                        style: tokens.typography.bodySmall.copyWith(
                          color: tokens.colors.body,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Room + duration
                      Row(
                        mainAxisAlignment: isArabic
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Icon(Icons.access_time_rounded,
                              size: 13, color: tokens.colors.muted),
                          const SizedBox(width: 3),
                          Text(
                            l10n.memberSessionsMinute(
                                session.durationMinutes),
                            style: tokens.typography.bodySmall.copyWith(
                              color: tokens.colors.body,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(Icons.location_on_rounded,
                              size: 13, color: tokens.colors.muted),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              _locationText(session),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: tokens.typography.bodySmall.copyWith(
                                color: tokens.colors.body,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Price + seats + Book Now
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        textDirection: isArabic
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        children: [
                          // Price + seats
                          Column(
                            crossAxisAlignment: isArabic
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                '\$${session.price.toStringAsFixed(2)}',
                                style:
                                tokens.typography.titleMedium.copyWith(
                                  color: tokens.colors.primary,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                l10n.memberSessionsSeatsAvailable(
                                    session.availableSeats),
                                style: tokens.typography.bodySmall.copyWith(
                                  color: isLowSeats
                                      ? tokens.colors.danger
                                      : tokens.colors.success,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          // Book Now button — fixed width + height
                          SizedBox(
                            width: 110,
                            height: 44,
                            child: ElevatedButton(
                              onPressed: () async {
                                final listBloc = context.read<SessionsBloc>();

                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider(
                                      create: (_) => SessionsBloc(
                                        getSessionsUseCase: listBloc.getSessionsUseCase,
                                        bookSessionUseCase: listBloc.bookSessionUseCase,
                                        cancelBookingUseCase: listBloc.cancelBookingUseCase,
                                        getFilterOptionsUseCase: listBloc.getFilterOptionsUseCase,
                                        getSessionDetailUseCase: listBloc.getSessionDetailUseCase,
                                      ),
                                      child: SessionDetailScreen(
                                        sessionId: session.sessionId,
                                      ),
                                    ),
                                  ),
                                );

                                if (context.mounted) {
                                  listBloc.add(const SessionsStarted());
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: tokens.colors.primary,
                                foregroundColor: tokens.colors.onPrimary,
                                elevation: 0,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      tokens.button.radius),
                                ),
                              ),
                              child: Text(
                                l10n.memberSessionsBookNow,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
      child:
      Icon(Icons.fitness_center, color: tokens.colors.primary, size: 34),
    );
  }
  String _locationText(SessionCardEntity session) {
    final branch = session.branchName?.trim();
    final room = session.roomName?.trim();

    if (branch != null && branch.isNotEmpty && room != null && room.isNotEmpty) {
      return '$branch · $room';
    }

    if (branch != null && branch.isNotEmpty) {
      return branch;
    }

    if (room != null && room.isNotEmpty) {
      return room;
    }

    return '-';
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