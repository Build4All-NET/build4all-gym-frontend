// =============================================================================
// FILE: checkins_search_bar.dart
// PATH: lib/features/admin/checkins/presentation/widgets/checkins_search_bar.dart
// LAYER: Presentation Layer → Widgets
//
// PURPOSE:
//   Debounced search bar that dispatches SearchMembers events after the user
//   stops typing for 400 ms.  On clear → dispatches LoadTodayCheckins to reset.
//
// DEBOUNCE:
//   Uses dart:async Timer — no third-party package needed.
//   400 ms balances responsiveness vs. too many API calls.
// =============================================================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/theme_cubit.dart';
import '../../../../../l10n/app_localizations.dart';
import '../bloc/checkins_bloc.dart';

class CheckinsSearchBar extends StatefulWidget {
  const CheckinsSearchBar({super.key});

  @override
  State<CheckinsSearchBar> createState() => _CheckinsSearchBarState();
}

class _CheckinsSearchBarState extends State<CheckinsSearchBar> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    // Cancel any pending debounce timer so we only fire after the user pauses.
    _debounce?.cancel();

    if (value.isEmpty) {
      // Immediate reset when the user clears the field.
      context.read<CheckinsBloc>().add(const LoadTodayCheckins());
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 400), () {
      // This fires 400 ms after the user stops typing.
      context.read<CheckinsBloc>().add(SearchMembers(value.trim()));
    });
  }

  void _onClear() {
    _controller.clear();
    _debounce?.cancel();
    context.read<CheckinsBloc>().add(const LoadTodayCheckins());
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.read<ThemeCubit>().state.tokens;
    final l10n   = AppLocalizations.of(context)!;
    final c      = tokens.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller:  _controller,
        onChanged:   _onChanged,
        style:       TextStyle(color: c.label, fontSize: 14),
        decoration: InputDecoration(
          hintText:  l10n.checkins_searchHint,
          hintStyle: TextStyle(color: c.muted, fontSize: 14),
          prefixIcon: Icon(Icons.search_rounded, color: c.muted, size: 20),
          // Only show the X when there is text.
          suffixIcon: ListenableBuilder(
            listenable: _controller,
            builder: (_, __) => _controller.text.isNotEmpty
                ? IconButton(
              icon:    Icon(Icons.close_rounded, color: c.muted, size: 18),
              onPressed: _onClear,
            )
                : const SizedBox.shrink(),
          ),
          filled:      true,
          fillColor:   c.surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(tokens.search.radius),
            borderSide: BorderSide(color: c.border.withOpacity(0.3), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(tokens.search.radius),
            borderSide: BorderSide(color: c.border.withOpacity(0.3), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(tokens.search.radius),
            borderSide: BorderSide(color: c.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}
