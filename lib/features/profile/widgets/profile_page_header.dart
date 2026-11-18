import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'profile_decorations.dart';

class ProfilePageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onBack;

  const ProfilePageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ProfileGlassIconButton(
              icon: Icons.arrow_back_rounded,
              onTap: onBack,
            ),
          ],
        ),
        const SizedBox(height: 28),
        Text(
          'PENGATURAN AKUN',
          style: AppTextStyles.text(
            11,
            weight: FontWeight.w800,
            color: AppColors.primaryDark,
            letterSpacing: 1.8,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          title,
          style: AppTextStyles.text(
            27,
            weight: FontWeight.w800,
            color: AppColors.ink,
            letterSpacing: -0.7,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          subtitle,
          style: AppTextStyles.text(
            13,
            color: AppColors.ink.withValues(alpha: 0.65),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
