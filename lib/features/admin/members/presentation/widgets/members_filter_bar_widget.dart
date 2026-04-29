// =============================================================================
// FILE: members_filter_bar_widget.dart
// LAYER: Presentation Layer → Widgets
// PURPOSE: Horizontal row of 3 equal-width dropdown buttons for filtering:
//           1. Status  → All Status / Active / Inactive / Blocked / Pending
//           2. Sort    → Newest / Oldest / Alphabetical
//           3. Gender  → All Gender / Male / Female / Other
//          Each selection dispatches the matching event to AdminMembersBloc.
//          Active filters get a subtle highlight (accent-colored border).
//
// POSITION IN FLOW:
//   User taps a dropdown → selects an option
//     → BLoC receives MembersStatusFilterChanged / MembersSortChanged / MembersGenderFilterChanged
//     → BLoC reloads with new filter applied (page reset to 1)
//     → MembersLoaded emitted → widget rebuilds with updated highlight
//
// RELATED FILES:
//   → Dispatches events to: admin_members_bloc.dart
//   ← Reads active filters from: MembersLoaded.activeFilters (via BlocBuilder)
//   ← Used in:               admin_members_page.dart (below search bar)
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/admin_members_bloc.dart';

class MembersFilterBarWidget extends StatelessWidget {
  const MembersFilterBarWidget({super.key});

  // ---------------------------------------------------------------------------
  // Dropdown option definitions — label shown in UI + value sent to API.
  // ---------------------------------------------------------------------------

  static const _statusOptions = [
    _DropdownOption(label: 'All Status', value: ''),
    _DropdownOption(label: 'Active', value: 'active'),
    _DropdownOption(label: 'Inactive', value: 'inactive'),
    _DropdownOption(label: 'Blocked', value: 'blocked'),
    _DropdownOption(label: 'Pending', value: 'pending'),
  ];

  static const _sortOptions = [
    _DropdownOption(label: 'Newest', value: 'newest'),
    _DropdownOption(label: 'Oldest', value: 'oldest'),
    _DropdownOption(label: 'Alphabetical', value: 'alphabetical'),
  ];

  static const _genderOptions = [
    _DropdownOption(label: 'All Gender', value: ''),
    _DropdownOption(label: 'Male', value: 'male'),
    _DropdownOption(label: 'Female', value: 'female'),
    _DropdownOption(label: 'Other', value: 'other'),
  ];

  @override
  Widget build(BuildContext context) {
    // BlocBuilder lets us read the active filters to highlight selected options.
    return BlocBuilder<AdminMembersBloc, AdminMembersState>(
      builder: (context, state) {
        // Extract active filters if we have a loaded state; otherwise use defaults.
        final filters = state is MembersLoaded
            ? state.activeFilters
            : const MembersActiveFilters();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              // Status dropdown — 1/3 width each.
              Expanded(
                child: _FilterDropdown(
                  options: _statusOptions,
                  selectedValue: filters.status,
                  isActive: filters.status.isNotEmpty,
                  onSelected: (value) => context.read<AdminMembersBloc>()
                      .add(MembersStatusFilterChanged(value)),
                ),
              ),
              const SizedBox(width: 8),

              // Sort dropdown.
              Expanded(
                child: _FilterDropdown(
                  options: _sortOptions,
                  selectedValue: filters.sort,
                  // Sort is always "active" because there's always a sort selected.
                  isActive: filters.sort != 'newest',
                  onSelected: (value) => context.read<AdminMembersBloc>()
                      .add(MembersSortChanged(value)),
                ),
              ),
              const SizedBox(width: 8),

              // Gender dropdown.
              Expanded(
                child: _FilterDropdown(
                  options: _genderOptions,
                  selectedValue: filters.gender,
                  isActive: filters.gender.isNotEmpty,
                  onSelected: (value) => context.read<AdminMembersBloc>()
                      .add(MembersGenderFilterChanged(value)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// =============================================================================
// Private helper widget: a single rounded dropdown button.
// Made private (_) because it's only used inside this file.
// =============================================================================
class _FilterDropdown extends StatelessWidget {
  final List<_DropdownOption> options;
  final String selectedValue;

  /// When true, the button gets an accent border to signal an active filter.
  final bool isActive;

  final ValueChanged<String> onSelected;

  const _FilterDropdown({
    required this.options,
    required this.selectedValue,
    required this.isActive,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Find the label for the currently selected value.
    final selectedLabel = options
        .firstWhere(
          (o) => o.value == selectedValue,
      orElse: () => options.first,
    )
        .label;

    return GestureDetector(
      onTap: () => _showOptions(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(20),
          // Active filter? Show accent border, otherwise transparent.
          border: Border.all(
            color: isActive
                ? const Color(0xFF6C63FF) // purple accent
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                selectedLabel,
                style: TextStyle(
                  color: isActive ? const Color(0xFF6C63FF) : Colors.grey,
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: isActive ? const Color(0xFF6C63FF) : Colors.grey,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Shows a bottom sheet or popup with the dropdown options.
  // Using showModalBottomSheet for better mobile UX than DropdownButton.
  // ---------------------------------------------------------------------------
  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) {
              final isSelected = option.value == selectedValue;
              return ListTile(
                title: Text(
                  option.label,
                  style: TextStyle(
                    color: isSelected
                        ? const Color(0xFF6C63FF)
                        : Colors.white,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check, color: Color(0xFF6C63FF))
                    : null,
                onTap: () {
                  Navigator.pop(context); // close sheet
                  onSelected(option.value); // dispatch event
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

// =============================================================================
// Simple data class for dropdown options — label displayed, value sent to API.
// =============================================================================
class _DropdownOption {
  final String label;
  final String value;

  const _DropdownOption({required this.label, required this.value});
}