import 'dart:convert';
import '../widgets/today_schedule_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/l10n/app_localizations.dart';

import '../../domain/entities/member_home.dart';
import '../../domain/entities/member_stats.dart';
import '../../domain/entities/membership_card.dart';
import '../../domain/entities/motivational_quote.dart';
import '../../domain/entities/schedule_item.dart';
import '../bloc/member_home_bloc.dart';
import '../bloc/member_home_event.dart';
import '../bloc/member_home_state.dart';
import '../widgets/member_stats_row.dart';
import '../widgets/membership_status_card.dart';
import '../widgets/motivational_quote_card.dart';
import '../widgets/quick_actions_grid.dart';
import 'package:build4allgym/features/member/pt/presentation/screens/member_pt_screen.dart';
import '../widgets/weight_tracker_card.dart';

class MemberHomeScreen extends StatefulWidget {
  const MemberHomeScreen({super.key});

  @override
  State<MemberHomeScreen> createState() => _MemberHomeScreenState();
}

class _MemberHomeScreenState extends State<MemberHomeScreen> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> _logoutAndGoToLogin(BuildContext context) async {
    await _storage.deleteAll(); // _storage is already defined in the state class
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login', // replace with your actual login route
          (route) => false,
    );
  }

  String _fullName = '';

  static const double _maxWidth = 430;
  static const double _headerHeight = 340;
  static const double _statsOverlap = 70;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    context.read<MemberHomeBloc>().add(const MemberHomeLoadRequested());
  }
  void _showComingSoon(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.comingSoon)),
    );
  }
  Future<void> _loadUserName() async {
    final firstName = await _storage.read(key: 'user_first_name') ?? '';
    final lastName = await _storage.read(key: 'user_last_name') ?? '';

    final fullName = '$firstName $lastName'.trim();

    if (fullName.isNotEmpty) {
      if (!mounted) return;
      setState(() => _fullName = fullName);
      return;
    }

    final rawUserJson = await _storage.read(key: 'auth_user_json');
    String fallbackName = '';

    if (rawUserJson != null && rawUserJson.trim().isNotEmpty) {
      final decoded = jsonDecode(rawUserJson);
      if (decoded is Map<String, dynamic>) {
        fallbackName = decoded['username']?.toString() ?? '';
      }
    }

    if (!mounted) return;
    setState(() => _fullName = fallbackName);
  }

  MemberHome? _getDataFromState(MemberHomeState state) {
    if (state is MemberHomeLoaded) return state.data;
    if (state is MemberHomeWeightLogSuccess) return state.data;
    if (state is MemberHomeWeightLogError) return state.data;
    return null;
  }

  bool _getShowWeightCardFromState(MemberHomeState state) {
    if (state is MemberHomeLoaded) return state.showWeightCard;
    if (state is MemberHomeWeightLogSuccess) return state.showWeightCard;
    if (state is MemberHomeWeightLogError) return state.showWeightCard;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = context.read<ThemeCubit>().state.tokens;


    return Scaffold(
      backgroundColor: tokens.colors.background,
      body: BlocConsumer<MemberHomeBloc, MemberHomeState>(
        listener: (context, state) {
          if (state is MemberHomeWeightLogSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.home_weightUpdated),
                backgroundColor: tokens.colors.success,
              ),
            );
          }

          if (state is MemberHomeWeightLogError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: tokens.colors.danger,
              ),
            );
          }

          if (state is MemberHomeError) {
            final msg = state.message.toLowerCase();
            final isAuthError = msg.contains('unauthorized') ||
                msg.contains('401') ||
                msg.contains('missing token') ||
                msg.contains('expired');

            if (isAuthError) {
              _logoutAndGoToLogin(context);
            }
          }
        },
        builder: (context, state) {
          if (state is MemberHomeInitial || state is MemberHomeLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: tokens.colors.primary,
              ),
            );
          }



          if (state is MemberHomeError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(tokens.spacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: tokens.typography.bodyMedium,
                    ),
                    SizedBox(height: tokens.spacing.md),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<MemberHomeBloc>()
                            .add(const MemberHomeLoadRequested());
                      },
                      child: Text(l10n.appAccessRetry),
                    ),
                    SizedBox(height: tokens.spacing.md),
                    // ADD THIS TO LOGOUT
                    TextButton(
                      onPressed: () async {
                        const storage = FlutterSecureStorage();
                        await storage.deleteAll();
                        if (!context.mounted) return;
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login', // replace with your actual login route name
                              (route) => false,
                        );
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final data = _getDataFromState(state);
          final showWeightCard = _getShowWeightCardFromState(state);

          if (data == null) {
            return Center(
              child: Text(
                l10n.home_noData,
                style: tokens.typography.bodyMedium,
              ),
            );
          }

          return RefreshIndicator(
            color: tokens.colors.primary,
            backgroundColor: tokens.colors.surface,
            onRefresh: () async {
              context.read<MemberHomeBloc>().add(
                const MemberHomeRefreshRequested(),
              );
            },
            child: _buildContent(
              context: context,
              membership: data.membership,
              stats: data.stats,
              quote: data.quote,
              scheduleItems: data.schedule.items,
              showWeightCard: showWeightCard,
              welcomeText: l10n.home_welcome,
              fullName: _fullName,
              notificationCount: 0,
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required MembershipCard membership,
    required MemberStats stats,
    required MotivationalQuote? quote,
    required List<ScheduleItem> scheduleItems,
    required bool showWeightCard,
    required String welcomeText,
    required String fullName,
    required int notificationCount,
  }) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxWidth),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: _headerHeight,
                    padding: EdgeInsets.fromLTRB(
                      tokens.spacing.lg,
                      7,
                      tokens.spacing.lg,
                      0,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          tokens.colors.primary,
                          tokens.colors.success,
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Column(
                        children: [
                          _buildHeader(
                            context: context,
                            welcomeText: welcomeText,
                            fullName: fullName,
                            notificationCount: notificationCount,
                          ),
                          SizedBox(height: tokens.spacing.xl),
                          MembershipStatusCard(membership: membership),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: tokens.spacing.lg,
                    right: tokens.spacing.lg,
                    bottom: -_statsOverlap,
                    child: MemberStatsRow(stats: stats),
                  ),
                ],
              ),

              const SizedBox(height: 92),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spacing.lg),
                child: Column(
                  children: [
                    if (quote != null) ...[
                      MotivationalQuoteCard(quote: quote),
                      SizedBox(height: tokens.spacing.lg),
                    ],

                    if (showWeightCard) ...[
                      WeightTrackerCard(
                        onDismiss: () {
                          context.read<MemberHomeBloc>().add(
                            const MemberHomeWeightCardDismissed(),
                          );
                        },
                        onWeightSubmitted: (weight) {
                          context.read<MemberHomeBloc>().add(
                            MemberHomeWeightLogged(weight: weight),
                          );
                        },
                      ),
                      SizedBox(height: tokens.spacing.lg),
                    ],
                    TodayScheduleWidget(items: scheduleItems),
                    SizedBox(height: tokens.spacing.lg),
                    QuickActionsGrid(
                      onBookClass: () => _showComingSoon(context),
                      onBookTrainer: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const MemberPtScreen(),
                          ),
                        );
                      },
                      onQrCode: () => _showComingSoon(context),
                      onPaymentHistory: () => _showComingSoon(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader({
    required BuildContext context,
    required String welcomeText,
    required String fullName,
    required int notificationCount,
  }) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: tokens.colors.onPrimary.withOpacity(0.16),
              child: Icon(
                Icons.notifications_none_rounded,
                color: tokens.colors.onPrimary,
                size: 22,
              ),
            ),
            if (notificationCount > 0)
              Positioned(
                top: -5,
                right: isRtl ? -4 : null,
                left: !isRtl ? -4 : null,
                child: Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: tokens.colors.danger,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    notificationCount.toString(),
                    style: tokens.typography.bodySmall.copyWith(
                      color: tokens.colors.onPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment:
          isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              welcomeText,
              textAlign: isRtl ? TextAlign.end : TextAlign.start,
              style: tokens.typography.bodyMedium.copyWith(
                color: tokens.colors.onPrimary.withOpacity(0.88),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: tokens.spacing.sm),
            Text(
              fullName.isEmpty ? ' ' : fullName,
              textAlign: isRtl ? TextAlign.end : TextAlign.start,
              style: tokens.typography.headlineSmall.copyWith(
                color: tokens.colors.onPrimary,
                fontSize: 25,
                fontWeight: FontWeight.w900,
                height: 1.05,
              ),
            ),
          ],
        ),
      ],
    );
  }
}