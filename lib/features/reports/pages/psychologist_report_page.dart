import 'package:flutter/material.dart';

import '../../../data/repository.dart';
import '../screens/report_list_screen.dart';

class PsychologistReportPage extends StatelessWidget {
  const PsychologistReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ReportListScreen(
      title: 'Siswa Dialihkan',
      detailBase: '/psikolog/laporan',
      emptyText: 'Belum ada siswa yang dialihkan kepada Anda.',
      loader: Repo.staffReports,
    );
  }
}
