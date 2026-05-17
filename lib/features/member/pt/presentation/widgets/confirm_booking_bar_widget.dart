import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';

import '../bloc/pt_package_booking_bloc.dart';
import '../bloc/pt_package_booking_event.dart';
import '../bloc/pt_package_booking_state.dart';

/// Sticky bottom confirm bar for PT package booking.
///
/// New package flow:
/// - selectedPackage
/// - weeklySchedule
///
/// weeklySchedule example:
/// [
///   {
///     "day": "MONDAY",
///     "time": "09:00"
///   }
/// ]
///
/// Responsibilities:
/// 1. Disable button until package + valid weekly schedule are selected.
/// 2. Show loader while booking request is running.
/// 3. Dispatch PtPackageBookingConfirmRequested.
/// 4. Show success/error snackbar.
///
/// Important:
/// - No hardcoded Arabic/English user-facing text.
/// - Snackbar messages come from ARB through AppLocalizations.
/// - Bloc may return an ARB key like "ptPackageBookingFailed".
class PtPackageConfirmBarWidget extends StatelessWidget {
  const PtPackageConfirmBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PtPackageBookingBloc, PtPackageBookingState>(
      listener: (context, state) {
        final l10n = AppLocalizations.of(context)!;

        /// Booking succeeded.
        if (state is PtPackageBookingSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.ptPackageBookingSuccess),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }

        /// Booking failed.
        if (state is PtPackageBookingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _resolveErrorMessage(
                  l10n: l10n,
                  message: state.message,
                ),
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        final tokens = context.read<ThemeCubit>().state.tokens;

        /// If bloc not ready, do not show button.
        if (state is! PtPackageBookingLoaded) {
          return const SizedBox.shrink();
        }

        final isSubmitting = state is PtPackageBookingSubmitting;

        return SafeArea(
          top: false,
          child: Container(
            padding: EdgeInsets.all(tokens.spacing.lg),
            decoration: BoxDecoration(
              color: tokens.colors.surface,
              boxShadow: [
                BoxShadow(
                  color: tokens.colors.label.withOpacity(0.08),
                  blurRadius: 18.0,
                  offset: const Offset(0.0, -8.0),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: tokens.button.height,
              child: ElevatedButton(
                onPressed: state.canConfirm && !isSubmitting
                    ? () {
                  context.read<PtPackageBookingBloc>().add(
                    const PtPackageBookingConfirmRequested(),
                  );
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: tokens.colors.primary,
                  foregroundColor: tokens.colors.onPrimary,
                  disabledBackgroundColor: tokens.colors.border,
                  disabledForegroundColor: tokens.colors.muted,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(tokens.button.radius),
                  ),
                ),
                child: isSubmitting
                    ? SizedBox(
                  width: 22.0,
                  height: 22.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    color: tokens.colors.onPrimary,
                  ),
                )
                    : Text(
                  l10n.ptPackageConfirmBooking,
                  style: tokens.typography.bodyMedium.copyWith(
                    color: tokens.colors.onPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Converts internal error keys into localized ARB text.
  ///
  /// Do not put hardcoded Arabic/English here.
  static String _resolveErrorMessage({
    required AppLocalizations l10n,
    required String message,
  }) {
    switch (message) {
      case 'ptPackageBookingFailed':
        return l10n.ptPackageBookingFailed;

    /// Keep this only temporarily in case old code/backend still returns it.
      case 'PACKAGE_BOOKING_FAILED':
        return l10n.ptPackageBookingFailed;

      default:
        return message;
    }
  }
}