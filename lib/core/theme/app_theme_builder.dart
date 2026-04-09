import 'package:flutter/material.dart';
import 'app_theme_tokens.dart';

class AppThemeBuilder {
  // converts your design tokens (colors, sizes, typography) into a Flutter ThemeData object.
  // Every widget in your app inherits styles from here — buttons, inputs, cards, text
  // so you never hardcode colors or sizes in individual screens.
  static ThemeData build(AppThemeTokens tokens) {

    final c    = tokens.colors;      // All color values
    final b    = tokens.button;      // Button-specific tokens (radius, etc.)
    final card = tokens.card;        // Card-specific tokens (radius, elevation)
    final text = tokens.typography;  // TextStyle definitions


    final colorScheme = ColorScheme.fromSeed(
      seedColor:    c.primary,
      primary:      c.primary,
      onPrimary:    c.onPrimary,
      background:   c.background,
      surface:      c.surface,
      error:        c.error,
      secondary:    c.primary,
      onSecondary:  c.onPrimary,
      onBackground: c.body,
      onSurface:    c.body,
      onError:      c.onPrimary,
      brightness:   Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,           // Opt in to Material 3 design language
      colorScheme:  colorScheme,
      scaffoldBackgroundColor: c.background, // Sets the base page color for all screens

      // ───────────────────────────────────────────────────────────────
      // APP BAR
      // ───────────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: c.surface,  // surface bar, not primary colored
        foregroundColor: c.label,    // Back arrow and title use the label color
        elevation: 0,                // Flat — no shadow under the bar
      ),

      // ───────────────────────────────────────────────────────────────
      // TEXT THEME
      // Maps your token TextStyles to Flutter's semantic text roles.
      // Screens reference these roles (e.g. Theme.of(context).textTheme
      // .headlineSmall) instead of hardcoding font sizes.
      // ───────────────────────────────────────────────────────────────
      textTheme: TextTheme(
        headlineSmall: text.headlineSmall, // Screen titles: "Reset your password"
        titleMedium:   text.titleMedium,   // Card section headers
        bodyMedium:    text.bodyMedium,    // Regular body copy
        bodySmall:     text.bodySmall,     // Hints, tips, small labels
      ),

      // ───────────────────────────────────────────────────────────────
      // ELEVATED BUTTON
      // Used for the primary CTA on every screen:
      //   • Login   → "Sign In"
      //   • Screen 1 → "Send code"
      //   • Screen 2 → "Verify"
      //   • Screen 3 → "Save password"
      // All share the same rounded, brand-colored style.
      // ───────────────────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.primary,   // Filled with brand color
          foregroundColor: c.onPrimary, // Label text is white (or contrast color)
          minimumSize: const Size.fromHeight(52), // Full-width tall button
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(b.radius), // Pill or rounded corners
          ),
        ),
      ),

      // ───────────────────────────────────────────────────────────────
      // TEXT BUTTON  ←for forgot-password
      // Used for the "Resend code" link on Screen 2 and any secondary
      // tap actions. Without this, Flutter defaults to system blue
      // ───────────────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.primary, // Brand color for the link text
          textStyle: text.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600, // Slightly bolder so it reads as a link
          ),
        ),
      ),

      // ───────────────────────────────────────────────────────────────
      // INPUT DECORATION (TextField / TextFormField)
      // All three forgot-password screens have text inputs.
      // This theme makes every TextField look identical without
      // repeating decoration code in each screen widget.
      //
      // States:
      //   enabled  → subtle border (low opacity)
      //   focused  → brand-colored border (user knows which field is active)
      //   error    → Flutter automatically uses colorScheme.error
      // ───────────────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled:    true,          // Background fill is enabled
        fillColor: c.surface,     // Inputs have a white/surface background

        // Default border (when field is not focused and has no error)
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(card.radius),
          borderSide: BorderSide(color: c.border.withOpacity(0.3)),
        ),
        // Enabled but not focused
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(card.radius),
          borderSide: BorderSide(color: c.border.withOpacity(0.3)),
        ),
        // Focused — brand-colored border, slightly thicker to stand out
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(card.radius),
          borderSide: BorderSide(color: c.primary, width: 1.4),
        ),
        // Error state — Flutter uses colorScheme.error automatically,
        // but we keep the same border radius for visual consistency
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(card.radius),
          borderSide: BorderSide(color: c.error, width: 1.4),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(card.radius),
          borderSide: BorderSide(color: c.error, width: 1.8),
        ),
      ),

      // ───────────────────────────────────────────────────────────────
      // CARD THEME  ←for forgot-password
      // All three screens wrap their form fields in a Card widget —
      // the white rounded container
      // Without this theme, Card uses Material 3 defaults which add
      // elevation tint and different corner radii.
      // ───────────────────────────────────────────────────────────────
      cardTheme: CardTheme(
        color:     c.surface, // White/surface — matches input fill color
        elevation: 0,         // Flat card — shadow comes from the border, not elevation
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(card.radius), // Same radius as inputs
          side: BorderSide(
            color: c.border.withOpacity(0.15), //outline
          ),
        ),
        margin: EdgeInsets.zero, // Screens control their own padding, card adds none
      ),
    );
  }
}