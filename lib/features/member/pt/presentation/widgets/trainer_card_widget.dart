import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/trainer_detail_screen.dart';
import '../../../../../core/network/globals.dart' as g;
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../domain/entities/trainer_card_entity.dart';
import '../bloc/member_pt_bloc.dart';

class TrainerCardWidget extends StatelessWidget {
  final TrainerCardEntity trainer;

  const TrainerCardWidget({super.key, required this.trainer});

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return BlocBuilder<MemberPtBloc, MemberPtState>(
      buildWhen: (prev, curr) =>
      curr is TrainerFavoriteToggleLoading ||
          curr is TrainersLoaded ||
          curr is TrainerFavoriteToggleError,
      builder: (context, state) {
        final isToggling = state is TrainerFavoriteToggleLoading &&
            state.trainerId == trainer.trainerId;

        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: tokens.spacing.lg,
            vertical: tokens.spacing.sm,
          ),
          padding: EdgeInsets.all(tokens.spacing.lg),
          decoration: BoxDecoration(
            color: tokens.colors.surface,
            borderRadius: BorderRadius.circular(tokens.card.radius),
            border: Border.all(
              color: tokens.colors.border.withOpacity(0.15),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top row: heart + name + photo ──────────────────
              Row(
                textDirection:
                isRtl ? TextDirection.rtl : TextDirection.ltr,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Heart icon
                  _HeartButton(
                    trainerId: trainer.trainerId,
                    isFavorited: trainer.isFavorited,
                    isToggling: isToggling,
                  ),
                  SizedBox(width: tokens.spacing.sm),

                  // Name + specialties
                  Expanded(
                    child: Column(
                      crossAxisAlignment: isRtl
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          trainer.fullName,
                          textAlign:
                          isRtl ? TextAlign.right : TextAlign.left,
                          style: tokens.typography.headlineSmall.copyWith(
                            fontWeight: FontWeight.w800,
                            color: tokens.colors.label,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          trainer.specialties.join('، '),
                          textAlign: isRtl ? TextAlign.right : TextAlign.left,
                          style: tokens.typography.bodySmall.copyWith(
                            color: tokens.colors.muted,
                            fontSize: 13,
                          ),
                        ),

                        Builder(builder: (context) {
                          // branches[] is the source of truth for a
                          // multi-branch trainer; branchName is only kept
                          // as a fallback for responses that predate it.
                          final branchLabel = trainer.branches.isNotEmpty
                              ? trainer.branches.map((b) => b.branchName).join('، ')
                              : (trainer.branchName ?? '');

                          if (branchLabel.trim().isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  size: 14,
                                  color: tokens.colors.primary,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    branchLabel,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: isRtl ? TextAlign.right : TextAlign.left,
                                    style: tokens.typography.bodySmall.copyWith(
                                      color: tokens.colors.body,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                        if (!trainer.bookable) ...[
                          const SizedBox(height: 6),
                          Text(
                            _restrictionMessage(l10n, trainer.restrictionCode),
                            textAlign: isRtl ? TextAlign.right : TextAlign.left,
                            style: tokens.typography.bodySmall.copyWith(
                              color: tokens.colors.error,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(width: tokens.spacing.md),

                  // Photo
                  _TrainerPhoto(trainer: trainer),
                ],
              ),

              SizedBox(height: tokens.spacing.md),

              // ── Stats row ───────────────────────────────────────
              Row(
                textDirection:
                isRtl ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  Text(
                    '\$${trainer.pricePerSession.toStringAsFixed(0)}${l10n.ptPerSession}',
                    style: tokens.typography.bodyMedium.copyWith(
                      color: tokens.colors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  if (trainer.yearsOfExperience != null) ...[
                    _Dot(),
                    Text(
                      l10n.ptYearsExperience(trainer.yearsOfExperience!),
                      style: tokens.typography.bodySmall.copyWith(
                        color: tokens.colors.body,
                      ),
                    ),
                  ],
                  _Dot(),
                  Text(
                    l10n.ptReviews(trainer.reviewCount),
                    style: tokens.typography.bodySmall.copyWith(
                      color: tokens.colors.body,
                    ),
                  ),
                ],
              ),

              // ── Certifications ──────────────────────────────────
              if (trainer.certifications.isNotEmpty) ...[
                SizedBox(height: tokens.spacing.md),
                SizedBox(
                  height: 32,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: trainer.certifications.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(width: tokens.spacing.sm),
                    itemBuilder: (context, index) => _CertChip(
                      label: trainer.certifications[index],
                    ),
                  ),
                ),
              ],

              SizedBox(height: tokens.spacing.md),

              // ── Book session button ──────────────────────────────
              SizedBox(
                width: double.infinity,
                height: tokens.button.height,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TrainerDetailScreen(
                          trainerId: trainer.trainerId,
                        ),
                      ),
                    );

                    if (!context.mounted) return;

                    context.read<MemberPtBloc>().add(const TrainersStarted());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tokens.colors.primary,
                    foregroundColor: tokens.colors.onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(tokens.button.radius),
                    ),
                  ),
                  icon: const Icon(Icons.calendar_today_rounded, size: 18),
                  label: Text(
                    l10n.ptBookSession,
                    style: TextStyle(
                      fontSize: tokens.button.textSize,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Public + pure (no BuildContext/AppLocalizations needed) so the
  // restriction-code -> ARB-key mapping can be unit tested without a full
  // widget/localization test harness.
  static const String restrictionKeyNoMembership = 'noActiveMembership';
  static const String restrictionKeyWrongBranch = 'trainerNotAvailableAtYourBranch';
  static const String restrictionKeyDefault = 'trainerNotBookable';

  static String restrictionMessageKey(String? restrictionCode) {
    switch (restrictionCode) {
      case 'NO_ACTIVE_MEMBERSHIP':
        return restrictionKeyNoMembership;
      case 'TRAINER_NOT_AVAILABLE_AT_MEMBERSHIP_BRANCH':
        return restrictionKeyWrongBranch;
      default:
        return restrictionKeyDefault;
    }
  }

  String _restrictionMessage(AppLocalizations l10n, String? restrictionCode) {
    switch (restrictionMessageKey(restrictionCode)) {
      case restrictionKeyNoMembership:
        return l10n.noActiveMembership;
      case restrictionKeyWrongBranch:
        return l10n.trainerNotAvailableAtYourBranch;
      default:
        return l10n.trainerNotBookable;
    }
  }
}

// ── Heart Button ──────────────────────────────────────────────────────────────
class _HeartButton extends StatelessWidget {
  final int trainerId;
  final bool isFavorited;
  final bool isToggling;

  const _HeartButton({
    required this.trainerId,
    required this.isFavorited,
    required this.isToggling,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    if (isToggling) {
      return SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: tokens.colors.danger,
        ),
      );
    }

    return GestureDetector(
      onTap: () => context
          .read<MemberPtBloc>()
          .add(TrainerFavoriteToggleRequested(trainerId)),
      child: Icon(
        isFavorited ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        color: isFavorited ? tokens.colors.danger : tokens.colors.muted,
        size: 26,
      ),
    );
  }
}

// ── Trainer Photo ─────────────────────────────────────────────────────────────
class _TrainerPhoto extends StatelessWidget {
  final TrainerCardEntity trainer;

  const _TrainerPhoto({required this.trainer});

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(tokens.card.radius),
          child: trainer.profileFileId != null
              ? Image.network(
            g.resolveUrl('/api/files/${trainer.profileFileId}'),
            headers: g.fileRequestAuthHeaders(),
            width: 90,
            height: 90,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                _placeholder(context, tokens),
          )
              : _placeholder(context, tokens),
        ),
        if (trainer.isOnline)
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: tokens.colors.success,
                shape: BoxShape.circle,
                border: Border.all(
                  color: tokens.colors.surface,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _placeholder(BuildContext context, dynamic tokens) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: tokens.colors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(tokens.card.radius),
      ),
      child: Icon(
        Icons.person_rounded,
        color: tokens.colors.primary,
        size: 40,
      ),
    );
  }
}

// ── Cert Chip ─────────────────────────────────────────────────────────────────
class _CertChip extends StatelessWidget {
  final String label;

  const _CertChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: tokens.colors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: tokens.colors.primary.withOpacity(0.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.workspace_premium_rounded,
            size: 13,
            color: tokens.colors.primary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: tokens.typography.bodySmall.copyWith(
              color: tokens.colors.primary,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Dot separator ─────────────────────────────────────────────────────────────
class _Dot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        '•',
        style: TextStyle(color: tokens.colors.muted),
      ),
    );
  }
}