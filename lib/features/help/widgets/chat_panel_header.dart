import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ChatPanelHeader extends StatelessWidget {
  final VoidCallback onReset;

  const ChatPanelHeader({super.key, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.peach.withValues(alpha: 0.6),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Asisten LaporKeun',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF3FBF7F),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'AI \u2022 siap membantu',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppColors.ink.withValues(alpha: 0.65),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: AppColors.ink),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onSelected: (v) {
              if (v == 'reset') onReset();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'reset', child: Text('Percakapan baru')),
            ],
          ),
        ],
      ),
    );
  }
}