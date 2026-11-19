import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color iconColor;

  const AppBackButton({
    super.key,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.iconColor = AppColors.ink,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor.withValues(alpha: 0.85),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(Icons.arrow_back_rounded, color: iconColor, size: 21),
        ),
      ),
    );
  }
}
