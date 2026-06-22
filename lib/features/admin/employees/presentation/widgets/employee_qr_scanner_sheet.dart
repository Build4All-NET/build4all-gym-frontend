// =============================================================================
// FILE: employee_qr_scanner_sheet.dart
//
// Modal bottom sheet that opens the camera via mobile_scanner and reads the
// branch's static check-in QR poster. On a successful scan it dispatches
// ScanEmployeeCheckinEvent to the EmployeeCheckinsBloc and closes itself.
// Mirrors lib/features/admin/checkins/presentation/widgets/qr_scanner_sheet.dart.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../bloc/employee_checkins/employee_checkins_bloc.dart';

class EmployeeQrScannerSheet extends StatefulWidget {
  const EmployeeQrScannerSheet({super.key});

  @override
  State<EmployeeQrScannerSheet> createState() => _EmployeeQrScannerSheetState();
}

class _EmployeeQrScannerSheetState extends State<EmployeeQrScannerSheet> {
  final MobileScannerController _scanner = MobileScannerController();
  bool _scanned = false;

  @override
  void dispose() {
    _scanner.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return;

    final rawValue = capture.barcodes.firstOrNull?.rawValue;
    if (rawValue == null || rawValue.isEmpty) return;

    _scanned = true;
    context.read<EmployeeCheckinsBloc>().add(ScanEmployeeCheckinEvent(rawValue));
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c = tokens.colors;
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.65,
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: c.muted.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.admin_employees_qrScanTitle,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: c.label),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              l10n.admin_employees_qrScanSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.5, color: c.muted),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(0), bottom: Radius.circular(20)),
              child: MobileScanner(
                controller: _scanner,
                onDetect: _onDetect,
                overlayBuilder: (context, constraints) => _ViewfinderOverlay(
                  color: c.primary,
                  size: constraints.maxWidth * 0.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewfinderOverlay extends StatelessWidget {
  final Color color;
  final double size;
  const _ViewfinderOverlay({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.8), width: 3),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

void showEmployeeQrScannerSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => BlocProvider.value(
      value: context.read<EmployeeCheckinsBloc>(),
      child: const EmployeeQrScannerSheet(),
    ),
  );
}
