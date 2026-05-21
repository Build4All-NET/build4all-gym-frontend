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
      cardTheme: CardThemeData(
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
//dark theme
  static ThemeData buildDark(AppThemeTokens tokens) {
    final c    = tokens.colors;
    final b    = tokens.button;
    final card = tokens.card;
    final text = tokens.typography;

    // ── Dark palette constants ──────────────────────────────────────────────
    // These are the improved colours. Named after their role, not a hex value,
    // so they stay readable as the design evolves.

    const darkBg           = Color(0xFF0D1117); // Page scaffold — deep ink
    const darkSurface      = Color(0xFF161B22); // Drawer, cards, app bars
    const darkSurfaceElev  = Color(0xFF1C2333); // Inputs, popups, elevated cards
    const darkLabel        = Color(0xFFF0F6FC); // Primary text — near white
    const darkBody         = Color(0xFF8B949E); // Secondary text — readable grey
    const darkMuted        = Color(0xFF484F58); // Tertiary/hint — very subtle
    const darkBorder       = Color(0xFF30363D); // Separator lines
    const darkDivider      = Color(0xFF21262D); // Hairline dividers

    // ── ColorScheme ────────────────────────────────────────────────────────
    final colorScheme = ColorScheme(
      brightness:       Brightness.dark,
      // Brand
      primary:          c.primary,
      onPrimary:        c.onPrimary,
      primaryContainer: c.primary.withOpacity(0.15), // subtle tinted container
      onPrimaryContainer: c.primary,
      // Secondary (mirror primary for brand consistency)
      secondary:        c.primary,
      onSecondary:      c.onPrimary,
      secondaryContainer: c.primary.withOpacity(0.10),
      onSecondaryContainer: c.primary,
      // Tertiary
      tertiary:         darkBody,
      onTertiary:       darkLabel,
      tertiaryContainer: darkSurfaceElev,
      onTertiaryContainer: darkLabel,
      // Error
      error:            c.error,
      onError:          c.onPrimary,
      errorContainer:   c.error.withOpacity(0.15),
      onErrorContainer: c.error,
      // Background / Surface
      background:       darkBg,
      onBackground:     darkBody,
      surface:          darkSurface,
      onSurface:        darkLabel,
      // Surface variants (Material 3 uses these for chips, dialogs, etc.)
      surfaceVariant:   darkSurfaceElev,
      onSurfaceVariant: darkBody,
      // Outline
      outline:          darkBorder,
      outlineVariant:   darkDivider,
      // Inverse (used by SnackBars, etc.)
      inverseSurface:   darkLabel,
      onInverseSurface: darkBg,
      inversePrimary:   c.primary,
      // Scrim & shadow
      scrim:            Colors.black,
      shadow:           Colors.black,
    );

    return ThemeData(
      useMaterial3:            true,
      colorScheme:             colorScheme,
      scaffoldBackgroundColor: darkBg,   // Deep ink background for all screens

      // ── App Bar ──────────────────────────────────────────────────────────
      // Surface colour (not background) so the bar subtly lifts off the page.
      // A 1-pixel bottom border acts as a subtle separator instead of a shadow.
      appBarTheme: const AppBarTheme(
        backgroundColor:  darkSurface,
        foregroundColor:  darkLabel,
        elevation:        0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent, // Disable Material 3 tint on scroll
        shadowColor:      Colors.transparent,
        shape: Border(
          bottom: BorderSide(color: darkBorder, width: 0.5),
        ),
      ),

      // ── Text theme ───────────────────────────────────────────────────────
      // IMPROVED: label and body colours now use the richer dark palette
      // instead of the flat grey that was used before.
      textTheme: TextTheme(
        headlineSmall: text.headlineSmall.copyWith(color: darkLabel),
        titleMedium:   text.titleMedium.copyWith(color: darkLabel),
        bodyMedium:    text.bodyMedium.copyWith(color: darkBody),
        bodySmall:     text.bodySmall.copyWith(color: darkMuted),
        // Extra roles used by Material 3 widgets (ListTile, etc.)
        labelSmall:    TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: darkMuted,
          letterSpacing: 0.8,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: darkBody,
        ),
      ),

      // ── Elevated Button ───────────────────────────────────────────────────
      // Brand-colored fill — same in both themes.
      // IMPROVEMENT: added a subtle elevation shadow so the button pops.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.primary,
          foregroundColor: c.onPrimary,
          minimumSize:     const Size.fromHeight(52),
          elevation:       2,
          shadowColor:     c.primary.withOpacity(0.4), // subtle glow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(b.radius),
          ),
        ),
      ),

      // ── Text Button ───────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.primary,
          textStyle: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),

      // ── Input Decoration ──────────────────────────────────────────────────
      // IMPROVED:
      //   • fillColor now uses darkSurfaceElev (one step lighter than surface)
      //     so inputs visually sit above the card background.
      //   • Enabled border is now visible (was too subtle before).
      //   • Hint text colour matches darkBody.
      inputDecorationTheme: InputDecorationTheme(
        filled:    true,
        fillColor: darkSurfaceElev,   // Elevated fill — clearly above surface
        hintStyle: const TextStyle(color: darkMuted),
        labelStyle: const TextStyle(color: darkBody),
        prefixIconColor: darkBody,
        suffixIconColor: darkBody,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(card.radius),
          borderSide: const BorderSide(color: darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(card.radius),
          borderSide: const BorderSide(color: darkBorder), // Visible — not invisible
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(card.radius),
          borderSide: BorderSide(color: c.primary, width: 1.6), // Crisp brand accent
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(card.radius),
          borderSide: BorderSide(color: c.error, width: 1.4),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(card.radius),
          borderSide: BorderSide(color: c.error, width: 1.8),
        ),
      ),

      // ── Card Theme ────────────────────────────────────────────────────────
      // IMPROVED:
      //   • Surface colour (not the same as background) gives cards depth.
      //   • Visible 0.5px border provides structure without being harsh.
      cardTheme: CardThemeData(
        color:     darkSurface,       // One level above the ink background
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(card.radius),
          side: const BorderSide(color: darkBorder, width: 0.5), // Crisp hairline
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Drawer ────────────────────────────────────────────────────────────
      // IMPROVED: explicit DrawerTheme so the drawer gets surface colour
      // (same as cards) instead of bleeding through the scaffold background.
      drawerTheme: const DrawerThemeData(
        backgroundColor: darkSurface,
        scrimColor:      Color(0xCC000000), // 80% black overlay behind drawer
        elevation:       16,                // Deeper shadow for the drawer
        shape: RoundedRectangleBorder(
          // Slight right-side radius — draws the eye to the content edge
          borderRadius: BorderRadius.only(
            topRight:    Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
      ),

      // ── Divider ───────────────────────────────────────────────────────────
      // Hairline separators — barely visible but add structure.
      dividerTheme: const DividerThemeData(
        color:     darkDivider,
        thickness: 0.5,
        space:     1,
      ),

      // ── List Tile (used by some Material 3 list-based widgets) ────────────
      listTileTheme: const ListTileThemeData(
        textColor:  darkBody,
        iconColor:  darkBody,
        tileColor:  Colors.transparent,
      ),

      // ── Popup Menu ────────────────────────────────────────────────────────
      // IMPROVED: elevated surface colour, visible border, no tint.
      popupMenuTheme: PopupMenuThemeData(
        color:            darkSurfaceElev,
        elevation:        8,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: darkBorder, width: 0.5),
        ),
        textStyle: const TextStyle(color: darkBody, fontSize: 13),
      ),

      // ── Dialog ────────────────────────────────────────────────────────────
      dialogTheme: const DialogThemeData(
        backgroundColor:  darkSurface,
        surfaceTintColor: Colors.transparent,
        elevation:        24,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: darkBorder, width: 0.5),
        ),
      ),

      // ── SnackBar ──────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor:  darkSurfaceElev,
        contentTextStyle: const TextStyle(color: darkLabel, fontSize: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: darkBorder, width: 0.5),
        ),
        behavior:         SnackBarBehavior.floating,
        elevation:        6,
      ),

      // ── Switch / Checkbox / Radio ─────────────────────────────────────────
      // Tint from brand color so toggles feel consistent.
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) return c.primary;
          return darkBody;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected))
            return c.primary.withOpacity(0.4);
          return darkBorder;
        }),
      ),
    );
  }
}