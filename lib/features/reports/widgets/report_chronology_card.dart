import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_glass_card.dart';

class ReportChronologyCard extends StatelessWidget {
  final String chronology;

  const ReportChronologyCard({super.key, required this.chronology});

  @override
  Widget build(BuildContext context) {
    return AppGlassCard(
      borderRadius: 22,
      padding: const EdgeInsets.all(18),
      child: SelectableText(
        chronology,
        style: const TextStyle(fontSize: 13, height: 1.7, color: AppColors.ink),
      ),
    );
  }
}
