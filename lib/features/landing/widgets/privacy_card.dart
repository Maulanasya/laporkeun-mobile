import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/glass_container.dart';

class PrivacyCard extends StatelessWidget {
  const PrivacyCard({super.key});

  Widget _privacyPoint(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: AppColors.peach, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.text(
                    13.5,
                    weight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: AppTextStyles.text(
                    12,
                    weight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.74),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      radius: 28,
      tint: AppColors.ink.withValues(alpha: 0.84),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Privasimu dijaga',
            style: AppTextStyles.text(
              18,
              weight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
          _privacyPoint(
            Icons.visibility_off_rounded,
            'Pilihan anonim',
            'Namamu bisa disembunyikan saat melapor.',
          ),
          _privacyPoint(
            Icons.admin_panel_settings_rounded,
            'Akses sesuai peran',
            'Laporan dibuka guru BK, dan psikolog hanya bila kamu dialihkan.',
          ),
          _privacyPoint(
            Icons.folder_special_rounded,
            'Bukti tidak terbuka untuk umum',
            'Foto yang kamu unggah hanya bisa dibuka pihak yang berwenang.',
          ),
        ],
      ),
    );
  }
}
