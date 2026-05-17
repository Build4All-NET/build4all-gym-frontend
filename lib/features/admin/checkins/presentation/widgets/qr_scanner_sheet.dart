// =============================================================================
// FILE: qr_scanner_sheet.dart
// PATH: lib/features/admin/checkins/presentation/widgets/qr_scanner_sheet.dart
// LAYER: Presentation Layer → Widgets
//
// PURPOSE:
//   Modal bottom sheet that opens the camera via mobile_scanner and reads
//   a member's QR code.  On a successful scan it dispatches ScanQrCode to
//   the CheckinsBloc and closes itself.
//
// PACKAGE:
//   mobile_scanner — add to pubspec.yaml:
//     mobile_scanner: ^6.0.0
//
// UX FLOW:
//   1. Admin taps QR icon in AppBar.
//   2. showModalBottomSheet opens this widget.
//   3. Camera viewfinder appears.
//   4. Scanner reads QR → extracts token → dispatches ScanQrCode → sheet closes.
//   5. BlocListener in CheckinsScreen shows snackbar (success = green, error = red).
//   6. BLoC auto-dispatches LoadTodayCheckins → list refreshes.
//
// PERMISSIONS:
//   Android: add <uses-permission android:name="android.permission.CAMERA"/>
//             to android/app/src/main/AndroidManifest.xml
//   iOS:     add NSCameraUsageDescription to Info.plist
//   Runtime: handled by mobile_scanner's MobileScanner widget automatically.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../bloc/checkins_bloc.dart';

class QrScannerSheet extends StatefulWidget {
  const QrScannerSheet({super.key});

  @override
  State<QrScannerSheet> createState() => _QrScannerSheetState();
}

class _QrScannerSheetState extends State<QrScannerSheet> {
  final MobileScannerController _scanner = MobileScannerController();
  bool _scanned = false; // Guard against scanning the same QR twice.

  @override
  void dispose() {
    _scanner.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    // Ignore if we already processed one scan in this session.
    if (_scanned) return;

    final rawValue = capture.barcodes.firstOrNull?.rawValue;
    if (rawValue == null || rawValue.isEmpty) return;

    // Mark as scanned so no duplicate events fire.
    _scanned = true;

    // Dispatch to BLoC — the sheet closes first so the BlocListener
    // in CheckinsScreen is the one that shows the snackbar.
    context.read<CheckinsBloc>().add(ScanQrCode(rawValue));

    // Close the sheet.
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;
    final l10n   = AppLocalizations.of(context)!;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.65,
      child: Column(
        children: [
          // ── Handle bar ────────────────────────────────────────────────────
          const SizedBox(height: 12),
          Container(
            width:  40,
            height: 4,
            decoration: BoxDecoration(
              color:        c.muted.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // ── Title ─────────────────────────────────────────────────────────
          Text(
            l10n.checkins_scannerTitle,
            style: TextStyle(
              fontSize:   17,
              fontWeight: FontWeight.w700,
              color:      c.label,
            ),
          ),
          const SizedBox(height: 16),

          // ── Camera viewfinder ──────────────────────────────────────────────
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(0), bottom: Radius.circular(20)),
              child: MobileScanner(
                controller: _scanner,
                onDetect:   _onDetect,
                // Overlay: a semi-transparent frame to guide the admin.
                overlayBuilder: (context, constraints) => _ViewfinderOverlay(
                  color: c.primary,
                  size:  constraints.maxWidth * 0.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Viewfinder corner overlay ─────────────────────────────────────────────────
class _ViewfinderOverlay extends StatelessWidget {
  final Color  color;
  final double size;
  const _ViewfinderOverlay({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width:  size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.8), width: 3),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helper function — called from CheckinsScreen AppBar tap.
// ─────────────────────────────────────────────────────────────────────────────
void showQrScannerSheet(BuildContext context) {
  showModalBottomSheet(
    context:            context,
    isScrollControlled: true,
    backgroundColor:    Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => BlocProvider.value(
      value: context.read<CheckinsBloc>(),
      child: const QrScannerSheet(),
    ),
  );
}
