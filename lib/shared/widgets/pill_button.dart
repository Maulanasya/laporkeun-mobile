import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class PillButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback onTap;

  const PillButton({
    super.key,
    required this.label,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled
              ? AppColors.primaryDark
              : Colors.white.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: filled
                ? AppColors.primaryDark
                : Colors.white.withValues(alpha: 0.9),
            width: 1.2,
          ),
          boxShadow: filled
              ? [
                  BoxShadow(
                    color: AppColors.primaryDark.withValues(alpha: 0.3),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: filled ? Colors.white : AppColors.ink,
            height: 1.35,
          ),
        ),
      ),
    );
  }
}
