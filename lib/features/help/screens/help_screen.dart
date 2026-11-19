import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_bottom_nav.dart';
import '../../../shared/widgets/page_backdrop.dart';

import '../widgets/chat_message.dart';
import '../services/gemini_service.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/chat_panel_header.dart';
import '../widgets/help_title.dart';
import '../widgets/help_top_bar.dart';
import '../widgets/quick_replies.dart';
import '../widgets/typing_indicator.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  static const ChatMessage _greeting = ChatMessage.ai(
    'Halo, aku asisten LaporKeun. Ceritakan apa yang kamu alami atau tanyakan cara melapor. '
    'Kamu juga bisa kirim gambar, misalnya tangkapan layar pesan.',
  );

  static const List<String> _quickReplies = [
    'Cara melapor',
    'Aku butuh teman cerita',
    'Apa itu bullying?',
  ];

  final GeminiService _gemini = GeminiService();
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();

  final List<ChatMessage> _messages = [_greeting];
  bool _sending = false;
  Uint8List? _pendingBytes;
  String? _pendingMime;

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.ink,
        content: Text(msg, style: const TextStyle(color: Colors.white)),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  String _mimeOf(String path) {
    final p = path.toLowerCase();
    if (p.endsWith('.png')) return 'image/png';
    if (p.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }

  Future<void> _chooseImageSource() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: const Text('Pilih dari galeri'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_rounded),
              title: const Text('Ambil foto'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;

    try {
      final file = await _picker.pickImage(
        source: source,
        maxWidth: 1280,
        imageQuality: 80,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      setState(() {
        _pendingBytes = bytes;
        _pendingMime = _mimeOf(file.path);
      });
    } catch (_) {
      _toast('Gambar tidak bisa dibuka. Coba pilih gambar lain.');
    }
  }

  Future<void> _send([String? preset]) async {
    final text = (preset ?? _input.text).trim();
    if (_sending || (text.isEmpty && _pendingBytes == null)) return;

    final userMsg = ChatMessage(
      text: text,
      isUser: true,
      imageBytes: _pendingBytes,
      imageMime: _pendingMime,
    );

    setState(() {
      _messages.add(userMsg);
      _sending = true;
      _pendingBytes = null;
      _pendingMime = null;
      _input.clear();
    });
    _scrollToEnd();

    try {
      final reply = await _gemini.reply(_messages);
      if (!mounted) return;
      setState(() => _messages.add(ChatMessage.ai(reply)));
    } on GeminiException catch (e) {
      if (!mounted) return;
      setState(() => _messages.add(ChatMessage.ai(e.message, isError: true)));
    } catch (_) {
      if (!mounted) return;
      setState(
        () => _messages.add(
          const ChatMessage.ai(
            'Terjadi kesalahan. Coba kirim ulang pesanmu.',
            isError: true,
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
      _scrollToEnd();
    }
  }

  void _reset() {
    setState(() {
      _messages
        ..clear()
        ..add(_greeting);
      _pendingBytes = null;
      _pendingMime = null;
      _input.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final keyboardOpen = media.viewInsets.bottom > 0;
    final bottomPad = keyboardOpen ? 8.0 : media.padding.bottom + 98;

    return Scaffold(
      backgroundColor: AppColors.landingBackground,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const Positioned.fill(child: PageBackdrop()),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HelpTopBar(),
                  const SizedBox(height: 18),
                  const HelpTitle(),
                  const SizedBox(height: 14),
                  Expanded(child: _chatPanel()),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: keyboardOpen
          ? null
          : const AppBottomNav(currentIndex: NavTab.help),
    );
  }

  Widget _chatPanel() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
      ),
      child: Column(
        children: [
          ChatPanelHeader(onReset: _reset),
          Divider(height: 1, color: AppColors.ink.withValues(alpha: 0.08)),
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
              itemCount: _messages.length + (_sending ? 1 : 0),
              itemBuilder: (_, i) {
                if (i == _messages.length) return const TypingIndicator();
                return ChatBubble(message: _messages[i]);
              },
            ),
          ),
          QuickReplies(
            options: _quickReplies,
            enabled: !_sending,
            onSelected: _send,
          ),
          ChatInputBar(
            controller: _input,
            sending: _sending,
            pendingImage: _pendingBytes,
            onAttach: _chooseImageSource,
            onRemoveImage: () => setState(() {
              _pendingBytes = null;
              _pendingMime = null;
            }),
            onSend: _send,
          ),
        ],
      ),
    );
  }
}