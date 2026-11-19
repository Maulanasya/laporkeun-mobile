import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'education_glass.dart';

class EduHelpCard extends StatelessWidget {
  final VoidCallback onReportTap;

  const EduHelpCard({super.key, required this.onReportTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: eduGlass(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Butuh bicara sekarang?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Kamu bisa melapor secara anonim kapan saja.',
                  style: TextStyle(
                    height: 1.35,
                    color: AppColors.ink.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: 14),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 14,
                    ),
                  ),
                  onPressed: onReportTap,
                  child: const Text('Mulai melapor'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(
            Icons.health_and_safety_rounded,
            size: 64,
            color: AppColors.primaryDark,
          ),
        ],
      ),
    );
  }
}