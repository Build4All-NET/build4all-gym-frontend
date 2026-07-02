import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';

import '../../data/services/member_pt_service.dart';
import '../bloc/pt_package_booking_bloc.dart';
import '../bloc/pt_package_booking_state.dart';
import 'pt_package_payment_sheet.dart';

class PtPackageConfirmBarWidget extends StatelessWidget {
  final MemberPtService memberPtService;

  const PtPackageConfirmBarWidget({
    super.key,
    required this.memberPtService,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PtPackageBookingBloc, PtPackageBookingState>(
      listener: (context, state) {
        final l10n = AppLocalizations.of(context)!;

        if (state is PtPackageTimeRequestSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.ptTimeRequestSuccess),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }

        if (state is PtPackageTimeRequestError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message == 'ptRequestTimeFailed'
                    ? l10n.ptTimeRequestFailed
                    : state.message,
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        final tokens = context.read<ThemeCubit>().state.tokens;

        if (state is! PtPackageBookingLoaded) {
          return const SizedBox.shrink();
        }

        final selectedPackage = state.selectedPackage;

        final isSubmitting = state is PtPackageBookingSubmitting;

        /*
         * Booking status belongs to the selected package only.
         *
         * Package A may be PENDING while Package B remains NONE.
         */
        final isPending = selectedPackage?.isPending ?? false;
        final isActive = selectedPackage?.isActive ?? false;
        final isCancelRequested =
            selectedPackage?.isCancelRequested ?? false;

        final isPackageBlocked =
            isPending || isActive || isCancelRequested;

        final canSubmit =
            state.canConfirm &&
                !isSubmitting &&
                !isPackageBlocked;

        String buttonText;

        if (isPending) {
          buttonText = 'Pending confirmation';
        } else if (isActive) {
          buttonText = 'Package active';
        } else if (isCancelRequested) {
          buttonText = 'Cancellation requested';
        } else {
          buttonText = l10n.ptPackageConfirmBooking;
        }

        return SafeArea(
          top: false,
          child: Container(
            padding: EdgeInsets.all(tokens.spacing.lg),
            decoration: BoxDecoration(
              color: tokens.colors.surface,
              boxShadow: [
                BoxShadow(
                  color: tokens.colors.label.withOpacity(0.08),
                  blurRadius: 18,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: tokens.button.height,
              child: ElevatedButton(
                onPressed: canSubmit
                    ? () => _openPaymentSheet(
                  context,
                  state,
                )
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: tokens.colors.primary,
                  foregroundColor: tokens.colors.onPrimary,
                  disabledBackgroundColor: tokens.colors.border,
                  disabledForegroundColor: tokens.colors.muted,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      tokens.button.radius,
                    ),
                  ),
                ),
                child: isSubmitting
                    ? SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: tokens.colors.onPrimary,
                  ),
                )
                    : Text(
                  buttonText,
                  style: tokens.typography.bodyMedium.copyWith(
                    color: canSubmit
                        ? tokens.colors.onPrimary
                        : tokens.colors.muted,
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

  void _openPaymentSheet(
      BuildContext context,
      PtPackageBookingLoaded state,
      ) {
    final package = state.selectedPackage;

    if (package == null) return;

    /*
     * Extra protection.
     * Even if the UI state becomes inconsistent, do not reopen
     * payment for a package already pending or active.
     */
    if (package.isBookingDisabled) return;

    PtPackagePaymentSheet.show(
      context,
      totalAmount: package.finalPrice,
      packageName: package.name,
      memberPtService: memberPtService,
    );
  }
}