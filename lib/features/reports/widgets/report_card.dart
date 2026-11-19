import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils.dart';
import '../../../data/models.dart';
import '../../../shared/widgets/app_glass_card.dart';
import '../../../shared/widgets/app_status_badge.dart';

class ReportCard extends StatelessWidget {
  final Report report;
  final VoidCallback onTap;

  const ReportCard({super.key, required this.report, required this.onTap});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'baru':
      case 'menunggu':
      case 'pending':
        return Colors.orange;

      case 'diproses':
      case 'proses':
        return Colors.blue;

      case 'selesai':
      case 'diterima':
        return Colors.green;

      case 'ditolak':
      case 'dibatalkan':
        return Colors.red;

      default:
        return AppColors.primaryDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: AppGlassCard(
        padding: EdgeInsets.zero,
        borderRadius: 24,
        blur: 14,
        backgroundColor: const Color(0x8CFFFFFF),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            splashColor: AppColors.primary.withValues(alpha: 0.08),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: AppColors.mint.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.description_outlined,
                          color: AppColors.primaryDark,
                          size: 23,
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              report.kode,
                              style: const TextStyle(
                                color: AppColors.ink,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              kategoriLabels[report.kategori] ??
                                  report.kategori,
                              style: TextStyle(
                                color: AppColors.ink.withValues(alpha: 0.65),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.primaryDark,
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(height: 1, color: Color(0x1A023346)),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline_rounded,
                        size: 17,
                        color: AppColors.primaryDark,
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          report.identitas,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.ink,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: AppColors.primaryDark,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        fmtDate(report.createdAt),
                        style: TextStyle(
                          color: AppColors.ink.withValues(alpha: 0.65),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  AppStatusBadge(
                    label: statusLabels[report.status] ?? report.status,
                    color: _statusColor(report.status),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
