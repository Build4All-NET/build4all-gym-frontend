import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/admin_members_bloc.dart';
import '../../../../../l10n/app_localizations.dart';

class MembersSearchBarWidget extends StatefulWidget {
  const MembersSearchBarWidget({super.key});

  @override
  State<MembersSearchBarWidget> createState() => _MembersSearchBarWidgetState();
}

class _MembersSearchBarWidgetState extends State<MembersSearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounceTimer;
  static const _debounceDuration = Duration(milliseconds: 300);

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDuration, () {
      context.read<AdminMembersBloc>().add(MembersSearchChanged(value.trim()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _controller,
        onChanged:  _onTextChanged,
        style: TextStyle(color: cs.onSurface, fontSize: 14),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: cs.onSurface.withOpacity(0.4), size: 20),
          hintText:  AppLocalizations.of(context)!.admin_members_searchHint,
          hintStyle: TextStyle(color: cs.onSurface.withOpacity(0.4), fontSize: 14),
          filled:    true,
          fillColor: cs.surfaceVariant, // ← theme
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide:   BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide:   BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide:   BorderSide(color: cs.outline, width: 1), // ← theme
          ),
        ),
      ),
    );
  }
}