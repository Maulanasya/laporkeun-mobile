import 'package:flutter/material.dart';

import '../../../core/utils.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models.dart';
import '../../../data/repository.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/page_backdrop.dart';

class ArticleDetailScreen extends StatelessWidget {
  final String id;

  const ArticleDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFECFA),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.ink),
        title: Text(
          'Artikel Edukasi',
          style: AppTextStyles.text(17, weight: FontWeight.w800),
        ),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: PageBackdrop()),
          SafeArea(
            child: FutureBuilder<Article>(
              future: Repo.articleById(id),
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (snap.hasError) {
                  return Center(child: Text(errMsg(snap.error!)));
                }

                final a = snap.data!;

                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                  children: [
                    AppCard(
                      radius: 28,
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (a.cover != null && a.cover!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  a.cover!,
                                  errorBuilder: (_, __, ___) =>
                                      const SizedBox.shrink(),
                                ),
                              ),
                            ),
                          Text(
                            a.judul,
                            style: AppTextStyles.text(
                              22,
                              weight: FontWeight.w800,
                              height: 1.25,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            fmtDate(a.tanggal),
                            style: AppTextStyles.text(
                              12.5,
                              color: AppColors.ink.withValues(alpha: 0.62),
                            ),
                          ),
                          if (a.ringkasan != null) ...[
                            const SizedBox(height: 14),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.mint.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Text(
                                a.ringkasan!,
                                style: AppTextStyles.text(13.5, height: 1.45),
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          Divider(color: AppColors.ink.withValues(alpha: 0.1)),
                          const SizedBox(height: 10),
                          SelectableText(
                            a.isi,
                            style: AppTextStyles.text(
                              14.5,
                              weight: FontWeight.w500,
                              height: 1.7,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
