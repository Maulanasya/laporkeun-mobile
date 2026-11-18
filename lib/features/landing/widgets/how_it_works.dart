import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/app_card.dart';

class HowItWorks extends StatelessWidget {
  const HowItWorks({super.key});

  @override
  Widget build(BuildContext context) {
    const steps = [
      (
        num: '1',
        title: 'Ceritakan semampumu',
        desc: 'Pilih kategori, lalu isi lokasi, waktu, dan kronologi. Foto bukti boleh ditambahkan jika ada.',
      ),
      (
        num: '2',
        title: 'Simpan kode laporan',
        desc: 'Kode unik muncul setelah laporan terkirim. Pakai untuk memantau statusnya.',
      ),
      (
        num: '3',
        title: 'Ditinjau guru BK',
        desc: 'Status awalnya “Menunggu Ditinjau”. Perubahannya bisa kamu lihat kapan saja.',
      ),
      (
        num: '4',
        title: 'Didampingi',
        desc: 'Guru BK mengajakmu berkonsultasi. Jika perlu, kamu dialihkan ke psikolog.',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cara kerjanya',
          style: AppTextStyles.text(
            18,
            weight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Empat langkah, tanpa ribet.',
          style: AppTextStyles.text(
            12.5,
            weight: FontWeight.w500,
            color: AppColors.ink.withValues(alpha: 0.64),
          ),
        ),
        const SizedBox(height: 14),
        AppCard(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
          child: Column(
            children: [
              for (int i = 0; i < steps.length; i++)
                // IntrinsicHeight keeps the connector line aligned with the text height.
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        width: 34,
                        child: Column(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.lavender.withValues(
                                  alpha: 0.9,
                                ),
                              ),
                              child: Text(
                                steps[i].num,
                                style: AppTextStyles.text(
                                  13.5,
                                  weight: FontWeight.w800,
                                ),
                              ),
                            ),
                            if (i != steps.length - 1)
                              Expanded(
                                child: Center(
                                  child: Container(
                                    width: 1.6,
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    color: AppColors.primary.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 5,
                            bottom: i == steps.length - 1 ? 0 : 18,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                steps[i].title,
                                style: AppTextStyles.text(
                                  14,
                                  weight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                steps[i].desc,
                                style: AppTextStyles.text(
                                  12.5,
                                  weight: FontWeight.w500,
                                  color: AppColors.ink.withValues(alpha: 0.72),
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
