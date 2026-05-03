// ─────────────────────────────────────────────────────────────────────────────
// FILE: lib/features/admin/staff/presentation/widgets/staff_search_bar_widget.dart
//
// MATCHES FIGMA: hint text "Search staff by name", grey background, no border.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/admin_staff_bloc.dart';
import '../bloc/admin_staff_event.dart';

class StaffSearchBarWidget extends StatefulWidget {
  const StaffSearchBarWidget({super.key});

  @override
  State<StaffSearchBarWidget> createState() => _StaffSearchBarWidgetState();
}

class _StaffSearchBarWidgetState extends State<StaffSearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      context.read<AdminStaffBloc>().add(StaffSearchChanged(value));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: TextField(
        controller: _controller,
        onChanged: _onChanged,
        style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
        decoration: InputDecoration(
          hintText: 'Search staff by name',
          hintStyle:
          const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
          prefixIcon:
          const Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
            const BorderSide(color: Color(0xFF2563EB), width: 1.5),
          ),
        ),
      ),
    );
  }
}