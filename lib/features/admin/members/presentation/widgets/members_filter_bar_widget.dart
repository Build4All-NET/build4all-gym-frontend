import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../l10n/app_localizations.dart';
import '../bloc/admin_members_bloc.dart';

class MembersFilterBarWidget extends StatelessWidget {
  const MembersFilterBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final statusOptions = [
      _DropdownOption(label: l10n.admin_members_filterAllStatus, value: ''),
      _DropdownOption(label: l10n.membershipStatusActive,        value: 'active'),
      _DropdownOption(label: l10n.membershipStatusInactive,      value: 'inactive'),
      _DropdownOption(label: l10n.membershipStatusBlocked,       value: 'blocked'),
      _DropdownOption(label: l10n.membershipStatusPending,       value: 'pending'),
    ];
    final sortOptions = [
      _DropdownOption(label: l10n.admin_members_sortNewest, value: 'newest'),
      _DropdownOption(label: l10n.admin_members_sortOldest, value: 'oldest'),
      _DropdownOption(label: l10n.admin_members_sortAlpha,  value: 'name_asc'),
    ];
    final genderOptions = [
      _DropdownOption(label: l10n.admin_members_filterAllGender, value: ''),
      _DropdownOption(label: l10n.genderMale,   value: 'male'),
      _DropdownOption(label: l10n.genderFemale, value: 'female'),
      _DropdownOption(label: l10n.genderOther,  value: 'other'),
    ];

    return BlocBuilder<AdminMembersBloc, AdminMembersState>(
      builder: (context, state) {
        final filters = state is MembersLoaded
            ? state.activeFilters
            : const MembersActiveFilters();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: _FilterDropdown(
                  options:       statusOptions,
                  selectedValue: filters.status,
                  isActive:      filters.status.isNotEmpty,
                  onSelected:    (v) => context.read<AdminMembersBloc>()
                      .add(MembersStatusFilterChanged(v)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _FilterDropdown(
                  options:       sortOptions,
                  selectedValue: filters.sort,
                  isActive:      filters.sort != 'newest',
                  onSelected:    (v) => context.read<AdminMembersBloc>()
                      .add(MembersSortChanged(v)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _FilterDropdown(
                  options:       genderOptions,
                  selectedValue: filters.gender,
                  isActive:      filters.gender.isNotEmpty,
                  onSelected:    (v) => context.read<AdminMembersBloc>()
                      .add(MembersGenderFilterChanged(v)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final List<_DropdownOption> options;
  final String selectedValue;
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
    final cs = Theme.of(context).colorScheme;

    final selectedLabel = options
        .firstWhere((o) => o.value == selectedValue, orElse: () => options.first)
        .label;

    return GestureDetector(
      onTap: () => _showOptions(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color:        cs.surfaceVariant, // ← theme
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? cs.primary : Colors.transparent, // ← theme
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
                  color:      isActive ? cs.primary : cs.onSurface.withOpacity(0.5),
                  fontSize:   11,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: isActive ? cs.primary : cs.onSurface.withOpacity(0.5),
              size:  14,
            ),
          ],
        ),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: cs.surface, // ← theme
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
                    color:      isSelected ? cs.primary : cs.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check, color: cs.primary)
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  onSelected(option.value);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _DropdownOption {
  final String label;
  final String value;
  const _DropdownOption({required this.label, required this.value});
}