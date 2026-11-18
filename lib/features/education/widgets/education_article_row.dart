import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'education_glass.dart';

class EduArticleRow extends StatelessWidget {
  final String title;
  final String coverUrl;
  final VoidCallback onTap;

  const EduArticleRow({
    super.key,
    required this.title,
    required this.coverUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: eduGlass(),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(
                coverUrl,
                width: 88,
                height: 88,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 88,
                  height: 88,
                  color: AppColors.peach.withValues(alpha: 0.4),
                  child: const Icon(Icons.menu_book_rounded),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15.5,
                  height: 1.25,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.ink.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}