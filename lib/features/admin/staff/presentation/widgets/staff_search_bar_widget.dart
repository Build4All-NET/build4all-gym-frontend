// lib/features/admin/staff/presentation/widgets/staff_search_bar_widget.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/theme_cubit.dart';
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
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: TextField(
        controller: _controller,
        onChanged: _onChanged,
        style: TextStyle(fontSize: 14, color: c.label),
        decoration: InputDecoration(
          hintText: 'Search staff by name',
          hintStyle: TextStyle(color: c.muted, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: c.muted, size: 20),
          filled: true,
          fillColor: c.surface,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: c.border.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: c.border.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: c.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: c.error),
          ),
        ),
      ),
    );
  }
}