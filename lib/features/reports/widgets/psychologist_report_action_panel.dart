import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class PsychologistReportActionPanel extends StatelessWidget {
  final bool hasPsychologistSession;
  final VoidCallback? onChatPsychologist;

  const PsychologistReportActionPanel({
    super.key,
    required this.hasPsychologistSession,
    this.onChatPsychologist,
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

  Widget _chatButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton.icon(
        onPressed: onChatPsychologist,
        icon: const Icon(Icons.chat_bubble_outline_rounded, size: 19),
        label: const Text(
          'Buka Ruang Chat',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (hasPsychologistSession) {
      return _chatButton();
    }

    return _informationNote(
      'Ruang konsultasi akan tersedia setelah siswa dialihkan kepada Anda.',
    );
  }
}
