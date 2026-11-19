import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils.dart';
import '../../../data/models.dart';
import '../../../shared/widgets/app_glass_card.dart';

class ReportHistorySection extends StatelessWidget {
  final List<HistoryItem> history;

  const ReportHistorySection({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return AppGlassCard(
        borderRadius: 22,
        padding: const EdgeInsets.all(18),
        child: Text(
          'Belum ada riwayat penanganan.',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.ink.withValues(alpha: 0.6),
          ),
        ),
      );
    }

    return AppGlassCard(
      borderRadius: 22,
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          for (int i = 0; i < history.length; i++)
            Padding(
              padding: EdgeInsets.only(
                bottom: i == history.length - 1 ? 0 : 16,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(
                      Icons.circle,
                      size: 10,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          statusLabels[history[i].statusBaru] ??
                              history[i].statusBaru,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          fmtDate(history[i].createdAt),
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.ink.withValues(alpha: 0.55),
                          ),
                        ),
                        if ((history[i].catatan ?? '').isNotEmpty) ...[
                          const SizedBox(height: 5),
                          Text(
                            history[i].catatan!,
                            style: const TextStyle(
                              fontSize: 12,
                              height: 1.5,
                              color: AppColors.ink,
                            ),
                          ),
                        ],
                      ],
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
