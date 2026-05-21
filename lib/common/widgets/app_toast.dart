import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/theme_cubit.dart';
import '../../core/exceptions/exception_mapper.dart';

/// Controls which colour palette is applied to the toast.
enum AppToastType { success, error, info }

/// Centralised utility for showing themed toast notifications.
///
/// Uses the root [Overlay] so toasts always render above dialogs and
/// bottom sheets. Call [success], [error], or [info] — never use
/// [ScaffoldMessenger] directly in screens.
class AppToast {
  static OverlayEntry? _currentEntry;

  static void _show(
      BuildContext context,
      Object message, {
        required AppToastType type,
      }) {
    final themeState = context.read<ThemeCubit>().state;
    final colors = themeState.tokens.colors;
    final clean = ExceptionMapper.toMessage(message);

    Color bg;
    Color fg;
    switch (type) {
      case AppToastType.error:
        bg = colors.error;
        fg = colors.onPrimary;
        break;
      case AppToastType.success:
        bg = colors.primary;
        fg = colors.onPrimary;
        break;
      case AppToastType.info:
        bg = colors.primary;
        fg = colors.onPrimary;
        break;
    }

    // Dismiss any existing toast immediately before showing the new one.
    _currentEntry?.remove();
    _currentEntry = null;

    // rootOverlay: true guarantees insertion above all dialogs/sheets.
    final overlayState = Overlay.of(context, rootOverlay: true);

    OverlayEntry? entry;
    entry = OverlayEntry(
      builder: (_) => _AppToastOverlay(
        message: clean,
        backgroundColor: bg,
        foregroundColor: fg,
        onDismiss: () {
          entry?.remove();
          if (_currentEntry == entry) _currentEntry = null;
        },
      ),
    );
    _currentEntry = entry;
    overlayState.insert(entry);
  }

  static void success(BuildContext context, Object message) =>
      _show(context, message, type: AppToastType.success);

  static void error(BuildContext context, Object error) =>
      _show(context, error, type: AppToastType.error);

  static void info(BuildContext context, Object message) =>
      _show(context, message, type: AppToastType.info);
}

// ─────────────────────────────────────────────────────────────────────────────
// Private overlay widget
// ─────────────────────────────────────────────────────────────────────────────

class _AppToastOverlay extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onDismiss;

  const _AppToastOverlay({
    required this.message,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onDismiss,
  });

  @override
  State<_AppToastOverlay> createState() => _AppToastOverlayState();
}

class _AppToastOverlayState extends State<_AppToastOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
    Future.delayed(const Duration(seconds: 3), _dismiss);
  }

  Future<void> _dismiss() async {
    if (!mounted) return;
    await _ctrl.reverse();
    if (mounted) widget.onDismiss();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: SlideTransition(
              position: _slide,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    widget.message,
                    style: TextStyle(
                      color: widget.foregroundColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}