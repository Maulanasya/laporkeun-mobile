import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class LandingFooter extends StatelessWidget {
  const LandingFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        'LaporKeun! · Platform pelaporan perundungan dan pendampingan siswa.',
        textAlign: TextAlign.center,
        style: AppTextStyles.text(
          11,
          weight: FontWeight.w500,
          color: AppColors.ink.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
