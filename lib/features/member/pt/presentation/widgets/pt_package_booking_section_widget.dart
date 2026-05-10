import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';

import '../bloc/pt_package_booking_bloc.dart';
import '../bloc/pt_package_booking_state.dart';

import 'pt_package_booking_summary_widget.dart';
import 'pt_package_days_selector_widget.dart';
import 'pt_package_selector_widget.dart';
import 'pt_package_time_selector_widget.dart';

/// Main package booking section.
///
/// This widget is the parent of all package booking UI parts:
/// 1. Package selector
/// 2. Weekday selector
/// 3. Time selector per selected day
/// 4. Booking summary
///
/// It does NOT call the API directly.
/// It only reads the current state from PtPackageBookingBloc.
///
/// Important:
/// - Days are stable weekday codes.
/// - Times now come from backend trainer/PT availability.
/// - No static time list here.
class PtPackageBookingSectionWidget extends StatelessWidget {
  const PtPackageBookingSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PtPackageBookingBloc, PtPackageBookingState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        final tokens = context.read<ThemeCubit>().state.tokens;

        /// If the bloc is not initialized yet, show nothing.
        if (state is! PtPackageBookingLoaded) {
          return const SizedBox.shrink();
        }

        /// If backend returned no packages for this trainer/branch,
        /// show empty message from ARB.
        if (state.packages.isEmpty) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(tokens.spacing.lg),
            decoration: BoxDecoration(
              color: tokens.colors.surface,
              borderRadius: BorderRadius.circular(tokens.card.radius),
              border: Border.all(
                color: tokens.colors.border.withOpacity(0.35),
              ),
            ),
            child: Text(
              l10n.ptPackageNoPackages,
              textAlign: TextAlign.center,
              style: tokens.typography.bodyMedium.copyWith(
                color: tokens.colors.muted,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SectionTitle(title: l10n.ptPackageChoosePackage),
            SizedBox(height: tokens.spacing.md),

            /// Shows all packages returned by backend.
            PtPackageSelectorWidget(
              packages: state.packages,
              selectedPackage: state.selectedPackage,
            ),

            SizedBox(height: tokens.spacing.xl),

            _SectionTitle(title: l10n.ptPackageChooseDays),
            SizedBox(height: tokens.spacing.md),

            /// Lets user choose stable weekdays only.
            ///
            /// No dates.
            /// Max selected days = selectedPackage.maxDaysPerWeek.
            ///
            /// When a day is selected, the Bloc loads:
            /// GET /api/member/trainers/{trainerId}/weekly-slots?day=MONDAY
            PtPackageDaysSelectorWidget(
              weeklySchedule: state.weeklySchedule,
              selectedPackage: state.selectedPackage,
            ),

            SizedBox(height: tokens.spacing.xl),

            _SectionTitle(title: l10n.ptPackageChooseTime),
            SizedBox(height: tokens.spacing.md),

            /// Shows real PT availability loaded by the Bloc.
            ///
            /// Old:
            /// PtPackageTimeSelectorWidget(
            ///   weeklySchedule: state.weeklySchedule,
            /// )
            ///
            /// New:
            /// Pass the full state so the widget can access:
            /// - weeklySchedule
            /// - availableSlotsForDay(day)
            /// - isLoadingSlotsForDay(day)
            /// - slotErrorForDay(day)
            PtPackageTimeSelectorWidget(
              state: state,
            ),

            SizedBox(height: tokens.spacing.xl),

            _SectionTitle(title: l10n.ptPackageBookingSummary),
            SizedBox(height: tokens.spacing.md),

            /// Shows selected package/schedule/price before confirm.
            PtPackageBookingSummaryWidget(state: state),
          ],
        );
      },
    );
  }
}

/// Small private title widget used only inside this file.
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;

    return Text(
      title,
      textAlign: TextAlign.start,
      style: tokens.typography.bodyMedium.copyWith(
        color: tokens.colors.label,
        fontWeight: FontWeight.w900,
        fontSize: 17.0,
      ),
    );
  }
}