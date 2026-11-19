import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/repository.dart';
import '../screens/report_list_screen.dart';

class BkReportPage extends StatelessWidget {
  const BkReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ReportListScreen(
      title: 'Laporan Masuk',
      detailBase: '/bk/laporan',
      emptyText: 'Belum ada laporan masuk.',
      loader: Repo.staffReports,
      extraActions: [
        IconButton(
          tooltip: 'Kelola Artikel',
          icon: const Icon(Icons.article_outlined, color: AppColors.ink),
          onPressed: () => context.push('/bk/artikel'),
        ),
      ],
    );
  }
}
