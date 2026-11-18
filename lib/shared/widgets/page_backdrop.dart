import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class PageBackdrop extends StatelessWidget {
  const PageBackdrop({super.key});

  Widget _glow(Alignment center, Color color, double radius) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: center,
            radius: radius,
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
                stops: [0, 0.55, 1],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        _glow(
          const Alignment(1.0, -0.35),
          AppColors.lavender.withValues(alpha: 0.95),
          0.95,
        ),
        _glow(
          const Alignment(-1.0, 0.1),
          const Color(0xFFB9E0E3).withValues(alpha: 0.9),
          0.9,
        ),
        _glow(
          const Alignment(0.9, 0.8),
          AppColors.peach.withValues(alpha: 0.85),
          0.9,
        ),
        _glow(
          const Alignment(-0.8, 1.0),
          AppColors.pink.withValues(alpha: 0.7),
          0.7,
        ),
      ],
    );
  }
}
