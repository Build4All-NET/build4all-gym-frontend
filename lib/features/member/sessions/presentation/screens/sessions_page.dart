import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_filter_options_usecase.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../domain/usecases/book_session_usecase.dart';
import '../../domain/usecases/cancel_booking_usecase.dart';
import '../../domain/usecases/get_sessions_usecase.dart';
import '../../domain/usecases/get_session_detail_use_case.dart';
import '../bloc/sessions_bloc.dart';
import '../bloc/sessions_event.dart';
import '../bloc/sessions_state.dart';
import '../widgets/date_picker_row_widget.dart';
import '../widgets/session_card_widget.dart';
import '../widgets/filter_bottom_sheet.dart';

class SessionsPage extends StatelessWidget {
  final GetSessionsUseCase? getSessionsUseCase;
  final BookSessionUseCase? bookSessionUseCase;
  final CancelBookingUseCase? cancelBookingUseCase;
  final GetFilterOptionsUseCase? getFilterOptionsUseCase;
  final GetSessionDetailUseCase? getSessionDetailUseCase;

  const SessionsPage({
    super.key,
    this.getSessionsUseCase,
    this.bookSessionUseCase,
    this.cancelBookingUseCase,
    this.getFilterOptionsUseCase,
    this.getSessionDetailUseCase
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SessionsBloc(
        getSessionsUseCase: getSessionsUseCase,
        bookSessionUseCase: bookSessionUseCase,
        cancelBookingUseCase: cancelBookingUseCase,
        getFilterOptionsUseCase: getFilterOptionsUseCase,
        getSessionDetailUseCase: getSessionDetailUseCase,
      )..add(const SessionsStarted()),
      child: const _SessionsView(),
    );
  }
}

class _SessionsView extends StatelessWidget {
  const _SessionsView();

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final textDirection = Directionality.of(context);
    final isRtl = textDirection == TextDirection.rtl;

    return Directionality(
      textDirection: textDirection,
      child: Scaffold(
        backgroundColor: tokens.colors.background,
        body: SafeArea(
          top: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isTabletOrWide = constraints.maxWidth >= 700;
              final horizontalPadding =
              isTabletOrWide ? tokens.spacing.xl * 2 : tokens.spacing.lg;

              return BlocBuilder<SessionsBloc, SessionsState>(
                builder: (context, state) {
                  final selectedDate = state is SessionsLoaded
                      ? state.selectedDate
                      : state is SessionsLoading
                      ? state.selectedDate
                      : DateTime.now();

                  return CustomScrollView(
                    slivers: [
                      // ── Header ──────────────────────────────────
                      SliverToBoxAdapter(
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                horizontalPadding,
                                MediaQuery.of(context).padding.top + 24,
                                horizontalPadding,
                                tokens.spacing.xl,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: isRtl
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                                  end: isRtl
                                      ? Alignment.bottomLeft
                                      : Alignment.bottomRight,
                                  colors: [
                                    tokens.colors.primary,
                                    tokens.colors.success,
                                  ],
                                ),
                                borderRadius:
                                const BorderRadiusDirectional.only(
                                  bottomStart: Radius.circular(28),
                                  bottomEnd: Radius.circular(28),
                                ),
                              ),
                              child: Center(
                                child: ConstrainedBox(
                                  constraints:
                                  const BoxConstraints(maxWidth: 1000),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: isRtl
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            l10n.memberSessionsTitle,
                                            textAlign: isRtl
                                                ? TextAlign.right
                                                : TextAlign.left,
                                            style: tokens
                                                .typography.headlineSmall
                                                .copyWith(
                                              color: tokens.colors.onPrimary,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            l10n.memberSessionsSubtitle,
                                            textAlign: isRtl
                                                ? TextAlign.right
                                                : TextAlign.left,
                                            style: tokens
                                                .typography.bodyMedium
                                                .copyWith(
                                              color: tokens.colors.onPrimary
                                                  .withOpacity(0.88),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      DatePickerRowWidget(
                                          selectedDate: selectedDate),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // ── Search icon — top right corner ─────
                            Positioned(
                              top: MediaQuery.of(context).padding.top + 27,
                              right: isRtl ? null : horizontalPadding - 8,
                              left: isRtl ? horizontalPadding - 8 : null,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: tokens.colors.onPrimary
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () =>
                                      _openFilterBottomSheet(context),
                                  icon: Icon(
                                    Icons.search_rounded,
                                    color: tokens.colors.onPrimary,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ── Sessions list ────────────────────────────
                      if (state is SessionsLoading ||
                          state is SessionBookingLoading)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: tokens.colors.primary,
                            ),
                          ),
                        )
                      else if (state is SessionsError)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: _CenteredMessage(
                            message: l10n.memberSessionsError,
                            color: tokens.colors.danger,
                          ),
                        )
                      else if (state is SessionBookingError)
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: _CenteredMessage(
                              message: state.message,
                              color: tokens.colors.danger,
                            ),
                          )
                        else if (state is SessionsLoaded &&
                              state.sessions.isEmpty)
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: _CenteredMessage(
                                message: l10n.memberSessionsEmpty,
                                color: tokens.colors.body,
                              ),
                            )
                          else if (state is SessionsLoaded)
                              SliverPadding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  4,
                                  tokens.spacing.lg,
                                  4,
                                  tokens.spacing.xl,
                                ),
                                sliver: SliverToBoxAdapter(
                                  child: Center(
                                    child: ConstrainedBox(
                                      constraints:
                                      const BoxConstraints(maxWidth: 1000),
                                      child: Column(
                                        children: state.sessions
                                            .map((session) =>
                                            SessionCardWidget(session: session))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            else
                              const SliverToBoxAdapter(
                                child: SizedBox.shrink(),
                              ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _openFilterBottomSheet(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    showModalBottomSheet(
      context: context,
      backgroundColor: tokens.colors.surface,
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.vertical(
          top: Radius.circular(tokens.card.radius),
        ),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<SessionsBloc>(),
        child: const FilterBottomSheet(),
      ),
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  final String message;
  final Color color;

  const _CenteredMessage({
    required this.message,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(tokens.spacing.lg),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: tokens.typography.bodyMedium.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}