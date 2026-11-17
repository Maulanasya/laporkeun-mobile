import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'models.dart';

final sb = Supabase.instance.client;

String mimeOf(String filename) {
  switch (filename.split('.').last.toLowerCase()) {
    case 'png':
      return 'image/png';
    case 'webp':
      return 'image/webp';
    default:
      return 'image/jpeg';
  }
}

class Repo {
  // ---------- Artikel edukasi ----------
  static Future<List<Article>> articles({bool onlyPublished = true}) async {
    var q = sb.from('articles').select();
    if (onlyPublished) q = q.eq('status_publikasi', 'terbit');
    final data = await q.order('tanggal_publikasi', ascending: false);
    return data.map(Article.fromMap).toList();
  }

  static Future<Article> articleById(String id) async {
    final d = await sb.from('articles').select().eq('id', id).single();
    return Article.fromMap(d);
  }

  static Future<void> saveArticle({
    String? id,
    required String judul,
    String? ringkasan,
    required String isi,
    String? cover,
    required bool terbit,
  }) async {
    final data = {
      'judul': judul,
      'ringkasan': ringkasan,
      'isi': isi,
      'gambar_sampul': cover,
      'status_publikasi': terbit ? 'terbit' : 'draft',
    };
    if (id == null) {
      await sb.from('articles').insert(data);
    } else {
      await sb.from('articles').update(data).eq('id', id);
    }
  }

  static Future<void> deleteArticle(String id) async {
    await sb.from('articles').delete().eq('id', id);
  }

  // ---------- Laporan ----------
  static Future<Report> createReport({
    required String kategori,
    required String lokasi,
    required DateTime waktu,
    required String kronologi,
    required bool tampilkanNama,
  }) async {
    final row = await sb
        .from('reports')
        .insert({
          'kategori': kategori,
          'lokasi': lokasi,
          'waktu_kejadian': waktu.toUtc().toIso8601String(),
          'kronologi': kronologi,
          'tampilkan_nama': tampilkanNama,
        })
        .select()
        .single();
    return Report.fromMap(row);
  }

  static Future<void> uploadEvidence(String reportId, List<XFile> files) async {
    for (var i = 0; i < files.length; i++) {
      final f = files[i];
      final ext = f.name.split('.').last.toLowerCase();
      final path = '$reportId/${DateTime.now().microsecondsSinceEpoch}_$i.$ext';
      final mime = mimeOf(f.name);
      await sb.storage
          .from('bukti')
          .upload(path, File(f.path), fileOptions: FileOptions(contentType: mime));
      await sb.from('report_evidence').insert({
        'report_id': reportId,
        'file_path': path,
        'tipe_file': mime,
      });
    }
  }

  /// Laporan milik siswa yang sedang login (dibatasi RLS).
  static Future<List<Report>> myReports() async {
    final d = await sb.from('reports').select().order('created_at', ascending: false);
    return d.map(Report.fromMap).toList();
  }

  /// Laporan untuk guru BK (semua) atau psikolog (yang dialihkan kepadanya).
  static Future<List<Report>> staffReports() async {
    final d = await sb.from('staff_reports').select().order('created_at', ascending: false);
    return d.map(Report.fromMap).toList();
  }

  static Future<Report> reportById(String id, {required bool staff}) async {
    final d = await sb.from(staff ? 'staff_reports' : 'reports').select().eq('id', id).single();
    return Report.fromMap(d);
  }

  static Future<List<String>> evidenceUrls(String reportId) async {
    final rows = await sb.from('report_evidence').select('file_path').eq('report_id', reportId);
    final paths = rows.map((r) => r['file_path'] as String).toList();
    if (paths.isEmpty) return [];
    final signed = await sb.storage.from('bukti').createSignedUrls(paths, 3600);
    return signed.map((s) => s.signedUrl).toList();
  }

  static Future<List<HistoryItem>> history(String reportId) async {
    final d = await sb
        .from('report_status_history')
        .select()
        .eq('report_id', reportId)
        .order('created_at', ascending: true);
    return d.map(HistoryItem.fromMap).toList();
  }

  // ---------- Tindak lanjut guru BK ----------
  static Future<void> updateStatus(String reportId, String status, String? note) async {
    await sb.rpc('update_report_status', params: {
      'p_report': reportId,
      'p_status': status,
      'p_note': note,
    });
  }

  static Future<List<Map<String, dynamic>>> psychologists() async {
    final d = await sb.rpc('list_psychologists');
    return List<Map<String, dynamic>>.from(d as List);
  }

  static Future<void> referToPsychologist(String reportId, String psychologistId, String? note) async {
    await sb.rpc('refer_to_psychologist', params: {
      'p_report': reportId,
      'p_psychologist': psychologistId,
      'p_note': note,
    });
  }

  // ---------- Konsultasi ----------
  static Future<ConsultSession?> sessionFor(String reportId, String jenis) async {
    final r = await sb
        .from('consultation_sessions')
        .select()
        .eq('report_id', reportId)
        .eq('jenis_sesi', jenis)
        .maybeSingle();
    return r == null ? null : ConsultSession.fromMap(r);
  }

  static Stream<List<Map<String, dynamic>>> messages(String sessionId) {
    return sb
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('session_id', sessionId)
        .order('created_at', ascending: true);
  }

  static Future<void> sendMessage(String sessionId, String text) async {
    await sb.from('messages').insert({'session_id': sessionId, 'isi_pesan': text});
  }

  static Future<void> markRead(String sessionId) async {
    try {
      await sb.rpc('mark_messages_read', params: {'p_session': sessionId});
    } catch (_) {}
  }
}