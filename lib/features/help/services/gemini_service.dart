import 'dart:async';
import 'dart:convert';
import 'dart:io' show SocketException;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:laporkeun/core/secrets.dart';
import '../widgets/chat_message.dart';

class GeminiException implements Exception {
  final String message;
  const GeminiException(this.message);

  @override
  String toString() => message;
}

/// Error sementara dari server (sibuk / model tidak tersedia / timeout):
/// boleh dicoba dengan model berikutnya.
class _RetryableException implements Exception {
  const _RetryableException();
}


class GeminiService {
  static const String _apiKey = geminiApiKey;

  /// Dicoba berurutan. Jika satu model gagal sementara, pindah ke berikutnya.
  static const List<String> _models = [
    'gemini-3.5-flash-lite',
    'gemini-3.6-flash',
    'gemini-flash-latest',
    'gemini-2.5-flash',
  ];

  static const String _systemPrompt = '''
Kamu adalah asisten LaporKeun!, pendamping untuk siswa SMA/SMK yang mengalami atau melihat bullying dan kekerasan di sekolah.

Aturan:
- Jawab dalam bahasa Indonesia yang hangat, sederhana, dan tidak menghakimi.
- Tulis teks biasa saja. Jangan pakai format markdown (tanpa tanda bintang, tanpa tanda pagar, tanpa tabel).
- Jawaban singkat, maksimal sekitar 5 kalimat, kecuali diminta lebih rinci.
- Dengarkan dulu, validasi perasaan siswa, lalu tawarkan langkah kecil yang bisa dilakukan.
- Dorong siswa melapor lewat tombol Lapor di aplikasi (bisa anonim) atau bercerita kepada Guru BK atau orang dewasa yang dipercaya.
- Kamu bukan psikolog dan bukan pengganti Guru BK. Jangan membuat diagnosis.
- Jika ada tanda bahaya (ingin menyakiti diri, kekerasan fisik berat, ancaman): minta siswa segera menghubungi orang dewasa terdekat atau layanan darurat 112, dan beri tahu bahwa ia tidak sendirian.
- Jika siswa mengirim gambar (misalnya tangkapan layar pesan), jelaskan apa yang terlihat secara netral, sarankan menyimpannya sebagai bukti, dan jangan menebak identitas orang.
- Jangan meminta nama lengkap, alamat, atau data pribadi lain.
''';

  Future<String> reply(List<ChatMessage> history) async {
    if (_apiKey.isEmpty) {
      throw const GeminiException(
        'API key Gemini belum dipasang di secrets.dart',
      );
    }

    final contents = _buildContents(history);

    for (var i = 0; i < _models.length; i++) {
      try {
        return await _call(_models[i], contents);
      } on _RetryableException {
        debugPrint('Gemini: ${_models[i]} gagal, mencoba model berikutnya.');
      }
    }
    throw const GeminiException(
      'Asisten sedang ramai atau koneksi lambat. Coba lagi beberapa saat lagi.',
    );
  }

  Future<String> _call(
    String model,
    List<Map<String, dynamic>> contents,
  ) async {
    final uri = Uri.https(
      'generativelanguage.googleapis.com',
      '/v1beta/models/$model:generateContent',
    );

    try {
      final res = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'x-goog-api-key': _apiKey,
            },
            body: jsonEncode({
              'systemInstruction': {
                'parts': [
                  {'text': _systemPrompt},
                ],
              },
              'contents': contents,
              'generationConfig': {'maxOutputTokens': 2048},
            }),
          )
          .timeout(const Duration(seconds: 25));

      if (res.statusCode != 200) {
        debugPrint('Gemini $model ${res.statusCode}: ${res.body}');
        if (const [404, 429, 500, 503].contains(res.statusCode)) {
          throw const _RetryableException();
        }
        throw GeminiException(
          'Asisten sedang bermasalah (kode ${res.statusCode}). Coba lagi nanti.',
        );
      }

      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final candidates = data['candidates'] as List?;
      if (candidates == null || candidates.isEmpty) {
        throw const GeminiException(
          'Pesan ini belum bisa diproses. Coba tulis dengan kata lain.',
        );
      }
      final parts = (candidates.first['content']?['parts'] as List?) ?? [];
      final text = parts.map((p) => (p['text'] ?? '').toString()).join().trim();
      if (text.isEmpty) {
        throw const GeminiException(
          'Asisten belum bisa menjawab. Coba kirim ulang.',
        );
      }
      return text;
    } on TimeoutException {
      debugPrint('Gemini $model timeout');
      throw const _RetryableException();
    } on SocketException {
      throw const GeminiException('Tidak ada koneksi internet.');
    }
  }

  List<Map<String, dynamic>> _buildContents(List<ChatMessage> history) {
    final valid = history.where((m) => !m.isError).toList();
    final recent = valid.length > 20 ? valid.sublist(valid.length - 20) : valid;

    final contents = <Map<String, dynamic>>[];
    for (var i = 0; i < recent.length; i++) {
      final m = recent[i];
      final parts = <Map<String, dynamic>>[];
      if (m.text.isNotEmpty) parts.add({'text': m.text});
      // Gambar hanya disertakan untuk pesan-pesan terakhir agar request tetap ringan.
      if (m.imageBytes != null && i >= recent.length - 4) {
        parts.add({
          'inlineData': {
            'mimeType': m.imageMime ?? 'image/jpeg',
            'data': base64Encode(m.imageBytes!),
          },
        });
      }
      if (parts.isEmpty) continue;

      final role = m.isUser ? 'user' : 'model';
      // Percakapan harus dimulai dari giliran user.
      if (contents.isEmpty && role == 'model') continue;
      contents.add({'role': role, 'parts': parts});
    }
    return contents;
  }
}