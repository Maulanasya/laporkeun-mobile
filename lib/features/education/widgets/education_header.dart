import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'education_glass.dart';

class EduHeader extends StatelessWidget {
  final VoidCallback onBack;

  const EduHeader({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onBack,
          child: Container(
            width: 46,
            height: 46,
            decoration: eduGlass(radius: 23),
            child: const Icon(Icons.arrow_back_rounded, color: AppColors.ink),
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'Edukasi',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
      ],
    );
  }
}