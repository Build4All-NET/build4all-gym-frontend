import 'package:flutter/material.dart';

import 'package:build4allgym/core/theme/app_theme_tokens.dart';

/// Email / phone toggle used on the login and signup screens.
class MethodToggle extends StatelessWidget {
  final bool usePhone;
  final AppThemeTokens tokens;
  final String emailLabel;
  final String phoneLabel;
  final void Function(bool) onChanged;

  const MethodToggle({
    super.key,
    required this.usePhone,
    required this.tokens,
    required this.emailLabel,
    required this.phoneLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        // Track background — very light border tint, same opacity pattern
        // used in AppThemeBuilder for card borders
        color:        c.border.withOpacity(0.08),
        borderRadius: BorderRadius.circular(tokens.button.radius),
        border: Border.all(color: c.border.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleTab(
              label:    emailLabel,
              icon:     Icons.email_outlined,
              selected: !usePhone,
              tokens:   tokens,
              onTap:    () { if (usePhone) onChanged(false); },
            ),
          ),
          Expanded(
            child: _ToggleTab(
              label:    phoneLabel,
              icon:     Icons.phone_outlined,
              selected: usePhone,
              tokens:   tokens,
              onTap:    () { if (!usePhone) onChanged(true); },
            ),
          ),
        ],
      ),
    );
  }
}

// Single tab — only AppThemeTokens, no Colors.*
class _ToggleTab extends StatelessWidget {
  final String         label;
  final IconData       icon;
  final bool           selected;
  final AppThemeTokens tokens;
  final VoidCallback   onTap;

  const _ToggleTab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.tokens,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = tokens.colors;

    // Active:   c.surface pill  + c.primary text (matches image: white pill, green text)
    // Inactive: transparent     + c.muted text
    final bgColor = selected ? c.surface : c.surface.withOpacity(0);
    final fgColor = selected ? c.primary : c.muted;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsetsDirectional.all(3),
        decoration: BoxDecoration(
          color:        bgColor,
          borderRadius: BorderRadius.circular(tokens.button.radius - 3),
          boxShadow: selected
              ? [
            BoxShadow(
              // c.label (near-black) at very low opacity — no hardcoded Colors.black
              color:      c.label.withOpacity(0.07),
              blurRadius: 6,
              offset:     const Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: fgColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize:   13,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color:      fgColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}