// =============================================================================
// FILE: members_search_bar_widget.dart
// LAYER: Presentation Layer → Widgets
// PURPOSE: Full-width rounded search bar that:
//           1. Shows a search icon and placeholder text.
//           2. Debounces user input by 300ms before dispatching an event,
//              so the API is NOT called on every single keystroke.
//           3. Dispatches MembersSearchChanged to AdminMembersBloc.
//
// POSITION IN FLOW:
//   User types in search field
//     → _debounceTimer fires after 300ms silence
//     → BlocProvider.of<AdminMembersBloc>(context)
//           .add(MembersSearchChanged(query))
//     → BLoC reloads member list with the new search
//
// RELATED FILES:
//   → Dispatches event to: admin_members_bloc.dart  (MembersSearchChanged)
//   ← Used in:             admin_members_page.dart  (placed below top bar)
// =============================================================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/admin_members_bloc.dart';

class MembersSearchBarWidget extends StatefulWidget {
  const MembersSearchBarWidget({super.key});

  @override
  State<MembersSearchBarWidget> createState() => _MembersSearchBarWidgetState();
}

class _MembersSearchBarWidgetState extends State<MembersSearchBarWidget> {
  final TextEditingController _controller = TextEditingController();

  /// The debounce timer. Cancelled and restarted on every keystroke.
  Timer? _debounceTimer;

  /// How long to wait after the user stops typing before calling the API.
  static const _debounceDuration = Duration(milliseconds: 300);

  @override
  void dispose() {
    // Always cancel the timer and dispose the controller to prevent memory leaks.
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Called on every keystroke. Resets the 300ms timer each time.
  // Only when the user stops typing for 300ms does the event get dispatched.
  // ---------------------------------------------------------------------------
  void _onTextChanged(String value) {
    // Cancel any existing pending timer (user is still typing).
    _debounceTimer?.cancel();

    // Start a fresh timer. If the user types again before 300ms, this
    // will be cancelled and restarted — no event dispatched yet.
    _debounceTimer = Timer(_debounceDuration, () {
      // 300ms of silence — safe to search now.
      context.read<AdminMembersBloc>().add(MembersSearchChanged(value.trim()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Horizontal padding so the bar has breathing room from screen edges.
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _controller,
        onChanged: _onTextChanged,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          // Magnifying glass icon on the left.
          prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),

          // Placeholder text — replace with AppLocalizations when wired up.
          // e.g. hintText: AppLocalizations.of(context)!.searchByNameAgePlan
          hintText: 'Search by Name, Age, Plan type',
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),

          // Dark rounded background matching the design screenshots.
          filled: true,
          fillColor: const Color(0xFF2A2A2A),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),

          // Rounded border — no hard corners.
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none, // no visible border line
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            // Subtle accent border when focused.
            borderSide: const BorderSide(color: Color(0xFF444444), width: 1),
          ),
        ),
      ),
    );
  }
}