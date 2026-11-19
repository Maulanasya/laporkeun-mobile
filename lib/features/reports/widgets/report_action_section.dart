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

  Widget _actionButton({
    required String label,
    required IconData icon,
    required VoidCallback? onPressed,
    bool primary = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: primary
          ? FilledButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 19),
              label: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.primaryDark.withValues(
                  alpha: 0.4,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
            )
          : OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 19),
              label: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryDark,
                side: BorderSide(
                  color: AppColors.primaryDark.withValues(alpha: 0.25),
                ),
                backgroundColor: Colors.white.withValues(alpha: 0.35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
    );
  }

  Widget _fieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon == null ? null : Icon(icon, size: 19),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.65),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      hintStyle: TextStyle(
        fontSize: 13,
        color: AppColors.ink.withValues(alpha: 0.4),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.ink.withValues(alpha: 0.08)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.ink.withValues(alpha: 0.10)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
      ),
    );
  }

  Widget _informationNote(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primaryDark,
            size: 19,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: AppColors.ink.withValues(alpha: 0.75),
              ),
            ),
          ),
        ],
      ),
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
