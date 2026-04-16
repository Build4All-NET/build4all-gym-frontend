// ─────────────────────────────────────────────────────────────────────────────
// lib/common/widgets/app_text_field.dart
//
// PURPOSE:
//   Reusable, themed form text field used across ALL screens (login, register,
//   forgot password, profile, etc.). Pulls colors and border radius from
//   ThemeCubit so it always matches the current remote/dynamic theme.
//
// FEATURES:
//   - Label above the field (not inside it as a floating label)
//   - Optional password toggle (eye icon) when obscureText = true
//   - Supports single-line and multi-line modes
//   - Validator-ready (works with Form + GlobalKey)
//   - autovalidateMode can be set per-field or inherited from the parent Form
//
// RELATIONSHIPS:
//   ◀ Used by:    ForgotPasswordScreen, ForgotPasswordVerifyScreen,
//                 ForgotPasswordNewPasswordScreen, LoginScreen, RegisterScreen…
//   ▶ Reads from: ThemeCubit (colors, card radius)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/theme_cubit.dart';

class AppTextField extends StatefulWidget {
  // ── Required ──────────────────────────────────────────────────────────────

  /// Label displayed above the field.
  final String label;

  /// Controller that holds and tracks the field's text value.
  final TextEditingController controller;

  // ── Optional appearance ───────────────────────────────────────────────────

  /// Grey placeholder text shown when the field is empty.
  final String? hintText;

  /// Keyboard type shown when the field is focused (email, number, text…).
  final TextInputType keyboardType;

  /// Whether to hide the text (password mode). Shows a toggle icon when true.
  final bool obscureText;

  // ── Validation ────────────────────────────────────────────────────────────

  /// Standard FormField validator. Return an error string or null.
  final String? Function(String?)? validator;

  /// Controls when validation runs for THIS field.
  /// Passing null (default) inherits the parent Form's autovalidateMode,
  /// which is the recommended approach for consistent form behaviour.
  final AutovalidateMode? autovalidateMode;

  // ── Multi-line support ────────────────────────────────────────────────────

  /// Number of visible lines. Default 1 (single-line).
  final int maxLines;

  /// Minimum lines before the field expands (multi-line only).
  final int? minLines;

  // ── Keyboard action ───────────────────────────────────────────────────────

  /// The action button shown on the keyboard (next, done, search…).
  final TextInputAction? textInputAction;

  // ── Focus & behaviour ─────────────────────────────────────────────────────

  /// External FocusNode — lets the parent control focus programmatically.
  final FocusNode? focusNode;

  /// Whether this field requests focus automatically on screen load.
  final bool autofocus;

  /// Whether the field accepts input. False = greyed out.
  final bool enabled;

  /// True = shows text but prevents editing (e.g. pre-filled read-only data).
  final bool readOnly;

  // ── Callbacks ─────────────────────────────────────────────────────────────

  /// Called every time the text changes.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits (presses the keyboard action button).
  final ValueChanged<String>? onFieldSubmitted;

  /// Called when editing is complete (focus leaves the field).
  final VoidCallback? onEditingComplete;

  /// Called when the parent Form saves (form.currentState!.save()).
  final FormFieldSetter<String>? onSaved;

  // ── Extras ────────────────────────────────────────────────────────────────

  /// Restricts what characters the user can type (e.g. digits only).
  final List<TextInputFormatter>? inputFormatters;

  /// Auto-capitalisation behaviour (words, sentences, characters, none).
  final TextCapitalization textCapitalization;

  /// Maximum number of characters allowed. Counter is hidden (counterText: '').
  final int? maxLength;

  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.maxLines = 1,
    this.minLines,
    this.textInputAction,
    this.focusNode,
    this.autofocus = false,
    this.enabled = true,
    this.readOnly = false,
    this.autovalidateMode,
    this.onChanged,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.onSaved,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.maxLength,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  /// Local toggle state for password visibility.
  /// Starts as whatever the parent passed for obscureText.
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the parent flips obscureText dynamically, sync our local state once.
    // This prevents the eye icon from getting out of sync.
    if (oldWidget.obscureText != widget.obscureText) {
      _obscure = widget.obscureText;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pull design tokens from the active theme (remote or fallback)
    final themeState = context.watch<ThemeCubit>().state;
    final colors = themeState.tokens.colors;
    final card = themeState.tokens.card;
    final t = Theme.of(context).textTheme;

    // The toggle is only relevant for single-line password fields
    final canToggleObscure = widget.obscureText && widget.maxLines == 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label rendered above the field (not as a floating hint)
        Text(widget.label, style: t.bodyMedium?.copyWith(color: colors.label)),
        const SizedBox(height: 6),

        TextFormField(
          controller: widget.controller,

          // Focus & behaviour
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          enabled: widget.enabled,
          readOnly: widget.readOnly,

          // Input type
          keyboardType: widget.keyboardType,
          // Only apply obscuring on single-line password fields
          obscureText: canToggleObscure ? _obscure : false,

          // Validation
          validator: widget.validator,
          onSaved: widget.onSaved,
          // null = inherit from parent Form — the correct approach for forms
          autovalidateMode: widget.autovalidateMode,

          // Multi-line
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          textInputAction: widget.textInputAction,

          // Callbacks
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          onEditingComplete: widget.onEditingComplete,

          // Formatting
          inputFormatters: widget.inputFormatters,
          textCapitalization: widget.textCapitalization,
          maxLength: widget.maxLength,

          decoration: InputDecoration(
            hintText: widget.hintText,
            filled: true,
            fillColor: colors.surface,
            // Hide the character counter (avoids layout shift with maxLength)
            counterText: '',

            // Default border (unfocused, valid)
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(card.radius),
              borderSide: BorderSide(color: colors.border.withOpacity(0.3)),
            ),
            // Explicitly set enabled border so it matches the design token
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(card.radius),
              borderSide: BorderSide(color: colors.border.withOpacity(0.3)),
            ),
            // Primary colour border when focused
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(card.radius),
              borderSide: BorderSide(color: colors.primary, width: 1.4),
            ),

            // Eye icon for password fields — toggles _obscure on tap
            suffixIcon: canToggleObscure
                ? IconButton(
              icon: Icon(
                _obscure ? Icons.visibility_off : Icons.visibility,
                color: colors.body.withOpacity(0.8),
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            )
                : null,
          ),
        ),
      ],
    );
  }
}