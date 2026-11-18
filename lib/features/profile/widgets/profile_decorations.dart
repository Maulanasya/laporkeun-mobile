import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ProfileGlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const ProfileGlassIconButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.65),
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: SizedBox(
          width: 43,
          height: 43,
          child: Icon(icon, color: AppColors.ink, size: 21),
        ),
      ),
    );
  }
}

class ProfileDecorationCircle extends StatelessWidget {
  final double size;
  final Color color;

  const ProfileDecorationCircle({
    super.key,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
