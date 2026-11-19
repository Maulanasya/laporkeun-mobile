import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: ColoredBox(color: AppColors.landingBackground),
        ),

        // Dekorasi lingkaran kanan atas
        Positioned(
          top: -65,
          right: -65,
          child: _BackgroundCircle(
            size: 190,
            color: AppColors.primary.withValues(alpha: 0.13),
          ),
        ),

        // Dekorasi lingkaran kiri tengah
        Positioned(
          top: 350,
          left: -90,
          child: _BackgroundCircle(
            size: 160,
            color: AppColors.mint.withValues(alpha: 0.4),
          ),
        ),

        // Konten halaman
        child,
      ],
    );
  }
}

class _BackgroundCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _BackgroundCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
