import 'package:flutter/material.dart';

import '../../../data/repository.dart';
import '../../../core/utils.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/layouts/app_background.dart';

import '../widgets/chat_input_field.dart';
import '../widgets/chat_message_list.dart';
import '../widgets/chat_privacy_banner.dart';

class ChatScreen extends StatefulWidget {
  final String sessionId;
  final String title;

  const ChatScreen({super.key, required this.sessionId, required this.title});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _c = TextEditingController();

  late final Stream<List<Map<String, dynamic>>> _stream = Repo.messages(
    widget.sessionId,
  );

  final String _me = sb.auth.currentUser!.id;

  bool _sending = false;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _c.text.trim();

    if (text.isEmpty || _sending) return;

    setState(() {
      _sending = true;
    });

    try {
      await Repo.sendMessage(widget.sessionId, text);
      _c.clear();
    } catch (e) {
      if (mounted) {
        snack(context, errMsg(e));
      }
    } finally {
      if (mounted) {
        setState(() {
          _sending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.landingBackground,
      body: SafeArea(
        child: AppBackground(
          child: Column(
            children: [
              // Header Chat
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 20, 12),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.ink,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.7),
                        shape: const CircleBorder(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'RUANG KONSULTASI',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                              color: AppColors.primaryDark.withValues(
                                alpha: 0.8,
                              ),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            widget.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: AppColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Informasi privasi
              const ChatPrivacyBanner(),

              // Daftar pesan
              Expanded(
                child: ChatMessageList(
                  stream: _stream,
                  sessionId: widget.sessionId,
                  currentUserId: _me,
                ),
              ),

              // Input pesan
              ChatInputField(controller: _c, sending: _sending, onSend: _send),
            ],
          ),
        ),
      ),
    );
  }
}
