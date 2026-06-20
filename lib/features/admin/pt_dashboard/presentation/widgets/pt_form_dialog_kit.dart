// =============================================================================
// FILE: lib/features/admin/pt_dashboard/presentation/widgets/pt_form_dialog_kit.dart
//
// Shared building blocks for the PT-dashboard form dialogs (package /
// service / availability) so all three share one consistent, polished
// look: rounded icon header, grouped sections, unified field decoration,
// card-style switches and a sticky footer.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../core/theme/app_theme_tokens.dart';

const double ptDialogRadius = 22;

/// Outer dialog shell: fixed header on top, scrollable [body] in the
/// middle, fixed [footer] pinned to the bottom.
class PtFormDialogScaffold extends StatelessWidget {
  final Widget header;
  final Widget body;
  final Widget footer;

  const PtFormDialogScaffold({
    super.key,
    required this.header,
    required this.body,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.read<ThemeCubit>().state.tokens.colors;
    return Dialog(
      backgroundColor: c.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ptDialogRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          header,
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
              child: body,
            ),
          ),
          footer,
        ],
      ),
    );
  }
}

/// Rounded-icon badge + title + subtitle + close button, shown at the top
/// of every PT-dashboard form dialog.
class PtDialogHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onClose;

  const PtDialogHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.read<ThemeCubit>().state.tokens.colors;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 12, 18),
      decoration: BoxDecoration(
        color: c.primary.withOpacity(0.06),
        border: Border(
          bottom: BorderSide(color: c.border.withOpacity(0.12)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: c.primary,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: c.onPrimary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: c.label,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12.5, color: c.muted, height: 1.3),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onClose,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(Icons.close_rounded, size: 20, color: c.muted),
            ),
          ),
        ],
      ),
    );
  }
}

/// Small uppercase, icon-led label with a trailing divider — used to group
/// related fields inside a dialog's form body.
class PtSectionLabel extends StatelessWidget {
  final IconData icon;
  final String text;

  const PtSectionLabel({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final c = context.read<ThemeCubit>().state.tokens.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 6),
      child: Row(
        children: [
          Icon(icon, size: 14, color: c.primary),
          const SizedBox(width: 6),
          Text(
            text.toUpperCase(),
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: c.primary,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Divider(color: c.border.withOpacity(0.25), height: 1),
          ),
        ],
      ),
    );
  }
}

/// Consistent decoration for text fields, dropdowns and tappable
/// pseudo-fields (time/date pickers) across all PT dialogs.
InputDecoration ptFieldDecoration(
  ColorTokens c, {
  required String label,
  String? hint,
  IconData? icon,
  Widget? suffixIcon,
  String? errorText,
}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    errorText: errorText,
    labelStyle: TextStyle(color: c.muted, fontSize: 13.5),
    floatingLabelStyle: TextStyle(color: c.primary, fontSize: 13.5),
    prefixIcon: icon != null ? Icon(icon, size: 18, color: c.muted) : null,
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: c.background,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: c.border.withOpacity(0.3)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: c.border.withOpacity(0.3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: c.primary, width: 1.6),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: c.danger),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: c.danger, width: 1.6),
    ),
  );
}

/// Card-style toggle row (icon + title + optional subtitle + Switch),
/// used instead of the default [SwitchListTile] for a more deliberate,
/// tappable look that matches the rest of the dialog.
class PtSwitchCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const PtSwitchCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.read<ThemeCubit>().state.tokens.colors;
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: value ? c.primary.withOpacity(0.07) : c.background,
          border: Border.all(
            color:
                value ? c.primary.withOpacity(0.45) : c.border.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: value ? c.primary : c.muted),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: c.label,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TextStyle(fontSize: 11.5, color: c.muted),
                    ),
                  ],
                ],
              ),
            ),
            Switch(value: value, onChanged: onChanged, activeColor: c.primary),
          ],
        ),
      ),
    );
  }
}

/// Sticky Cancel + primary-action footer shared by every PT-dashboard
/// form dialog.
class PtDialogFooter extends StatelessWidget {
  final String cancelLabel;
  final String submitLabel;
  final IconData submitIcon;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  const PtDialogFooter({
    super.key,
    required this.cancelLabel,
    required this.submitLabel,
    required this.onCancel,
    required this.onSubmit,
    this.submitIcon = Icons.check_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.read<ThemeCubit>().state.tokens.colors;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.border.withOpacity(0.12))),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                foregroundColor: c.label,
                side: BorderSide(color: c.border.withOpacity(0.4)),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                cancelLabel,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onSubmit,
              icon: Icon(submitIcon, size: 18),
              label: Text(
                submitLabel,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: c.primary,
                foregroundColor: c.onPrimary,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
