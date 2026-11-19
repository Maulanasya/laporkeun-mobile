import 'package:flutter/material.dart';

import '../../../shared/widgets/app_empty_state.dart';

class ReportEmptyState extends StatelessWidget {
  final String message;
  final bool isFiltered;

  const ReportEmptyState({
    super.key,
    required this.message,
    this.isFiltered = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: isFiltered ? Icons.search_off_rounded : Icons.inbox_outlined,
      title: isFiltered ? 'Laporan Tidak Ditemukan' : 'Belum Ada Laporan',
      message: isFiltered
          ? 'Tidak ada laporan yang sesuai dengan pencarian atau filter.'
          : message,
    );
  }
}
