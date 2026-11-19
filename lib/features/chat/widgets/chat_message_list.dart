import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils.dart';
import '../../../data/repository.dart';
import 'chat_message_bubble.dart';

class ChatMessageList extends StatelessWidget {
  final Stream<List<Map<String, dynamic>>> stream;
  final String sessionId;
  final String currentUserId;

  const ChatMessageList({
    super.key,
    required this.stream,
    required this.sessionId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snap) {
        if (snap.hasError) {
          return _ChatErrorState(message: errMsg(snap.error!));
        }

        if (!snap.hasData) {
          return const _ChatLoadingState();
        }

        final messages = snap.data!;

        if (messages.any(
          (message) =>
              message['sender_id'] != currentUserId &&
              message['status_baca'] == false,
        )) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Repo.markRead(sessionId);
          });
        }

        if (messages.isEmpty) {
          return const _ChatEmptyState();
        }

        return ListView.builder(
          reverse: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[messages.length - 1 - index];

            return ChatMessageBubble(
              text: message['isi_pesan'] as String,
              mine: message['sender_id'] == currentUserId,
              read: message['status_baca'] == true,
              time: DateTime.parse(message['created_at'] as String).toLocal(),
            );
          },
        );
      },
    );
  }
}

class _ChatLoadingState extends StatelessWidget {
  const _ChatLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 14),
          Text(
            'Memuat percakapan...',
            style: TextStyle(fontSize: 12, color: AppColors.ink),
          ),
        ],
      ),
    );
  }
}

class _ChatEmptyState extends StatelessWidget {
  const _ChatEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: AppColors.mint.withValues(alpha: 0.55),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 30,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum Ada Pesan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              'Mulai percakapan dengan mengirim pesan pertama.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: AppColors.ink.withValues(alpha: 0.65),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatErrorState extends StatelessWidget {
  final String message;

  const _ChatErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 42,
              color: AppColors.primaryDark.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 12),
            const Text(
              'Gagal Memuat Percakapan',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: AppColors.ink.withValues(alpha: 0.65),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
