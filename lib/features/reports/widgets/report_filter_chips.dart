import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils.dart';

class ReportFilterChips extends StatelessWidget {
  final String? selectedFilter;
  final ValueChanged<String?> onChanged;

  const ReportFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildChip(label: 'Semua', value: null),
          ...statusLabels.entries.map(
            (entry) => _buildChip(label: entry.value, value: entry.key),
          ),
        ],
      ),
    );
  }

  Widget _buildChip({required String label, required String? value}) {
    final selected = selectedFilter == value;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onChanged(value),
        showCheckmark: false,
        selectedColor: AppColors.primary,
        backgroundColor: Colors.white.withValues(alpha: 0.65),
        side: BorderSide(
          color: selected
              ? AppColors.primary
              : Colors.white.withValues(alpha: 0.9),
        ),
        labelStyle: TextStyle(
          color: selected ? Colors.white : AppColors.ink,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
