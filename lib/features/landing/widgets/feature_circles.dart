import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class FeatureCircles extends StatelessWidget {
  final void Function(String route) onNavigate;

  const FeatureCircles({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        label: 'Lapor aman',
        icon: Icons.shield_rounded,
        bg: AppColors.peach,
        route: '/register',
      ),
      (
        label: 'Konsultasi',
        icon: Icons.forum_rounded,
        bg: AppColors.mint,
        route: '/login',
      ),
      (
        label: 'Pantau status',
        icon: Icons.track_changes_rounded,
        bg: AppColors.lemon,
        route: '/login',
      ),
      (
        label: 'Riwayat',
        icon: Icons.history_rounded,
        bg: AppColors.pink,
        route: '/login',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Yang bisa kamu lakukan',
          style: AppTextStyles.text(
            18,
            weight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final f in items)
              Expanded(
                child: GestureDetector(
                  onTap: () => onNavigate(f.route),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.6),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.9),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.ink.withValues(alpha: 0.08),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: f.bg,
                          ),
                          child: Icon(f.icon, color: AppColors.ink, size: 25),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        f.label,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.text(
                          11.5,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
