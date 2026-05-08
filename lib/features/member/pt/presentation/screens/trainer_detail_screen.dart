import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../data/repositories/member_pt_repository_impl.dart';
import '../../data/services/member_pt_service.dart';
import '../../domain/entities/time_slot_entity.dart';
import '../../domain/entities/trainer_detail_entity.dart';
import '../../domain/usecases/get_available_slots_usecase.dart';
import '../../domain/usecases/get_trainer_detail_usecase.dart';
import '../../domain/usecases/toggle_favorite_trainer_usecase.dart';
import '../widgets/booking_datetime_selector_widget.dart';
import '../widgets/trainer_detail_card_widget.dart';
import '../widgets/training_videos_section_widget.dart';

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
  late final GetTrainerDetailUseCase _getTrainerDetailUseCase;
  late final GetAvailableSlotsUseCase _getAvailableSlotsUseCase;
  late final ToggleFavoriteTrainerUseCase _toggleFavoriteTrainerUseCase;

  bool _isLoading = true;
  String? _errorMessage;
  TrainerDetailEntity? _trainer;

  DateTime _selectedDate = DateTime.now();
  TimeSlotEntity? _selectedSlot;

  List<TimeSlotEntity> _availableSlots = [];
  bool _isSlotsLoading = false;
  String? _slotsError;

  bool _isFavoriteLoading = false;

  @override
  void initState() {
    super.initState();

    final service = MemberPtService();
    final repository = MemberPtRepositoryImpl(service: service);

    _getTrainerDetailUseCase = GetTrainerDetailUseCase(repository);
    _getAvailableSlotsUseCase = GetAvailableSlotsUseCase(repository);
    _toggleFavoriteTrainerUseCase = ToggleFavoriteTrainerUseCase(repository);

    _loadTrainerDetail();
    _loadAvailableSlots();

    debugPrint('Opening trainer detail for trainerId: ${widget.trainerId}');
  }

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
  }

  Future<void> _loadAvailableSlots() async {
    setState(() {
      _isSlotsLoading = true;
      _slotsError = null;
      _availableSlots = [];
      _selectedSlot = null;
    });

    final result = await _getAvailableSlotsUseCase(
      trainerId: widget.trainerId,
      date: _selectedDate,
    );

    if (!mounted) return;

    if (result.failure != null) {
      setState(() {
        _isSlotsLoading = false;
        _slotsError = result.failure!.message;
      });
      return;
    }

    setState(() {
      _availableSlots = result.data ?? [];
      _isSlotsLoading = false;
    });
  }

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

  void _onDateChanged(DateTime date) {
    setState(() {
      _selectedDate = date;
      _selectedSlot = null;
    });

    _loadAvailableSlots();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
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
          selectedDate: _selectedDate,
          selectedSlot: _selectedSlot,
          slots: _availableSlots,
          isSlotsLoading: _isSlotsLoading,
          slotsError: _slotsError,
          isFavoriteLoading: _isFavoriteLoading,
          onFavoritePressed: _toggleFavorite,
          onDateChanged: _onDateChanged,
          onSlotChanged: (slot) {
            setState(() {
              _selectedSlot = slot;
            });
          },
        ),
      ),
    );
  }
}

// ── Main body ────────────────────────────────────────────────────────────────

class _TrainerDetailBody extends StatelessWidget {
  final TrainerDetailEntity trainer;
  final DateTime selectedDate;
  final TimeSlotEntity? selectedSlot;
  final List<TimeSlotEntity> slots;
  final bool isSlotsLoading;
  final String? slotsError;
  final bool isFavoriteLoading;
  final VoidCallback onFavoritePressed;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<TimeSlotEntity> onSlotChanged;

  const _TrainerDetailBody({
    required this.trainer,
    required this.selectedDate,
    required this.selectedSlot,
    required this.slots,
    required this.isSlotsLoading,
    required this.slotsError,
    required this.isFavoriteLoading,
    required this.onFavoritePressed,
    required this.onDateChanged,
    required this.onSlotChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return CustomScrollView(
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
                  ),
                  SizedBox(height: tokens.spacing.xl),
                  BookingDateTimeSelectorWidget(
                    selectedDate: selectedDate,
                    selectedSlot: selectedSlot,
                    slots: slots,
                    isSlotsLoading: isSlotsLoading,
                    slotsError: slotsError,
                    onDateChanged: onDateChanged,
                    onSlotChanged: onSlotChanged,
                  ),
                  SizedBox(height: tokens.spacing.xl),
                  SizedBox(
                    width: double.infinity,
                    height: tokens.button.height,
                    child: ElevatedButton(
                      onPressed: selectedSlot == null
                          ? null
                          : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              l10n.ptBookingSelected(
                                _formatDate(selectedDate),
                                selectedSlot!.label,
                              ),
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tokens.colors.primary,
                        foregroundColor: tokens.colors.onPrimary,
                        disabledBackgroundColor:
                        tokens.colors.border.withOpacity(0.20),
                        disabledForegroundColor: tokens.colors.muted,
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            tokens.button.radius,
                          ),
                        ),
                      ),
                      child: Text(
                        l10n.ptConfirmBooking,
                        style: tokens.typography.bodyMedium.copyWith(
                          color: selectedSlot == null
                              ? tokens.colors.muted
                              : tokens.colors.onPrimary,
                          fontSize: tokens.button.textSize,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: tokens.spacing.xl + 24.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  static String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }
}

// ── Header ───────────────────────────────────────────────────────────────────

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
              padding: EdgeInsetsDirectional.only(
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

// ── Error view ───────────────────────────────────────────────────────────────

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