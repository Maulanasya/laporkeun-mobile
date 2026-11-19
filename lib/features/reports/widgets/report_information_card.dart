import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils.dart';
import '../../../data/models.dart';
import '../../../shared/widgets/app_glass_card.dart';

class ReportInformationCard extends StatelessWidget {
  final Report report;

  const ReportInformationCard({super.key, required this.report});

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 112,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.ink.withValues(alpha: 0.55),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppGlassCard(
      borderRadius: 22,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow('Kode Laporan', report.kode),
          _infoRow(
            'Kategori',
            kategoriLabels[report.kategori] ?? report.kategori,
          ),
          _infoRow('Pelapor', report.identitas),
          _infoRow('Lokasi', report.lokasi),
          _infoRow('Waktu Kejadian', fmtDate(report.waktuKejadian)),
          _infoRow('Tanggal Dikirim', fmtDate(report.createdAt)),
        ],
      ),
    );
  }
}
