// PATH: lib/common/widgets/form_section_kit.dart
//
// Shared visual kit for bottom-sheet forms (Add/Edit Plan, Add/Edit Class…).
// Keeping these pieces in one place is what makes every form sheet in the
// app look like part of the same product instead of a patchwork of one-off
// styles.

import 'package:flutter/material.dart';

import '../../core/theme/app_theme_tokens.dart';

/// Small grey drag handle shown at the top of every bottom sheet.
class FormSheetHandle extends StatelessWidget {
  final ColorTokens c;
  const FormSheetHandle(this.c, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: c.border.withOpacity(0.35),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

/// Title row used at the top of a form sheet: a gradient icon badge,
/// title + optional subtitle, and a circular close button.
class FormSheetHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final ColorTokens c;
  final VoidCallback onClose;

  const FormSheetHeader({
    super.key,
    required this.title,
    required this.icon,
    required this.c,
    required this.onClose,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [c.primary, c.primary.withOpacity(0.72)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                color: c.primary.withOpacity(0.28),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: c.onPrimary, size: 21),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: c.label,
                  letterSpacing: -0.2,
                ),
              ),
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    subtitle!,
                    style: TextStyle(fontSize: 12.5, color: c.muted),
                  ),
                ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onClose,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: c.background,
              shape: BoxShape.circle,
              border: Border.all(color: c.border.withOpacity(0.2)),
            ),
            child: Icon(Icons.close_rounded, size: 18, color: c.muted),
          ),
        ),
      ],
    );
  }
}

/// Section header used to break a long form into readable groups:
/// a small tinted icon chip, bold label, and a trailing divider.
class FormSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final ColorTokens c;
  final EdgeInsets padding;

  const FormSectionHeader({
    super.key,
    required this.title,
    required this.icon,
    required this.c,
    this.padding = const EdgeInsets.only(top: 28, bottom: 14),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: c.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 15, color: c.primary),
          ),
          const SizedBox(width: 9),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: c.label,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Divider(color: c.border.withOpacity(0.25), height: 1)),
        ],
      ),
    );
  }
}

/// Label rendered above an input field.
class FormFieldLabel extends StatelessWidget {
  final String text;
  final ColorTokens c;
  const FormFieldLabel(this.text, this.c, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: c.body),
      ),
    );
  }
}

/// Standard input decoration shared by every text field / dropdown across
/// form sheets — same radius, border weight and focus colour everywhere.
InputDecoration formInputDecoration({
  required String hint,
  required ColorTokens c,
  IconData? prefixIcon,
  Widget? suffixIcon,
  double radius = 12,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: c.muted, fontSize: 14),
    filled: true,
    fillColor: c.background,
    prefixIcon: prefixIcon == null
        ? null
        : Icon(prefixIcon, size: 18, color: c.muted),
    suffixIcon: suffixIcon,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: c.border.withOpacity(0.25)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: c.border.withOpacity(0.25)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: c.primary, width: 1.6),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: c.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: c.error, width: 1.6),
    ),
  );
}

/// Two-way (or N-way) segmented toggle chip, e.g. "Unlimited / Limited".
class FormToggleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ColorTokens c;
  final IconData? icon;

  const FormToggleChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.c,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: selected ? c.primary.withOpacity(0.12) : c.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? c.primary : c.border.withOpacity(0.3)),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: selected ? c.primary : c.muted),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  color: selected ? c.primary : c.muted,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tappable field that looks like a text input but opens a picker
/// (date / time). Optionally shows a clear ("x") action when filled.
class FormPickerField extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool hasValue;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  final ColorTokens c;

  const FormPickerField({
    super.key,
    required this.icon,
    required this.label,
    required this.hasValue,
    required this.onTap,
    required this.c,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: c.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: c.border.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: c.muted),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: hasValue ? c.label : c.muted,
                  fontSize: 14,
                  fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (hasValue && onClear != null)
              GestureDetector(
                onTap: onClear,
                child: Icon(Icons.close_rounded, size: 15, color: c.muted),
              ),
          ],
        ),
      ),
    );
  }
}

/// Card-like container used to visually group related controls
/// (e.g. a pair of switches, or a date+time row) inside a section.
class FormGroupCard extends StatelessWidget {
  final Widget child;
  final ColorTokens c;
  final EdgeInsetsGeometry padding;

  const FormGroupCard({
    super.key,
    required this.child,
    required this.c,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: c.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.border.withOpacity(0.2)),
      ),
      child: child,
    );
  }
}

/// Full-width primary action button for the bottom of a form sheet,
/// with a built-in loading spinner state.
class FormPrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool loading;
  final VoidCallback? onPressed;
  final Color background;
  final Color foreground;

  const FormPrimaryButton({
    super.key,
    required this.label,
    required this.background,
    required this.foreground,
    this.icon,
    this.loading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: loading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: foreground, strokeWidth: 2.2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 19),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
      ),
    );
  }
}