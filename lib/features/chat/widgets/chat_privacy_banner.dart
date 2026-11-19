import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ChatPrivacyBanner extends StatelessWidget {
  const ChatPrivacyBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.mint.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lock_outline_rounded,
            size: 18,
            color: AppColors.primaryDark,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Percakapan ini bersifat rahasia dan hanya dapat dibaca oleh peserta sesi.',
              style: TextStyle(
                fontSize: 11.5,
                height: 1.45,
                color: AppColors.ink.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
