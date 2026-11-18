import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/pill_button.dart';

class CtaSection extends StatelessWidget {
  final bool isLoggedIn;
  final VoidCallback onRegisterTap;
  final VoidCallback onLoginTap;

  const CtaSection({
    super.key,
    required this.isLoggedIn,
    required this.onRegisterTap,
    required this.onLoginTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      radius: 28,
      tint: AppColors.peach.withValues(alpha: 0.6),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kamu tidak sendirian.',
            style: AppTextStyles.text(
              21,
              weight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tidak harus sekarang, tidak harus semuanya. Mulai dari satu cerita, guru BK siap mendengarkan.',
            style: AppTextStyles.text(
              13,
              weight: FontWeight.w500,
              color: AppColors.ink.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          PillButton(
            label: isLoggedIn ? 'Buka dashboard' : 'Buat laporan',
            filled: true,
            onTap: onRegisterTap,
          ),
          if (!isLoggedIn) ...[
            const SizedBox(height: 12),
            Center(
              child: GestureDetector(
                onTap: onLoginTap,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Sudah punya akun? ',
                        style: AppTextStyles.text(
                          12.5,
                          weight: FontWeight.w500,
                          color: AppColors.ink.withValues(alpha: 0.7),
                        ),
                      ),
                      TextSpan(
                        text: 'Masuk',
                        style: AppTextStyles.text(
                          12.5,
                          weight: FontWeight.w800,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
