import 'package:flutter_test/flutter_test.dart';
import 'package:build4allgym/features/admin/AppBar/presentation/branch_context_cubit.dart';

// Covers spec section 1/21: a single centralized branch selection shared
// across every PT screen, with no hardcoded branch id fallback.
void main() {
  group('BranchContextCubit', () {
    test('starts with no branch selected (null = not yet chosen)', () {
      final cubit = BranchContextCubit();
      expect(cubit.state, isNull);
      cubit.close();
    });

    test('select() emits the exact branchId passed in', () {
      final cubit = BranchContextCubit();
      cubit.select(42);
      expect(cubit.state, 42);
      cubit.close();
    });

    test('clear() resets to null ("All branches" for read-only aggregate views)', () {
      final cubit = BranchContextCubit();
      cubit.select(7);
      cubit.clear();
      expect(cubit.state, isNull);
      cubit.close();
    });
  });
}
