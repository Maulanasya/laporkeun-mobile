import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class AuthBackdrop extends StatelessWidget {
  const AuthBackdrop({super.key});

  Widget _glow(Alignment center, Color color) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: center,
            radius: 0.9,
            colors: [color, color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFEFECFA),
                  Color(0xFFE3EFF3),
                  Color(0xFFFBEEE4),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        _glow(Alignment.topRight, AppColors.lavender.withValues(alpha: 0.8)),
        _glow(Alignment.centerLeft, AppColors.mint.withValues(alpha: 0.65)),
        _glow(Alignment.bottomRight, AppColors.peach.withValues(alpha: 0.75)),
        _glow(Alignment.bottomLeft, AppColors.pink.withValues(alpha: 0.55)),
      ],
    );
  }
}
