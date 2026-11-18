import 'dart:typed_data';

class ChatMessage {
  final String text;
  final bool isUser;
  final Uint8List? imageBytes;
  final String? imageMime;
  final bool isError;

  const ChatMessage({
    required this.text,
    required this.isUser,
    this.imageBytes,
    this.imageMime,
    this.isError = false,
  });

  const ChatMessage.ai(this.text, {this.isError = false})
    : isUser = false,
      imageBytes = null,
      imageMime = null;
}