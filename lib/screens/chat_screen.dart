import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/utils.dart';
import '../data/repository.dart';

class ChatScreen extends StatefulWidget {
  final String sessionId, title;
  const ChatScreen({super.key, required this.sessionId, required this.title});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _c = TextEditingController();
  late final Stream<List<Map<String, dynamic>>> _stream = Repo.messages(widget.sessionId);
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
      if (mounted) snack(context, errMsg(e));
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
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: cs.secondaryContainer,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Percakapan ini bersifat rahasia dan hanya dapat dibaca oleh peserta sesi.',
              style: TextStyle(fontSize: 12, color: cs.onSecondaryContainer),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _stream,
              builder: (context, snap) {
                if (snap.hasError) return Center(child: Text(errMsg(snap.error!)));
                if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                final msgs = snap.data!;
                if (msgs.any((m) => m['sender_id'] != _me && m['status_baca'] == false)) {
                  WidgetsBinding.instance.addPostFrameCallback((_) => Repo.markRead(widget.sessionId));
                }
                if (msgs.isEmpty) {
                  return const Center(child: Text('Belum ada pesan. Mulai percakapan di bawah.'));
                }
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(12),
                  itemCount: msgs.length,
                  itemBuilder: (context, i) {
                    final m = msgs[msgs.length - 1 - i];
                    return _Bubble(
                      text: m['isi_pesan'] as String,
                      mine: m['sender_id'] == _me,
                      read: m['status_baca'] == true,
                      time: DateTime.parse(m['created_at'] as String).toLocal(),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _c,
                      minLines: 1,
                      maxLines: 4,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(hintText: 'Tulis pesan...'),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _sending ? null : _send,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final String text;
  final bool mine, read;
  final DateTime time;
  const _Bubble({required this.text, required this.mine, required this.read, required this.time});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: mine ? cs.primaryContainer : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text),
            const SizedBox(height: 2),
            Text(
              '${DateFormat('HH:mm').format(time)}${mine && read ? ' • Dibaca' : ''}',
              style: TextStyle(fontSize: 10, color: cs.outline),
            ),
          ],
        ),
      ),
    );
  }
}