// ─────────────────────────────────────────────────────────────────────────────
// lib/core/config/env.dart
//
// PURPOSE:
//   Centralised access point for ALL compile-time configuration values.
//   Values are injected at build time via --dart-define=KEY=VALUE (or
//   --dart-define-from-file=config.json). This means a single codebase can
//   run as different gym apps just by changing the build command.
//
// HOW IT WORKS:
//   String.fromEnvironment('KEY', defaultValue: 'fallback') reads the value
//   baked in at compile time. At runtime the values are constants — they
//   cannot be changed.
//
// RELATIONSHIPS:
//   ◀ Read by:  ForgotPasswordApiService (apiBaseUrl, ownerProjectLinkId)
//               ThemeCubit (themeJsonB64, apiBaseUrl, ownerProjectLinkId)
//               ForgotPasswordBloc event constructors (ownerProjectLinkId)
//               RuntimeConfigService (apiBaseUrl, ownerProjectLinkId)
// ─────────────────────────────────────────────────────────────────────────────

class Env {
  /// Base URL for all HTTP calls (e.g. "http://192.168.1.4:8867").
  /// Override via --dart-define=API_BASE_URL=https://api.mygym.com
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.1.4:8867',
  );

  /// WebSocket path appended to apiBaseUrl for real-time features.
  static const wsPath = String.fromEnvironment(
    'WS_PATH',
    defaultValue: '/api/ws',
  );

  /// Stripe publishable key for payment processing. Empty = Stripe disabled.
  static const stripePublishableKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue: '',
  );

  /// Currency code sent to Stripe (e.g. "usd", "eur"). Empty = not sent.
  static const currencyCode = String.fromEnvironment(
    'CURRENCY_CODE',
    defaultValue: '',
  );

  /// Which user roles this build serves: "user", "business", or "both".
  static const appRole = String.fromEnvironment(
    'APP_ROLE',
    defaultValue: 'both',
  );

  /// How ownerProjectLinkId is attached to requests:
  /// "header" | "query" | "body" | "off"
  static const ownerAttachMode = String.fromEnvironment(
    'OWNER_ATTACH_MODE',
    defaultValue: 'header',
  );

  /// The specific gym/project link ID for this build.
  /// Used in every API call so the backend knows which gym's data to return.
  static const ownerProjectLinkId = String.fromEnvironment(
    'OWNER_PROJECT_LINK_ID',
    defaultValue: '1',
  );

  /// The project ID (used for some internal routing, not every feature needs it).
  static const projectId = String.fromEnvironment(
    'PROJECT_ID',
    defaultValue: '0',
  );

  /// Display name of this gym app (shown in UI and app store listing).
  static const appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'Build4All App',
  );

  /// Remote URL of the app logo image. Empty = show no remote logo.
  static const appLogoUrl = String.fromEnvironment(
    'APP_LOGO_URL',
    defaultValue: '',
  );

  /// Raw JSON theme string (legacy — prefer themeJsonB64 below).
  static const themeJson = String.fromEnvironment(
    'THEME_JSON',
    defaultValue: '{}',
  );

  /// Raw JSON nav config (legacy — prefer navJsonB64 below).
  static const navJson = String.fromEnvironment('NAV_JSON', defaultValue: '[]');

  /// Raw JSON enabled features list (legacy).
  static const enabledFeaturesJson = String.fromEnvironment(
    'ENABLED_FEATURES_JSON',
    defaultValue: '[]',
  );

  /// App type determines which feature set is active (e.g. "ACTIVITIES", "GYM").
  static const appType = String.fromEnvironment(
    'APP_TYPE',
    defaultValue: 'ACTIVITIES',
  );

  /// Numeric ID of the theme preset selected in the Build4All manager.
  static const themeId = String.fromEnvironment('THEME_ID', defaultValue: '0');

  /// Base64-encoded JSON theme blob — preferred over themeJson.
  /// ThemeCubit reads this first; if present, skips the runtime API call.
  static const themeJsonB64 = String.fromEnvironment(
    'THEME_JSON_B64',
    defaultValue: '',
  );

  /// Base64-encoded JSON nav config — preferred over navJson.
  static const navJsonB64 = String.fromEnvironment(
    'NAV_JSON_B64',
    defaultValue: '',
  );

  /// Base64-encoded JSON enabled features list.
  static const enabledFeaturesJsonB64 = String.fromEnvironment(
    'ENABLED_FEATURES_JSON_B64',
    defaultValue: '',
  );

  /// Base64-encoded home screen layout JSON.
  static const homeJsonB64 = String.fromEnvironment(
    'HOME_JSON_B64',
    defaultValue: '',
  );

  /// Currency ID used for server-side pricing lookups.
  static const currencyId = String.fromEnvironment(
    'CURRENCY_ID',
    defaultValue: '',
  );

  /// Navigation style for this build: "bottom" | "drawer" | "hamburger".
  /// Overrides whatever is in the branding JSON.
  static const menuType = String.fromEnvironment(
    'MENU_TYPE',
    defaultValue: '',
  );

  /// Base64-encoded branding config (includes menuType and other visual settings).
  /// Used when the manager bakes the full branding blob into the build.
  static const brandingJsonB64 = String.fromEnvironment(
    'BRANDING_JSON_B64',
    defaultValue: '',
  );
}