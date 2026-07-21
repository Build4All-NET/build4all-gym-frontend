import 'package:flutter_test/flutter_test.dart';
import 'package:build4allgym/core/utils/tenant_id_parser.dart';

// Covers the tenantId-fallback bugs found and fixed this session: three
// call sites (trainer_main_screen.dart, trainer_pt_sessions_screen.dart,
// add_edit_class_bottom_sheet.dart) used to silently default to tenant 1
// whenever the stored tenant id was null/unparsable/an unawaited Future's
// .toString(). This shared parser must never do that — callers are
// responsible for treating `null` as "not resolved".
void main() {
  group('TenantIdParser.parseOrNull', () {
    test('parses a valid numeric tenant id', () {
      expect(TenantIdParser.parseOrNull('7'), 7);
    });

    test('returns null (never 1) for a null input', () {
      expect(TenantIdParser.parseOrNull(null), isNull);
    });

    test('returns null (never 1) for an empty string', () {
      expect(TenantIdParser.parseOrNull(''), isNull);
    });

    test('returns null (never 1) for a non-numeric string '
        '(e.g. an unawaited Future\'s toString())', () {
      expect(
        TenantIdParser.parseOrNull("Instance of '_Future<String?>'"),
        isNull,
      );
    });

    test('does not coerce a real tenant id of 1 into a false positive — '
        'tenant 1 legitimately parses to 1', () {
      expect(TenantIdParser.parseOrNull('1'), 1);
    });
  });
}
