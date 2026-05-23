import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/network/globals.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../domain/entities/session_detail_entity.dart';
import '../bloc/sessions_bloc.dart';
import '../bloc/sessions_event.dart';
import '../bloc/sessions_state.dart';
import '../widgets/Session_About_Widget.dart';
import '../widgets/Session_Benefits_Widget.dart';
import '../widgets/Session_Equipment_Widget.dart';
import '../widgets/session_booking_payment_sheet.dart';
import '../widgets/session_info_grid_widget.dart';

class SessionDetailScreen extends StatefulWidget {
  final int sessionId;

  const SessionDetailScreen({super.key, required this.sessionId});

  @override
  State<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<SessionsBloc>()
          .add(SessionDetailRequested(widget.sessionId));
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return Scaffold(
      backgroundColor: tokens.colors.background,
      body: BlocBuilder<SessionsBloc, SessionsState>(
        builder: (context, state) {
          if (state is SessionDetailLoading) {
            return Center(
              child: CircularProgressIndicator(color: tokens.colors.primary),
            );
          }
          if (state is SessionDetailError) {
            return _ErrorView(message: state.message);
          }
          if (state is SessionDetailLoaded) {
            return _DetailView(session: state.session);
          }
          return Center(
            child: CircularProgressIndicator(color: tokens.colors.primary),
          );
        },
      ),
    );
  }
}

class _DetailView extends StatelessWidget {
  final SessionDetailEntity session;

