import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../landing/widgets/mascot.dart';

class AuthMascot extends StatelessWidget {
  final double size;

  const AuthMascot({super.key, this.size = 92});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size + 22,
        height: size + 22,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.55),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.9),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Center(child: Mascot(size: size * 0.78)),
      ),
    );
  }
}
