import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class SearchHint extends StatelessWidget {
  const SearchHint({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
      child: Row(
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: 14,
            color: AppColors.ink.withValues(alpha: 0.55),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'Kode muncul otomatis setelah laporanmu terkirim.',
              style: AppTextStyles.text(
                12,
                weight: FontWeight.w500,
                color: AppColors.ink.withValues(alpha: 0.62),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
