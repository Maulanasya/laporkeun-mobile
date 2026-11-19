import 'dart:math';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/report_draft.dart';

const String kEvidenceBucket = 'report-evidence';

class ReportException implements Exception {
  const ReportException(this.message);
  final String message;

  @override
  String toString() => message;
}

class ReportSubmitResult {
  const ReportSubmitResult({required this.code, this.failedEvidence = 0});

  final String code;

  final int failedEvidence;
}

/// Mengirim laporan ke Supabase:
/// 1. insert ke `reports`
/// 2. unggah gambar ke Storage
/// 3. insert referensi ke `report_evidence`
class ReportService {
  const ReportService();

  Future<ReportSubmitResult> submit(ReportDraft draft) async {
    final db = Supabase.instance.client;
    final user = db.auth.currentUser;
    if (user == null) {
      throw const ReportException('Kamu perlu login dulu untuk mengirim laporan.');
    }

    String? reportId;
    String code = '';
    for (var attempt = 0; attempt < 5 && reportId == null; attempt++) {
      code = _generateCode();
      try {
        final row = await db
            .from('reports')
            .insert({
              'kode_laporan': code,
              'reporter_id': user.id,
              'kategori': draft.category.name,
              'lokasi': draft.location,
              'waktu_kejadian': draft.occurredAt.toUtc().toIso8601String(),
              'kronologi': draft.chronology,
              'tampilkan_nama': draft.identity == IdentityChoice.nama,
            })
            .select('id')
            .single();
        reportId = row['id'] as String;
      } on PostgrestException catch (e) {
        if (e.code == '23505' && attempt < 4) continue;
        throw const ReportException(
          'Laporan belum terkirim. Periksa koneksi lalu coba lagi.',
        );
      }
    }
    if (reportId == null) {
      throw const ReportException(
        'Laporan belum terkirim. Periksa koneksi lalu coba lagi.',
      );
    }

    var failed = 0;
    for (final file in draft.evidence) {
      try {
        final ext = _extOf(file.name);
        final mime = _mimeOf(ext);
        final stamp = DateTime.now().microsecondsSinceEpoch;
        final path = '${user.id}/$reportId/$stamp.$ext';

        await db.storage.from(kEvidenceBucket).uploadBinary(
              path,
              file.bytes,
              fileOptions: FileOptions(contentType: mime, upsert: false),
            );
        await db.from('report_evidence').insert({
          'report_id': reportId,
          'file_path': path,
          'tipe_file': mime,
        });
      } catch (_) {
        failed++;
      }
    }

    return ReportSubmitResult(code: code, failedEvidence: failed);
  }

  static String _generateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rnd = Random.secure();
    final suffix =
        List.generate(6, (_) => chars[rnd.nextInt(chars.length)]).join();
    return 'LK-$suffix';
  }

  static String _extOf(String name) {
    final dot = name.lastIndexOf('.');
    if (dot == -1 || dot == name.length - 1) return 'jpg';
    final ext = name.substring(dot + 1).toLowerCase();
    return const {'jpg', 'jpeg', 'png', 'webp'}.contains(ext) ? ext : 'jpg';
  }

  static String _mimeOf(String ext) {
    switch (ext) {
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }
}