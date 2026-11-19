import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class HelpTitle extends StatelessWidget {
  const HelpTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ruang Bantuan',
          style: TextStyle(
            fontSize: 30,
            height: 1.1,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Ngobrol dengan asisten AI. Jangan bagikan data pribadi, ya.',
          style: TextStyle(
            fontSize: 13.5,
            height: 1.35,
            color: AppColors.ink.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}