// =============================================================================
// FILE: branch_checkin_qr_dialog.dart
//
// Shows the branch's static check-in QR so the owner can display/print it as
// a poster at the entrance. Trainers/reception scan this same code with
// EmployeeQrScannerSheet to self check-in/out.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../domain/usecases/employee_checkins_usecases.dart';

class BranchCheckinQrDialog extends StatelessWidget {
  final int branchId;
  final GetBranchCheckinQrUseCase getBranchQr;

  const BranchCheckinQrDialog({
    super.key,
    required this.branchId,
    required this.getBranchQr,
  });

  static void show(
    BuildContext context, {
    required int branchId,
    required GetBranchCheckinQrUseCase getBranchQr,
  }) {
    showDialog(
      context: context,
      builder: (_) => BranchCheckinQrDialog(branchId: branchId, getBranchQr: getBranchQr),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.read<ThemeCubit>().state.tokens.colors;
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      backgroundColor: c.surface,
      title: Text(l10n.admin_employees_gymCheckinQrTitle, style: TextStyle(color: c.label)),
      content: SizedBox(
        width: 260,
        child: FutureBuilder(
          future: getBranchQr(branchId: branchId),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const SizedBox(
                height: 220,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError) {
              return SizedBox(
                height: 220,
                child: Center(
                  child: Text(
                    l10n.admin_employees_couldNotLoadQr(snapshot.error.toString()),
                    style: TextStyle(color: c.danger),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            final qr = snapshot.data!;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: QrImageView(data: qr.token, size: 200),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.admin_employees_qrPosterInstructions,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.5, color: c.muted),
                ),
              ],
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.admin_employees_close),
        ),
      ],
    );
  }
}
