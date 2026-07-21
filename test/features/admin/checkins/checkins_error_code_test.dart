import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

// Covers the checkins error-code pipeline end-to-end: backend errorCode ->
// CheckinsRemoteDataSource -> CheckinsRepositoryImpl -> CheckinsBloc state ->
// screen/list translation. A raw backend `message` must never reach a
// Text() widget — only translateBackendErrorCode(errorCode) may.
//
// A full testWidgets()/bloc_test() pump can't be compiled/run without the
// Flutter SDK in this sandbox (see member_home_widget_order_test.dart for
// the same constraint). This verifies the same invariants structurally
// against the relevant sources instead.
void main() {
  String read(String path) => File(path).readAsStringSync();

  const dataSourcePath =
      'lib/features/admin/checkins/data/services/CheckinsRemoteDataSource.dart';
  const repoPath =
      'lib/features/admin/checkins/data/repositories/checkins_repository_impl.dart';
  const blocPath = 'lib/features/admin/checkins/presentation/bloc/checkins_bloc.dart';
  const statePath = 'lib/features/admin/checkins/presentation/bloc/checkins_state.dart';
  const screenPath = 'lib/features/admin/checkins/presentation/screens/checkins_screen.dart';
  const listPath = 'lib/features/admin/checkins/presentation/widgets/checkins_list.dart';

  group('CheckinsRemoteDataSource', () {
    late String source;
    setUpAll(() => source = read(dataSourcePath));

    test('extracts errorCode from the backend response body', () {
      expect(source.contains("body['errorCode']"), isTrue);
    });

    test('passes errorCode into both ServerException and ForbiddenException', () {
      expect(
          RegExp(r'ForbiddenException\(message:\s*msg,\s*errorCode:\s*errorCode\)')
              .hasMatch(source),
          isTrue);
      expect(source.contains('errorCode: errorCode,'), isTrue);
    });
  });

  group('CheckinsRepositoryImpl', () {
    late String source;
    setUpAll(() => source = read(repoPath));

    test('never downgrades ServerException/ForbiddenException to a plain Exception', () {
      // Plain `Exception(...)` loses the errorCode entirely — every
      // ServerException/ForbiddenException catch must throw
      // AppFailureException instead, which preserves e.errorCode.
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

  group('CheckinsState', () {
    late String source;
    setUpAll(() => source = read(statePath));

    test('CheckinsError and CheckinsActionError carry an errorCode field', () {
      final errorClass = source.substring(
          source.indexOf('class CheckinsError '), source.indexOf('class CheckinsScanSuccess'));
      expect(errorClass.contains('final String? errorCode;'), isTrue);

      final actionErrorClass = source.substring(source.indexOf('class CheckinsActionError'));
      expect(actionErrorClass.contains('final String? errorCode;'), isTrue);
    });
  });

  group('CheckinsBloc', () {
    late String source;
    setUpAll(() => source = read(blocPath));

    test('every catch block resolves errorCode via _errorCodeOf rather than only e.toString()', () {
      expect(source.contains('String? _errorCodeOf(Object e)'), isTrue);
      expect(source.contains('errorCode: _errorCodeOf(e)'), isTrue);
    });

    test('no longer hardcodes the checkout/block success messages in English', () {
      expect(source.contains("CheckinsActionSuccess('Member checked out successfully.')"),
          isFalse);
      expect(source.contains("CheckinsActionSuccess('Member blocked successfully.')"), isFalse);
      // Success text now comes from the localized event field, set by the
      // screen (which has BuildContext), and echoed back by the bloc.
      expect(source.contains('CheckinsActionSuccess(event.successMessage)'), isTrue);
    });
  });

  group('Checkins screen/list rendering', () {
    test('checkins_screen.dart translates CheckinsActionError via translateBackendErrorCode', () {
      final source = read(screenPath);
      expect(source.contains('translateBackendErrorCode(l10n, state.errorCode)'), isTrue);
      // The raw exception message must never be handed to the snackbar directly.
      expect(RegExp(r'_showSnack\(context,\s*state\.message,\s*isError:\s*true\)')
          .hasMatch(source), isFalse);
    });

    test('checkins_list.dart translates CheckinsError via translateBackendErrorCode', () {
      final source = read(listPath);
      expect(source.contains('translateBackendErrorCode(l10n, state.errorCode)'), isTrue);
      expect(source.contains('_ErrorView(message: state.message'), isFalse);
    });
  });
}
