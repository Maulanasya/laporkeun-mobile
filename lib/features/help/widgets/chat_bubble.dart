import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../widgets/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final maxWidth = MediaQuery.of(context).size.width * 0.72;

    final Color bg = message.isError
        ? const Color(0xFFFFE3E0)
        : isUser
        ? AppColors.primaryDark
        : Colors.white.withValues(alpha: 0.9);
    final Color fg = isUser ? Colors.white : AppColors.ink;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 6),
            bottomRight: Radius.circular(isUser ? 6 : 20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (message.imageBytes != null)
              GestureDetector(
                onTap: () => _preview(context, message),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.memory(
                    message.imageBytes!,
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            if (message.imageBytes != null && message.text.isNotEmpty)
              const SizedBox(height: 8),
            if (message.text.isNotEmpty)
              Text(
                message.text,
                style: TextStyle(fontSize: 14.5, height: 1.4, color: fg),
              ),
          ],
        ),
      ),
    );
  }

  void _preview(BuildContext context, ChatMessage m) {
    showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: InteractiveViewer(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.memory(m.imageBytes!),
          ),
        ),
      ),
    );
  }
}