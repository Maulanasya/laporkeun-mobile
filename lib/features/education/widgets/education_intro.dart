import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class EduIntro extends StatelessWidget {
  const EduIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Belajar kenali,\ncegah, dan hadapi.',
          style: TextStyle(
            fontSize: 30,
            height: 1.15,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Bacaan singkat tentang bullying, kekerasan, dan cara mendapat bantuan.',
          style: TextStyle(
            fontSize: 14,
            height: 1.4,
            color: AppColors.ink.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}