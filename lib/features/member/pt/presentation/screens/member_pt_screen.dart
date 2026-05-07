import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../data/repositories/member_pt_repository_impl.dart';
import '../../data/services/member_pt_service.dart';
import '../../domain/usecases/get_trainers_usecase.dart';
import '../../domain/usecases/get_filter_options_usecase.dart';
import '../../domain/usecases/toggle_favorite_trainer_usecase.dart';
import '../bloc/member_pt_bloc.dart';
import '../widgets/trainer_card_widget.dart';
import '../widgets/trainer_filter_chips_widget.dart';

class MemberPtScreen extends StatelessWidget {
  const MemberPtScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = MemberPtService();
    final repository = MemberPtRepositoryImpl(service: service);

    return BlocProvider(
      create: (_) => MemberPtBloc(
        getTrainersUseCase: GetTrainersUseCase(repository),
        getFilterOptionsUseCase: GetFilterOptionsUseCase(repository),
        toggleFavoriteTrainerUseCase: ToggleFavoriteTrainerUseCase(repository),
      )..add(const TrainersStarted()),
      child: const _MemberPtView(),
    );
  }
}

class _MemberPtView extends StatelessWidget {
  const _MemberPtView();

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: tokens.colors.background,
        body: BlocConsumer<MemberPtBloc, MemberPtState>(
          listener: (context, state) {
            if (state is TrainerFavoriteToggleError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: tokens.colors.danger,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsetsDirectional.fromSTEB(
                      tokens.spacing.lg,
                      MediaQuery.of(context).padding.top + 24,
                      tokens.spacing.lg,
                      tokens.spacing.xl + 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: isRtl ? Alignment.topRight : Alignment.topLeft,
                        end: isRtl
                            ? Alignment.bottomLeft
                            : Alignment.bottomRight,
                        colors: [
                          tokens.colors.primary,
                          tokens.colors.success,
                        ],
                      ),
                      borderRadius: const BorderRadiusDirectional.only(
                        bottomStart: Radius.circular(28),
                        bottomEnd: Radius.circular(28),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: isRtl
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: tokens.colors.onPrimary
                                        .withOpacity(0.18),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Icon(
                                      isRtl
                                          ? Icons.arrow_back_ios_new_rounded
                                          : Icons.arrow_forward_ios_rounded,
                                      color: tokens.colors.onPrimary,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Align(
                              alignment: isRtl
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  end: 52,
                                ),
                                child: Text(
                                  l10n.ptScreenTitle,
                                  textAlign:
                                  isRtl ? TextAlign.right : TextAlign.left,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                  tokens.typography.headlineSmall.copyWith(
                                    color: tokens.colors.onPrimary,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 26,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                            end: 52,
                          ),
                          child: Text(
                            l10n.ptScreenSubtitle,
                            textAlign: isRtl ? TextAlign.right : TextAlign.left,
                            style: tokens.typography.bodyMedium.copyWith(
                              color: tokens.colors.onPrimary.withOpacity(0.85),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: tokens.spacing.md,
                    ),
                    child: state is TrainersLoaded
                        ? TrainerFilterChipsWidget(
                      specialties: state.specialties,
                      activeSpecialtyFilter:
                      state.activeSpecialtyFilter,
                      favoritesOnly: state.favoritesOnly,
                      favoriteCount: state.favoriteCount,
                    )
                        : TrainerFilterChipsWidget(
                      specialties: const [],
                      activeSpecialtyFilter: null,
                      favoritesOnly: false,
                      favoriteCount: 0,
                    ),
                  ),
                ),

                if (state is TrainersLoading)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (_, __) => _ShimmerCard(),
                      childCount: 3,
                    ),
                  )
                else if (state is TrainersError)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(tokens.spacing.lg),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: tokens.colors.danger,
                              size: 48,
                            ),
                            SizedBox(height: tokens.spacing.md),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: tokens.typography.bodyMedium.copyWith(
                                color: tokens.colors.danger,
                              ),
                            ),
                            SizedBox(height: tokens.spacing.lg),
                            ElevatedButton(
                              onPressed: () => context
                                  .read<MemberPtBloc>()
                                  .add(const TrainersStarted()),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: tokens.colors.primary,
                                foregroundColor: tokens.colors.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    tokens.button.radius,
                                  ),
                                ),
                              ),
                              child: Text(l10n.retry),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else if (state is TrainersLoaded && state.trainers.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          l10n.ptNoTrainers,
                          style: tokens.typography.bodyMedium.copyWith(
                            color: tokens.colors.muted,
                          ),
                        ),
                      ),
                    )
                  else if (state is TrainersLoaded)
                      SliverPadding(
                        padding: EdgeInsets.only(bottom: tokens.spacing.xl),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) => TrainerCardWidget(
                              trainer: state.trainers[index],
                            ),
                            childCount: state.trainers.length,
                          ),
                        ),
                      )
                    else if (state is TrainerFavoriteToggleLoading ||
                          state is TrainerFavoriteToggleError)
                        const SliverToBoxAdapter(child: SizedBox.shrink()),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: tokens.spacing.lg,
        vertical: tokens.spacing.sm,
      ),
      height: 180,
      decoration: BoxDecoration(
        color: tokens.colors.surface,
        borderRadius: BorderRadius.circular(tokens.card.radius),
      ),
      child: Padding(
        padding: EdgeInsets.all(tokens.spacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShimmerBox(width: 160, height: 20),
                  SizedBox(height: tokens.spacing.sm),
                  _ShimmerBox(width: 100, height: 14),
                  SizedBox(height: tokens.spacing.md),
                  _ShimmerBox(width: 200, height: 14),
                  SizedBox(height: tokens.spacing.md),
                  _ShimmerBox(width: double.infinity, height: 40),
                ],
              ),
            ),
            SizedBox(width: tokens.spacing.md),
            _ShimmerBox(width: 90, height: 90),
          ],
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;

  const _ShimmerBox({
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: tokens.colors.border.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}