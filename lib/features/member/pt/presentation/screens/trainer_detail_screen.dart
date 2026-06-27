import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';

import '../../data/repositories/member_pt_repository_impl.dart';
import '../../data/services/member_pt_service.dart';

import '../../domain/entities/trainer_detail_entity.dart';

import '../../domain/usecases/check_package_payment_status_usecase.dart';
import '../../domain/usecases/confirm_package_payment_usecase.dart';
import '../../domain/usecases/create_package_booking_usecase.dart';
import '../../domain/usecases/get_trainer_detail_usecase.dart';
import '../../domain/usecases/get_weekly_available_slots_usecase.dart';
import '../../domain/usecases/request_booking_usecase.dart';
import '../../domain/usecases/toggle_favorite_trainer_usecase.dart';

import '../bloc/pt_package_booking_bloc.dart';
import '../bloc/pt_package_booking_event.dart';

import '../widgets/pt_package_booking_section_widget.dart';
import '../widgets/pt_package_confirm_bar_widget.dart';
import '../widgets/trainer_detail_card_widget.dart';
import '../widgets/training_videos_section_widget.dart';

/// Trainer detail screen for the PT package booking flow.
///
/// Flow:
/// 1. GET /api/member/trainers/{trainerId}
/// 2. Backend returns trainer details + packages.
/// 3. Member selects package.
/// 4. Member selects stable weekdays.
/// 5. For each selected weekday, Bloc loads trainer availability:
///    GET /api/member/trainers/{trainerId}/weekly-slots?day=MONDAY
/// 6. Member selects time per day.
/// 7. POST /api/member/pt-package-bookings
///
/// Important:
/// - No dates in the package booking flow.
/// - Weekdays are stable backend codes.
/// - UI weekday labels come from ARB.
class TrainerDetailScreen extends StatefulWidget {
  final int trainerId;

  const TrainerDetailScreen({
    super.key,
    required this.trainerId,
  });

  @override
  State<TrainerDetailScreen> createState() => _TrainerDetailScreenState();
}

class _TrainerDetailScreenState extends State<TrainerDetailScreen> {
  /// Loads trainer detail from backend.
  ///
  /// Expected backend response includes:
  /// - trainer basic info
  /// - assigned videos
  /// - certifications
  /// - branchId
  /// - packages
  late final GetTrainerDetailUseCase _getTrainerDetailUseCase;

  /// Toggles favorite status for the trainer.
  late final ToggleFavoriteTrainerUseCase _toggleFavoriteTrainerUseCase;

  late final CreatePackageBookingUseCase _createPackageBookingUseCase;
  late final ConfirmPackagePaymentUseCase _confirmPackagePaymentUseCase;
  late final CheckPackagePaymentStatusUseCase _checkPackagePaymentStatusUseCase;
  late final GetWeeklyAvailableSlotsUseCase _getWeeklyAvailableSlotsUseCase;
  late final RequestBookingUseCase _requestBookingUseCase;
  late final PtPackageBookingBloc _packageBookingBloc;
  late final MemberPtService _memberPtService;

  bool _isLoading = true;
  String? _errorMessage;

  /// Trainer detail loaded from backend.
  TrainerDetailEntity? _trainer;

  bool _isFavoriteLoading = false;

  @override
  void initState() {
    super.initState();

    _memberPtService = MemberPtService();
    final repository = MemberPtRepositoryImpl(service: _memberPtService);

    _getTrainerDetailUseCase = GetTrainerDetailUseCase(repository);
    _toggleFavoriteTrainerUseCase = ToggleFavoriteTrainerUseCase(repository);
    _createPackageBookingUseCase = CreatePackageBookingUseCase(repository);
    _confirmPackagePaymentUseCase = ConfirmPackagePaymentUseCase(repository);
    _checkPackagePaymentStatusUseCase = CheckPackagePaymentStatusUseCase(repository);
    _getWeeklyAvailableSlotsUseCase = GetWeeklyAvailableSlotsUseCase(repository);
    _requestBookingUseCase = RequestBookingUseCase(repository);

    _packageBookingBloc = PtPackageBookingBloc(
      createPackageBookingUseCase: _createPackageBookingUseCase,
      confirmPackagePaymentUseCase: _confirmPackagePaymentUseCase,
      checkPackagePaymentStatusUseCase: _checkPackagePaymentStatusUseCase,
      getWeeklyAvailableSlotsUseCase: _getWeeklyAvailableSlotsUseCase,
      requestBookingUseCase: _requestBookingUseCase,
    );

    _loadTrainerDetail();

    debugPrint('Opening trainer detail for trainerId: ${widget.trainerId}');
  }

  @override
  void dispose() {
    _packageBookingBloc.close();
    super.dispose();
  }

  /// Loads trainer details.
  ///
  /// After trainer details are loaded successfully, we start the package bloc
  /// with:
  /// - trainerId
  /// - packages returned by backend
  Future<void> _loadTrainerDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _getTrainerDetailUseCase(widget.trainerId);

    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;

    if (result.failure != null) {
      setState(() {
        _isLoading = false;
        _errorMessage = result.failure!.message;
      });
      return;
    }

