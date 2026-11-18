import 'package:flutter/material.dart';

import '../../../core/utils.dart';
import '../../../data/models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/app_card.dart';

class FeaturedArticle extends StatelessWidget {
  final Article article;
  final String fallbackImageUrl;
  final VoidCallback onTap;

  const FeaturedArticle({
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
      radius: 28,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.mint,
                  child: const Center(
                    child: Icon(Icons.image_outlined, color: AppColors.primary),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fmtDate(article.tanggal),
                  style: AppTextStyles.text(
                    11.5,
                    weight: FontWeight.w700,
                    color: AppColors.primaryDark,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  article.judul,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.text(
                    17,
                    weight: FontWeight.w800,
                    height: 1.25,
                    letterSpacing: -0.3,
                  ),
                ),
                if (article.ringkasan != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    article.ringkasan!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.text(
                      12.5,
                      weight: FontWeight.w500,
                      color: AppColors.ink.withValues(alpha: 0.72),
                      height: 1.45,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Text(
                  'Baca selengkapnya →',
                  style: AppTextStyles.text(
                    12.5,
                    weight: FontWeight.w800,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
