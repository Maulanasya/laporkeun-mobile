import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models.dart';
import 'education_article_row.dart';
import 'education_featured_card.dart';
import 'education_message_card.dart';

class EduArticleList extends StatelessWidget {
  final Future<List<Article>> articles;
  final String query;
  final List<String> fallbackCovers;
  final ValueChanged<Article> onArticleTap;

  const EduArticleList({
    super.key,
    required this.articles,
    required this.query,
    required this.fallbackCovers,
    required this.onArticleTap,
  });

  String _cover(int i) => fallbackCovers[i % fallbackCovers.length];

  String _titleOf(Article a) => a.judul;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Article>>(
      future: articles,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 60),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.hasError) {
          return const EduMessageCard(
            title: 'Artikel belum bisa dimuat',
            body: 'Periksa koneksi lalu tarik layar ke bawah untuk mencoba lagi.',
          );
        }

        final q = query.toLowerCase();
        final items = (snap.data ?? [])
            .where((a) => _titleOf(a).toLowerCase().contains(q))
            .toList();

        if (items.isEmpty) {
          return const EduMessageCard(
            title: 'Tidak ada artikel',
            body: 'Coba kata kunci lain.',
          );
        }

        final showFeatured = q.isEmpty;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showFeatured) ...[
              EduFeaturedCard(
                title: _titleOf(items.first),
                coverUrl: _cover(0),
                onTap: () => onArticleTap(items.first),
              ),
              const SizedBox(height: 22),
              const Text(
                'Artikel terbaru',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 12),
            ],
            for (var i = showFeatured ? 1 : 0; i < items.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: EduArticleRow(
                  title: _titleOf(items[i]),
                  coverUrl: _cover(i),
                  onTap: () => onArticleTap(items[i]),
                ),
              ),
          ],
        );
      },
    );
  }
}