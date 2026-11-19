import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils.dart';
import '../../../shared/widgets/app_back_button.dart';
import '../../../shared/widgets/app_status_badge.dart';

class ReportDetailHeader extends StatelessWidget {
  final String kode;
  final String status;
  final String role;

  const ReportDetailHeader({
    super.key,
    required this.kode,
    required this.status,
    required this.role,
  });

  Color _statusColor(String value) {
    switch (value.toLowerCase()) {
      case 'menunggu_ditinjau':
      case 'baru':
        return Colors.orange;
      case 'sedang_ditinjau':
        return Colors.blue;
      case 'dalam_penanganan':
      case 'dialihkan_psikolog':
        return Colors.deepPurple;
      case 'selesai':
        return Colors.green;
      case 'ditolak':
        return Colors.red;
      default:
        return AppColors.primaryDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppBackButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/');
                }
              },
            ),
            const Spacer(),
            Text(
              'DETAIL LAPORAN',
              style: AppTextStyles.text(
                11,
                weight: FontWeight.w800,
                color: AppColors.primaryDark,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          kode,
          style: AppTextStyles.text(
            25,
            weight: FontWeight.w800,
            color: AppColors.ink,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 10),
        AppStatusBadge(
          label: statusLabels[status] ?? status,
          color: _statusColor(status),
        ),
        if (role == 'siswa' && (_hint(status).isNotEmpty)) ...[
          const SizedBox(height: 14),
          Text(
            _hint(status),
            style: AppTextStyles.text(
              13,
              color: AppColors.ink.withValues(alpha: 0.7),
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }

  String _hint(String status) {
    const hints = <String, String>{
      'menunggu_ditinjau':
          'Laporanmu sudah masuk dan menunggu ditinjau oleh guru BK.',
      'sedang_ditinjau': 'Guru BK sedang meninjau laporanmu.',
      'dalam_penanganan':
          'Laporanmu sudah mendapat tindak lanjut dari guru BK.',
      'dialihkan_psikolog':
          'Kamu dialihkan untuk berkonsultasi dengan psikolog.',
      'selesai': 'Penanganan laporanmu telah selesai.',
    };

    return hints[status] ?? '';
  }
}
