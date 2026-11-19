import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';

class ChatMessageBubble extends StatelessWidget {
  final String text;
  final bool mine;
  final bool read;
  final DateTime time;

  const ChatMessageBubble({
    super.key,
    required this.text,
    required this.mine,
    required this.read,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final timeLabel =
        '${DateFormat('HH:mm').format(time)}'
        '${mine && read ? ' • Dibaca' : ''}';

    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.fromLTRB(15, 11, 15, 8),
        decoration: BoxDecoration(
          color: mine
              ? AppColors.primaryDark
              : Colors.white.withValues(alpha: 0.82),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(mine ? 18 : 5),
            bottomRight: Radius.circular(mine ? 5 : 18),
          ),
          border: mine
              ? null
              : Border.all(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  width: 1,
                ),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink.withValues(alpha: 0.045),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                height: 1.45,
                color: mine ? Colors.white : AppColors.ink,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              timeLabel,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: mine
                    ? Colors.white.withValues(alpha: 0.72)
                    : AppColors.ink.withValues(alpha: 0.48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
