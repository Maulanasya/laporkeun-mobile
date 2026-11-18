import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/glass_container.dart';
import '../painters/phone_toggle_scene_painter.dart';

class AnonymousCard extends StatelessWidget {
  final bool isLoggedIn;
  final VoidCallback onTap;

  const AnonymousCard({
    super.key,
    required this.isLoggedIn,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      radius: 28,
      tint: AppColors.primary.withValues(alpha: 0.26),
      padding: const EdgeInsets.fromLTRB(20, 18, 8, 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Takut ketahuan?',
                  style: AppTextStyles.text(
                    18,
                    weight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Kamu bisa melapor anonim. Namamu tidak ditampilkan kepada guru BK yang meninjau.',
                  style: AppTextStyles.text(
                    12.5,
                    weight: FontWeight.w500,
                    color: AppColors.ink.withValues(alpha: 0.8),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.ink,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.edit_note_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isLoggedIn ? 'Buka dashboard' : 'Mulai melapor',
                          style: AppTextStyles.text(
                            12.5,
                            weight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          const SizedBox(
            width: 108,
            height: 118,
            child: CustomPaint(painter: PhoneToggleScenePainter()),
          ),
        ],
      ),
    );
  }
}
