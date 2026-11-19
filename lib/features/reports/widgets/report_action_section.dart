import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_glass_card.dart';
import 'bk_report_action_panel.dart';
import 'student_report_action_panel.dart';
import 'psychologist_report_action_panel.dart';

class ReportActionSection extends StatelessWidget {
  final String role;
  final bool hasBkSession;
  final bool hasPsychologistSession;
  final List<String> statusOptions;
  final String? selectedStatus;
  final ValueChanged<String?> onStatusChanged;
  final TextEditingController noteController;
  final VoidCallback onUpdateStatus;
  final VoidCallback onRefer;
  final VoidCallback? onChatBk;
  final VoidCallback? onChatPsychologist;
  final VoidCallback? onCallPsychologist;

  const ReportActionSection({
    super.key,
    required this.role,
    required this.hasBkSession,
    required this.hasPsychologistSession,
    required this.statusOptions,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.noteController,
    required this.onUpdateStatus,
    required this.onRefer,
    this.onChatBk,
    this.onChatPsychologist,
    this.onCallPsychologist,
  });

  Widget _sectionHeading({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppColors.primaryDark, size: 21),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: AppColors.ink.withValues(alpha: 0.65),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isStudent = role == 'siswa';
    final isBk = role == 'guru_bk';

    return AppGlassCard(
      borderRadius: 22,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeading(
            icon: isStudent
                ? Icons.forum_outlined
                : isBk
                ? Icons.assignment_turned_in_outlined
                : Icons.psychology_outlined,
            title: isStudent
                ? 'Konsultasi'
                : isBk
                ? 'Tindak Lanjut'
                : 'Pendampingan',
            subtitle: isStudent
                ? 'Hubungi pihak yang mendampingi laporanmu.'
                : isBk
                ? 'Kelola perkembangan dan tindak lanjut laporan.'
                : 'Lanjutkan pendampingan siswa melalui ruang konsultasi.',
          ),

          const SizedBox(height: 20),
          Divider(height: 1, color: AppColors.ink.withValues(alpha: 0.08)),
          const SizedBox(height: 18),

          if (isStudent) ...[
            StudentReportActionPanel(
              hasBkSession: hasBkSession,
              hasPsychologistSession: hasPsychologistSession,
              onChatBk: onChatBk,
              onChatPsychologist: onChatPsychologist,
              onCallPsychologist: onCallPsychologist,
            ),
          ] else if (isBk) ...[
            BkReportActionPanel(
              hasBkSession: hasBkSession,
              hasPsychologistSession: hasPsychologistSession,
              statusOptions: statusOptions,
              selectedStatus: selectedStatus,
              onStatusChanged: onStatusChanged,
              noteController: noteController,
              onUpdateStatus: onUpdateStatus,
              onRefer: onRefer,
              onChatBk: onChatBk,
              onChatPsychologist: onChatPsychologist,
            ),
          ] else ...[
            PsychologistReportActionPanel(
              hasPsychologistSession: hasPsychologistSession,
              onChatPsychologist: onChatPsychologist,
            ),
          ],
        ],
      ),
    );
  }
}
