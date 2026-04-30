import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

import '../../data/repositories/member_plans_repository_impl.dart';
import '../../data/services/member_plans_remote_datasource.dart';
import '../../domain/usecases/get_active_plans_usecase.dart';
import '../../domain/usecases/get_my_membership_usecase.dart';
import '../bloc/my_membership/my_membership_bloc.dart';
import '../bloc/my_membership/my_membership_event.dart';
import '../bloc/my_membership/my_membership_state.dart';
import '../bloc/plans_list/plans_list_bloc.dart';
import '../bloc/plans_list/plans_list_event.dart';
import '../bloc/plans_list/plans_list_state.dart';
import '../widgets/my_membership_card_widget.dart';
import '../widgets/plan_card_widget.dart';
import 'plan_detail_screen.dart';

class MemberPlansScreenProvider extends StatelessWidget {
  final Dio dio;

  const MemberPlansScreenProvider({
    super.key,
    required this.dio,
  });

  @override
  Widget build(BuildContext context) {
    final remoteDatasource = MemberPlansRemoteDatasourceImpl(dio: dio);

    final repository = MemberPlansRepositoryImpl(
      remoteDatasource: remoteDatasource,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PlansListBloc(
            getActivePlans: GetActivePlansUseCase(repository: repository),
          )..add(LoadPlansEvent()),
        ),
        BlocProvider(
          create: (_) => MyMembershipBloc(
            getMyMembership: GetMyMembershipUseCase(repository: repository),
          )..add(LoadMyMembershipEvent()),
        ),
      ],
      child: MemberPlansScreen(dio: dio),
    );
  }
}

class MemberPlansScreen extends StatelessWidget {
  final Dio dio;

  const MemberPlansScreen({
    super.key,
    required this.dio,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: tokens.colors.background,
        body: BlocBuilder<PlansListBloc, PlansListState>(
          builder: (context, state) {
            if (state is PlansListLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: tokens.colors.primary,
                ),
              );
            }

            if (state is PlansListError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: tokens.typography.bodyMedium.copyWith(
                          color: tokens.colors.danger,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: tokens.spacing.md),
                      SizedBox(
                        height: tokens.button.height,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<PlansListBloc>().add(LoadPlansEvent());
                            context
                                .read<MyMembershipBloc>()
                                .add(LoadMyMembershipEvent());
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
                            l10n.retry,
                            style: tokens.typography.bodyMedium.copyWith(
                              color: tokens.colors.onPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is PlansListLoaded) {
              final plans = state.plans;

              return RefreshIndicator(
                color: tokens.colors.primary,
                onRefresh: () async {
                  context.read<PlansListBloc>().add(LoadPlansEvent());
                  context
                      .read<MyMembershipBloc>()
                      .add(LoadMyMembershipEvent());
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  clipBehavior: Clip.none,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.18,
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  tokens.colors.primary,
                                  tokens.colors.success.withOpacity(0.88),
                                ],
                              ),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(19),
                                bottomRight: Radius.circular(19),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.memberPlansTitle,
                                  textAlign: TextAlign.right,
                                  style:
                                  tokens.typography.headlineSmall.copyWith(
                                    fontSize: 25,
                                    color: tokens.colors.onPrimary,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  l10n.memberPlansSubtitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  textAlign: TextAlign.start,
                                  style: tokens.typography.bodyMedium.copyWith(
                                    fontSize: 14,
                                    color: tokens.colors.onPrimary.withOpacity(0.92),
                                    fontWeight: FontWeight.w600,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (plans.isNotEmpty)
                            Padding(
                              padding:
                              const EdgeInsets.fromLTRB(16, 120, 16, 0),
                              child: PlanCardWidget(
                                plan: plans.first,
                                onSelectPlan: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => PlanDetailScreenProvider(
                                        planId: plans.first.planId,
                                        dio: dio,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),

                    BlocBuilder<MyMembershipBloc, MyMembershipState>(
                      builder: (context, membershipState) {
                        if (membershipState is MyMembershipLoaded) {
                          return SliverPadding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                            sliver: SliverToBoxAdapter(
                              child: MyMembershipCardWidget(
                                membership: membershipState.membership,
                              ),
                            ),
                          );
                        }

                        if (membershipState is MyMembershipLoading) {
                          return SliverPadding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                            sliver: SliverToBoxAdapter(
                              child: LinearProgressIndicator(
                                color: tokens.colors.primary,
                              ),
                            ),
                          );
                        }

                        return const SliverToBoxAdapter(
                          child: SizedBox.shrink(),
                        );
                      },
                    ),

                    if (plans.isEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(top: tokens.spacing.xl),
                          child: Text(
                            l10n.memberPlansEmpty,
                            textAlign: TextAlign.center,
                            style: tokens.typography.bodyMedium.copyWith(
                              color: tokens.colors.muted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              final otherPlans = plans.skip(1).toList();
                              final plan = otherPlans[index];

                              return PlanCardWidget(
                                plan: plan,
                                onSelectPlan: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => PlanDetailScreenProvider(
                                        planId: plan.planId,
                                        dio: dio,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            childCount: plans.length > 1 ? plans.length - 1 : 0,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}