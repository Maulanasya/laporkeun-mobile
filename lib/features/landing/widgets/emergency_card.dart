import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/glass_container.dart';

class EmergencyCard extends StatelessWidget {
  const EmergencyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      radius: 24,
      tint: AppColors.danger.withValues(alpha: 0.1),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: const Icon(
              Icons.emergency_rounded,
              color: AppColors.danger,
              size: 19,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dalam bahaya sekarang?',
                  style: AppTextStyles.text(14, weight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  'Jangan tunggu laporan ditinjau. Segera hubungi orang dewasa yang kamu percaya atau layanan darurat 112.',
                  style: AppTextStyles.text(
                    12.5,
                    weight: FontWeight.w500,
                    color: AppColors.ink.withValues(alpha: 0.82),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
