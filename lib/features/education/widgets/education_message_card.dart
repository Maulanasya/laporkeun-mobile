import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'education_glass.dart';

class EduMessageCard extends StatelessWidget {
  final String title;
  final String body;

  const EduMessageCard({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: eduGlass(),
      child: Column(
        children: [
          const Icon(Icons.menu_book_rounded, size: 34, color: AppColors.ink),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(body, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}