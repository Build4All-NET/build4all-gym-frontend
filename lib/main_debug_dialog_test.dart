import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:build4allgym/core/theme/theme_cubit.dart';
import 'package:build4allgym/features/member/account/presentation/widgets/profile_completion_dialog.dart';

void main() {
  runApp(const _DebugApp());
}

class _DebugApp extends StatelessWidget {
  const _DebugApp();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: ElevatedButton(
              key: const Key('openDialogBtn'),
              onPressed: () {
                ProfileCompletionDialog.show(
                  context,
                  existing: const {},
                  onCompleted: () {},
                );
              },
              child: const Text('Open Dialog'),
            ),
          ),
        ),
      ),
    );
  }
}
