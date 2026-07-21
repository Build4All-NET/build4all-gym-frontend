import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

// Covers the file-storage migration requirement that Flutter never
// hardcodes a dev-only backend host when displaying a file served through
// GET /api/files/{id} — every such call must resolve against the app's
// configured server root (globals.resolveUrl) and attach the caller's auth
// token (globals.fileRequestAuthHeaders), since that endpoint is
// tenant-scoped and requires a valid JWT, unlike the legacy public
// /uploads/** static handler.
//
// A full testWidgets() pump can't be compiled/run without the Flutter SDK
// in this sandbox (see member_home_widget_order_test.dart for the same
// constraint). This verifies the same invariant structurally against the
// relevant sources instead.
void main() {
  String read(String path) => File(path).readAsStringSync();

  const filesUsingApiFiles = [
    'lib/features/member/pt/presentation/widgets/trainer_card_widget.dart',
    'lib/features/member/sessions/presentation/widgets/session_card_widget.dart',
    'lib/features/member/sessions/presentation/screens/session_detail_screen.dart',
  ];

  test('no hardcoded dev host is ever concatenated with /api/files/', () {
    final hardcodedHostPattern = RegExp(r"""['"]https?://[^'"]*api/files/""");
    for (final path in filesUsingApiFiles) {
      final source = read(path);
      expect(hardcodedHostPattern.hasMatch(source), isFalse,
          reason: '$path still hardcodes a backend host for /api/files/');
    }
  });

  test('every /api/files/ Image.network call resolves the URL and attaches auth headers', () {
    for (final path in filesUsingApiFiles) {
      final source = read(path);
      expect(source.contains("resolveUrl('/api/files/"), isTrue,
          reason: '$path must resolve /api/files/ URLs against the configured server root');
      expect(source.contains('fileRequestAuthHeaders()'), isTrue,
          reason: '$path must attach an auth header — /api/files/{id} requires a valid JWT');
    }
  });

  test('globals.dart exposes a dedicated auth-header helper for raw file requests', () {
    final source = read('lib/core/network/globals.dart');
    expect(source.contains('Map<String, String> fileRequestAuthHeaders()'), isTrue);
  });
}
