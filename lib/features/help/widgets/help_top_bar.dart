import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class HelpTopBar extends StatelessWidget {
  final String logoAssetPath;

  const HelpTopBar({super.key, this.logoAssetPath = 'assets/images/logo.png'});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Image.asset(
            logoAssetPath,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.shield_rounded, color: AppColors.primaryDark),
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'LaporKeun!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
      ],
    );
  }
}