    if (result.data == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = l10n.ptTrainerDetailsNotFound;
      });
      return;
    }

    setState(() {
      _trainer = result.data;
      _isLoading = false;
    });

    /// Initialize package booking state with trainer packages.
    ///
    /// PtPackageBookingBloc will select the first package by default
    /// if packages list is not empty.
    _packageBookingBloc.add(
      PtPackageBookingStarted(
        trainerId: widget.trainerId,
        packages: result.data!.packages,
        availableDays: result.data!.availableDays,
      ),
    );
  }

  /// Toggles trainer favorite state.
  ///
  /// Optimistic UI:
  /// - update UI immediately
  /// - if backend fails, rollback
  Future<void> _toggleFavorite() async {
    final trainer = _trainer;

    if (trainer == null || _isFavoriteLoading) return;

    final l10n = AppLocalizations.of(context)!;
    final oldFavoriteValue = trainer.isFavorite;

    setState(() {
      _isFavoriteLoading = true;
      _trainer = trainer.copyWith(
        isFavorite: !oldFavoriteValue,
      );
    });

    final result = await _toggleFavoriteTrainerUseCase(trainer.id);

    if (!mounted) return;

    if (result.failure != null || result.data == null) {
      setState(() {
        _isFavoriteLoading = false;
        _trainer = trainer.copyWith(
          isFavorite: oldFavoriteValue,
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.failure?.message ?? l10n.ptFavoriteUpdateFailed,
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return;
    }

    setState(() {
      _isFavoriteLoading = false;
      _trainer = trainer.copyWith(
        isFavorite: result.data!.isFavorited,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: BlocProvider.value(
        value: _packageBookingBloc,
        child: Scaffold(
          backgroundColor: tokens.colors.background,
          body: _isLoading
              ? Center(
            child: CircularProgressIndicator(
              color: tokens.colors.primary,
            ),
          )
              : _errorMessage != null
              ? _ErrorView(
            message: _errorMessage!,
            onRetry: _loadTrainerDetail,
          )
              : _TrainerDetailBody(
            trainer: _trainer!,
            isFavoriteLoading: _isFavoriteLoading,
            onFavoritePressed: _toggleFavorite,
            memberPtService: _memberPtService,
          ),
        ),
      ),
    );
  }
}

/// Main body of trainer detail page.
///
/// Shows:
/// - header
/// - trainer card
/// - training videos
/// - package booking section
/// - sticky package confirm bar
class _TrainerDetailBody extends StatelessWidget {
  final TrainerDetailEntity trainer;
  final bool isFavoriteLoading;
  final VoidCallback onFavoritePressed;
  final MemberPtService memberPtService;

  const _TrainerDetailBody({
    required this.trainer,
    required this.isFavoriteLoading,
    required this.onFavoritePressed,
    required this.memberPtService,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _Header(title: trainer.fullName),
            ),
            SliverToBoxAdapter(
              child: Transform.translate(
                offset: const Offset(0.0, 7.0),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: tokens.spacing.lg,
                  ),
                  child: Column(
                    crossAxisAlignment:
                    isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      TrainerDetailCardWidget(
                        trainer: trainer,
                        onFavoritePressed: onFavoritePressed,
                        isFavoriteLoading: isFavoriteLoading,
                      ),

                      SizedBox(height: tokens.spacing.lg),

                      TrainingVideosSectionWidget(
                        videos: trainer.assignedVideos,
                        isSubscribed: trainer.hasActivePtPackage,
                      ),

                      SizedBox(height: tokens.spacing.xl),

                      const PtPackageBookingSectionWidget(),

                      /// Bottom padding so content does not hide behind
                      /// sticky confirm bar.
                      SafeArea(
                        top: false,
                        child: SizedBox(
                          height: tokens.button.height + tokens.spacing.lg * 4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: PtPackageConfirmBarWidget(memberPtService: memberPtService),
        ),
      ],
    );
  }
}

/// Header with back button and trainer name.
class _Header extends StatelessWidget {
  final String title;

  const _Header({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.fromSTEB(
        tokens.spacing.lg,
        topPadding + 18.0,
        tokens.spacing.lg,
        64.0,
      ),
      decoration: BoxDecoration(
        color: tokens.colors.primary,
        borderRadius: const BorderRadiusDirectional.only(
          bottomStart: Radius.circular(28.0),
          bottomEnd: Radius.circular(28.0),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: isRtl ? Alignment.centerLeft : Alignment.centerRight,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: tokens.colors.onPrimary.withOpacity(0.22),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isRtl
                      ? Icons.arrow_back_ios_new_rounded
                      : Icons.arrow_forward_ios_rounded,
                  color: tokens.colors.onPrimary,
                  size: 18.0,
                ),
              ),
            ),
          ),
          Align(
            alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                end: 52.0,
              ),
              child: Text(
                title,
                textAlign: isRtl ? TextAlign.right : TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: tokens.typography.headlineSmall.copyWith(
                  color: tokens.colors.onPrimary,
                  fontWeight: FontWeight.w900,
                  fontSize: 22.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Error view shown when trainer detail fails to load.
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

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
            Icon(
              Icons.error_outline_rounded,
              color: tokens.colors.danger,
              size: 48.0,
            ),

            SizedBox(height: tokens.spacing.md),

            Text(
              message,
              textAlign: TextAlign.center,
              style: tokens.typography.bodyMedium.copyWith(
                color: tokens.colors.danger,
              ),
            ),

            SizedBox(height: tokens.spacing.lg),

            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: tokens.colors.primary,
                foregroundColor: tokens.colors.onPrimary,
                elevation: 0.0,
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
          ],
        ),
      ),
    );
  }
}