import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../profile/widgets/profile_decorations.dart';

class AuthBackdrop extends StatelessWidget {
  const AuthBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: AppColors.landingBackground),

        Positioned(
          top: -65,
          right: -65,
          child: ProfileDecorationCircle(
            size: 190,
            color: AppColors.primary.withValues(alpha: 0.13),
          ),
        ),

        Positioned(
          top: 350,
          left: -90,
          child: ProfileDecorationCircle(
            size: 160,
            color: AppColors.mint.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }
}
