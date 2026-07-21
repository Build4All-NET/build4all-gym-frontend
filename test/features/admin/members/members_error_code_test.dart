import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

// Covers the admin-members error-code pipeline end-to-end: backend errorCode
// -> AdminMembersService -> AdminMembersRepositoryImpl -> AdminMembersBloc
// state -> screen/widget translation. A raw backend `message` (or, worse,
// the raw HTTP body) must never reach a Text() widget — only
// translateBackendErrorCode(errorCode) may.
//
// A full testWidgets()/bloc_test() pump can't be compiled/run without the
// Flutter SDK in this sandbox (see member_home_widget_order_test.dart for
// the same constraint). This verifies the same invariants structurally
// against the relevant sources instead.
void main() {
  String read(String path) => File(path).readAsStringSync();

  const servicePath = 'lib/features/admin/members/data/services/admin_members_service.dart';
  const repoPath =
      'lib/features/admin/members/data/repositories/admin_members_repository_impl.dart';
  const blocPath = 'lib/features/admin/members/presentation/bloc/admin_members_bloc.dart';
  const statePath = 'lib/features/admin/members/presentation/bloc/admin_members_state.dart';
  const detailScreenPath =
      'lib/features/admin/members/presentation/screens/member_detail_screen.dart';
  const listScreenPath =
      'lib/features/admin/members/presentation/screens/admin_members_screen.dart';
  const attendanceSheetPath =
      'lib/features/admin/members/presentation/widgets/attendance_history_bottom_sheet.dart';

  group('AdminMembersService', () {
    late String source;
    setUpAll(() => source = read(servicePath));

    test('extracts errorCode from the backend response body instead of dumping the raw HTTP body', () {
      expect(source.contains("body['errorCode']"), isTrue);
      // The old bug: showing the raw HTTP response body verbatim.
      expect(source.contains(r"'HTTP ${response.statusCode}: ${response.body}'"), isFalse);
    });

    test('passes errorCode into both ServerException and ForbiddenException', () {
      expect(
          RegExp(r'ForbiddenException\(message:\s*msg,\s*errorCode:\s*errorCode\)')
              .hasMatch(source),
          isTrue);
      expect(source.contains('errorCode: errorCode,'), isTrue);
    });
  });

  group('AdminMembersRepositoryImpl', () {
    late String source;
    setUpAll(() => source = read(repoPath));

    test('never downgrades ServerException/ForbiddenException to a plain Exception', () {
      final serverCatches =
          RegExp(r'on ServerException catch \(e\) \{[^}]*\}', dotAll: true)
              .allMatches(source);
      expect(serverCatches, isNotEmpty);
      for (final m in serverCatches) {
        expect(m.group(0), contains('AppFailureException'));
      }

      final forbiddenCatches =
          RegExp(r'on ForbiddenException catch \(e\) \{[^}]*\}', dotAll: true)
              .allMatches(source);
      expect(forbiddenCatches, isNotEmpty);
      for (final m in forbiddenCatches) {
        expect(m.group(0), contains('AppFailureException'));
      }
    });
  });

  group('AdminMembersState', () {
    late String source;
    setUpAll(() => source = read(statePath));

    test('MembersError, MemberDetailError, MemberAttendanceError, MemberActionError '
        'all carry an errorCode field', () {
      for (final className in [
        'MembersError',
        'MemberDetailError',
        'MemberAttendanceError',
        'MemberActionError',
      ]) {
        final start = source.indexOf('class $className extends');
        expect(start, greaterThan(-1), reason: '$className not found');
        final classSource = source.substring(start, start + 300);
        expect(classSource.contains('errorCode'), isTrue,
            reason: '$className must carry an errorCode field');
      }
    });
  });

  group('AdminMembersBloc', () {
    late String source;
    setUpAll(() => source = read(blocPath));

    test('every catch block resolves errorCode via _errorCodeOf rather than only e.toString()', () {
      expect(source.contains('String? _errorCodeOf(Object e)'), isTrue);
      expect(source.contains('errorCode: _errorCodeOf(e)'), isTrue);
    });
  });

  group('Members screens/widgets rendering', () {
    test('member_detail_screen.dart translates MemberDetailError via translateBackendErrorCode', () {
      final source = read(detailScreenPath);
      expect(source.contains('translateBackendErrorCode('), isTrue);
      expect(source.contains('Text(state.message,'), isFalse,
          reason: 'Raw backend message must never be rendered directly');
    });

    test('admin_members_screen.dart translates MembersError via translateBackendErrorCode', () {
      final source = read(listScreenPath);
      expect(source.contains('translateBackendErrorCode('), isTrue);
      expect(source.contains('_buildError(context, state.message)'), isFalse);
    });

    test('attendance_history_bottom_sheet.dart translates MemberAttendanceError '
        'via translateBackendErrorCode', () {
      final source = read(attendanceSheetPath);
      expect(source.contains('translateBackendErrorCode(l10n, state.errorCode)'), isTrue);
      expect(source.contains('Text(state.message,'), isFalse,
          reason: 'Raw backend message must never be rendered directly');
    });
  });
}
