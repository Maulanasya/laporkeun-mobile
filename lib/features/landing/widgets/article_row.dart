import 'package:flutter/material.dart';

import '../../../core/utils.dart';
import '../../../data/models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/app_card.dart';

class ArticleRow extends StatelessWidget {
  final Article article;
  final String fallbackImageUrl;
  final VoidCallback onTap;

  const ArticleRow({
    super.key,
    required this.article,
    required this.fallbackImageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = (article.cover != null && article.cover!.isNotEmpty)
        ? article.cover!
        : fallbackImageUrl;

    return AppCard(
      onTap: onTap,
      radius: 22,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: 76,
              height: 76,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.mint,
                  child: const Icon(
                    Icons.image_outlined,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.judul,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.text(
                    13.5,
                    weight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  fmtDate(article.tanggal),
                  style: AppTextStyles.text(
                    11.5,
                    weight: FontWeight.w500,
                    color: AppColors.ink.withValues(alpha: 0.58),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.ink.withValues(alpha: 0.4),
            size: 22,
          ),
        ],
      ),
    );
  }
}
