import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/app_card.dart';

class FaqSection extends StatelessWidget {
  final Key? sectionKey;

  const FaqSection({super.key, this.sectionKey});

  @override
  Widget build(BuildContext context) {
    const faqs = [
      (
        q: 'Apakah identitas saya aman?',
        a: 'Ya. Kamu dapat memilih opsi Anonim saat mengirim laporan sehingga namamu tidak ditampilkan pada laporan yang ditinjau.',
      ),
      (
        q: 'Siapa yang membaca laporan saya?',
        a: 'Laporan hanya ditinjau oleh Guru BK sekolah. Jika dinilai mengalami trauma tinggi, Guru BK dapat mengalihkan pendampingan ke Psikolog.',
      ),
      (
        q: 'Apa itu kode laporan?',
        a: 'Kode unik yang dibuat otomatis setelah laporan dikirim, dipakai untuk memantau status peninjauan dari Guru BK.',
      ),
      (
        q: 'Bukti apa yang bisa saya lampirkan?',
        a: 'Kamu bisa mengunggah gambar sebagai bukti pendukung, misalnya tangkapan layar pesan. Bukti hanya bisa dibuka oleh pihak yang berwenang menangani laporanmu.',
      ),
    ];

    return Column(
      key: sectionKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pertanyaan yang sering muncul',
          style: AppTextStyles.text(
            18,
            weight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 14),
        for (final item in faqs) ...[
          AppCard(
            radius: 22,
            child: Theme(
              data: Theme.of(context)
                  .copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                shape: const Border(),
                collapsedShape: const Border(),
                backgroundColor: Colors.transparent,
                collapsedBackgroundColor: Colors.transparent,
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 2,
                ),
                childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                iconColor: AppColors.primaryDark,
                collapsedIconColor: AppColors.ink,
                title: Text(
                  item.q,
                  style: AppTextStyles.text(13.5, weight: FontWeight.w700),
                ),
                children: [
                  Text(
                    item.a,
                    style: AppTextStyles.text(
                      12.5,
                      weight: FontWeight.w500,
                      color: AppColors.ink.withValues(alpha: 0.8),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
