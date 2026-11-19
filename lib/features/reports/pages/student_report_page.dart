import 'package:flutter/material.dart';

import '../../../data/repository.dart';
import '../screens/report_list_screen.dart';

class StudentReportPage extends StatelessWidget {
  const StudentReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ReportListScreen(
      title: 'Riwayat Laporan',
      detailBase: '/siswa/laporan',
      emptyText: 'Belum ada laporan.\nKetuk Buat Laporan untuk memulai.',
      loader: Repo.myReports,
      createRoute: '/siswa/lapor',
    );
  }
}