  const _DetailView({required this.session});

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            // ── Hero image ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: SizedBox(
                height: 245,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    session.trainerProfileFileId != null
                        ? Image.network(
                      'http://192.168.0.101:8980/api/files/${session.trainerProfileFileId}',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _HeroPlaceholder(tokens: tokens),
                    )
                        : _HeroPlaceholder(tokens: tokens),

                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              tokens.colors.label.withOpacity(0.75),
                            ],
                            stops: const [0.4, 1.0],
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      top: MediaQuery.of(context).padding.top + 8,
                      right: 12,
                      child: _CircleIconButton(
                        icon: Icons.arrow_forward,
                        tokens: tokens,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ),

                    Positioned(
                      bottom: 16,
                      left: isRtl ? 16 : null,
                      right: isRtl ? null : 16,
                      child: Column(
                        crossAxisAlignment: isRtl
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          _DifficultyBadge(
                            level: session.difficultyLevel,
                            tokens: tokens,
                            l10n: l10n,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            session.className,
                            style: tokens.typography.headlineSmall.copyWith(
                              color: tokens.colors.onPrimary,
                              fontWeight: FontWeight.w900,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            textDirection:
                            isRtl ? TextDirection.rtl : TextDirection.ltr,
                            children: [
                              Text(
                                session.trainerRating.toStringAsFixed(1),
                                style: tokens.typography.bodyMedium.copyWith(
                                  color: tokens.colors.onPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color:
                                  tokens.colors.onPrimary.withOpacity(0.6),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                session.trainerName,
                                style: tokens.typography.bodyMedium.copyWith(
                                  color:
                                  tokens.colors.onPrimary.withOpacity(0.9),
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
            ),

            // ── Body ──────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: tokens.spacing.lg),
                  SessionInfoGridWidget(session: session),
                  SizedBox(height: tokens.spacing.md),
                  SessionAboutWidget(
                    description:
                    session.description ?? 'No description available',
                  ),
                  SizedBox(height: tokens.spacing.md),
                  SessionBenefitsWidget(benefits: session.benefits),
                  SizedBox(height: tokens.spacing.md),
                  SessionEquipmentWidget(equipment: session.equipment),
                  SafeArea(
                    top: false,
                    child: SizedBox(
                      height: tokens.button.height + tokens.spacing.lg * 3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // ── Sticky Book Now button ─────────────────────────────────────
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _BookNowBar(
            sessionId: session.sessionId,

            /*
             * Needed to disable booking when the session already started.
             */
            startTime: session.startTime,

            memberBookingStatus: session.memberBookingStatus,
            l10n: l10n,
            session: session,
          ),
        ),
      ],
    );
  }
}

class _BookNowBar extends StatelessWidget {
  final int sessionId;

  /*
   * Session start time.
   * Used only for frontend UX.
   * Backend already blocks old sessions.
   */
  final DateTime startTime;

  final String? memberBookingStatus;
  final AppLocalizations l10n;
  final SessionDetailEntity session;

  const _BookNowBar({
    required this.sessionId,
    required this.startTime,
    required this.memberBookingStatus,
    required this.l10n,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return Container(
      padding: EdgeInsets.fromLTRB(
        tokens.spacing.lg,
        tokens.spacing.md,
        tokens.spacing.lg,
        tokens.spacing.lg + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: tokens.colors.background,
        border: Border(
          top: BorderSide(color: tokens.colors.border.withOpacity(0.15)),
        ),
      ),
      child: BlocBuilder<SessionsBloc, SessionsState>(
        builder: (context, state) {
          final isLoading = state is SessionBookingLoading;
          final isBooked = memberBookingStatus == 'BOOKED';
          final isWaitlisted = memberBookingStatus == 'WAITLISTED';

          /*
           * Booking is closed when the session start time is now or in the past.
           *
           * This mirrors the backend check:
           * if (!session.getStartTime().isAfter(LocalDateTime.now())) block.
           */
          final isSessionClosed = !startTime.isAfter(DateTime.now());

          final isDisabled =
              isLoading || isBooked || isWaitlisted || isSessionClosed;

          return SizedBox(
            width: double.infinity,
            height: tokens.button.height,
            child: ElevatedButton(
              onPressed: isDisabled
                  ? null
                  : () async {
                final dio = appDio ?? Dio();
                await SessionBookingPaymentSheet.show(
                  context,
                  sessionId: session.sessionId,
                  className: session.className,
                  price: session.price,
                  startTime: session.startTime,
                  dio: dio,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDisabled
                    ? tokens.colors.muted
                    : tokens.colors.primary,
                foregroundColor: tokens.colors.onPrimary,
                disabledBackgroundColor: tokens.colors.muted,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(tokens.button.radius),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: tokens.colors.onPrimary,
                ),
              )
                  : Text(
                isBooked
                    ? l10n.sessionDetailAlreadyBooked
                    : isWaitlisted
                    ? l10n.sessionDetailWaitlisted
                    : isSessionClosed
                    ? l10n.sessionDetailBookingClosed
                    : l10n.sessionDetailBookNow,
                style: TextStyle(
                  fontSize: tokens.button.textSize,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  final String level;
  final dynamic tokens;
  final AppLocalizations l10n;

  const _DifficultyBadge({
    required this.level,
    required this.tokens,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (level.toUpperCase()) {
      case 'BEGINNER':
        color = tokens.colors.success;
        label = l10n.memberSessionsDifficultyBeginner;
        break;
      case 'INTERMEDIATE':
        color = Colors.orange;
        label = l10n.memberSessionsDifficultyIntermediate;
        break;
      case 'ADVANCED':
        color = tokens.colors.danger;
        label = l10n.memberSessionsDifficultyAdvanced;
        break;
      default:
        color = tokens.colors.muted;
        label = level;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: tokens.colors.label.withOpacity(0.45),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: tokens.colors.onPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final dynamic tokens;
  final VoidCallback onTap;

  const _CircleIconButton({
    required this.icon,
    required this.tokens,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: tokens.colors.surface,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: tokens.colors.label.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: tokens.colors.label, size: 18),
      ),
    );
  }
}

class _HeroPlaceholder extends StatelessWidget {
  final dynamic tokens;

  const _HeroPlaceholder({required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: tokens.colors.primary.withOpacity(0.15),
      child: Center(
        child: Icon(
          Icons.fitness_center,
          color: tokens.colors.primary.withOpacity(0.4),
          size: 72,
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(tokens.spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: tokens.colors.danger, size: 48),
            SizedBox(height: tokens.spacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: tokens.typography.bodyMedium
                  .copyWith(color: tokens.colors.danger),
            ),
            SizedBox(height: tokens.spacing.lg),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.back),
            ),
          ],
        ),
      ),
    );
  }
}