import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils.dart';
import '../../../data/models.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/pill_button.dart';
import 'featured_article.dart';
import 'article_row.dart';

class ArticlesSection extends StatelessWidget {
  final Future<List<Article>> articles;
  final List<String> fallbackCovers;
  final bool showAllArticles;
  final VoidCallback onToggleArticles;
  final ValueChanged<Article> onArticleTap;
  final Key? sectionKey;

  const ArticlesSection({
    super.key,
    required this.articles,
    required this.fallbackCovers,
    required this.showAllArticles,
    required this.onToggleArticles,
    required this.onArticleTap,
    this.sectionKey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: sectionKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bacaan untukmu',
          style: AppTextStyles.text(
            18,
            weight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Kenali tandanya, tahu langkahnya.',
          style: AppTextStyles.text(
            12.5,
            weight: FontWeight.w500,
            color: AppColors.ink.withValues(alpha: 0.64),
          ),
        ),
        const SizedBox(height: 14),
        FutureBuilder<List<Article>>(
          future: articles,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Padding(
                padding: EdgeInsets.all(28),
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              );
            }

            if (snap.hasError) {
              return AppCard(
                padding: const EdgeInsets.all(16),
                child: Text(errMsg(snap.error!)),
              );
            }

            final list = snap.data ?? [];

            if (list.isEmpty) {
              return const AppCard(
                padding: EdgeInsets.all(18),
                child: Text('Belum ada artikel edukasi.'),
              );
            }

            // Artikel pertama dijadikan sorotan utama.
            final featured = list.first;
            final rest = list.skip(1).toList();
            final shown = showAllArticles ? rest : rest.take(3).toList();

            return Column(
              children: [
                FeaturedArticle(
                  article: featured,
                  fallbackImageUrl: fallbackCovers[0],
                  onTap: () => onArticleTap(featured),
                ),
                const SizedBox(height: 12),
                for (int i = 0; i < shown.length; i++) ...[
                  ArticleRow(
                    article: shown[i],
                    fallbackImageUrl:
                        fallbackCovers[(i + 1) % fallbackCovers.length],
                    onTap: () => onArticleTap(shown[i]),
                  ),
                  const SizedBox(height: 10),
                ],
                if (rest.length > 3) ...[
                  const SizedBox(height: 4),
                  PillButton(
                    label: showAllArticles
                        ? 'Tampilkan lebih sedikit'
                        : 'Lihat semua artikel',
                    filled: false,
                    onTap: onToggleArticles,
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}
