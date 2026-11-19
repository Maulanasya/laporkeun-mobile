import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class StudentReportActionPanel extends StatelessWidget {
  final bool hasBkSession;
  final bool hasPsychologistSession;
  final VoidCallback? onChatBk;
  final VoidCallback? onChatPsychologist;
  final VoidCallback? onCallPsychologist;

  const StudentReportActionPanel({
    super.key,
    required this.hasBkSession,
    required this.hasPsychologistSession,
    this.onChatBk,
    this.onChatPsychologist,
    this.onCallPsychologist,
  });

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!hasBkSession)
          _informationNote(
            'Ruang konsultasi dengan guru BK akan terbuka setelah '
            'laporanmu mulai ditinjau.',
          )
        else
          _actionButton(
            label: 'Konsultasi dengan Guru BK',
            icon: Icons.chat_bubble_outline_rounded,
            onPressed: onChatBk,
            primary: true,
          ),

        if (hasPsychologistSession) ...[
          const SizedBox(height: 12),
          _actionButton(
            label: 'Ruang Chat Psikolog',
            icon: Icons.psychology_outlined,
            onPressed: onChatPsychologist,
            primary: true,
          ),
          if (onCallPsychologist != null) ...[
            const SizedBox(height: 10),
            _actionButton(
              label: 'Telepon Psikolog',
              icon: Icons.call_outlined,
              onPressed: onCallPsychologist,
            ),
          ],
        ],
      ],
    );
  }
}
