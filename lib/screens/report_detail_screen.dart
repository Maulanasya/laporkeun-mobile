import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/utils.dart';
import '../data/models.dart';
import '../data/repository.dart';

const _hints = <String, String>{
  'menunggu_ditinjau': 'Laporanmu sudah masuk dan menunggu ditinjau oleh guru BK.',
  'sedang_ditinjau': 'Guru BK sedang meninjau laporanmu.',
  'dalam_penanganan': 'Laporanmu sudah mendapat tindak lanjut dari guru BK.',
  'dialihkan_psikolog': 'Kamu dialihkan untuk berkonsultasi dengan psikolog.',
  'selesai': 'Penanganan laporanmu telah selesai.',
};

class ReportDetailScreen extends StatefulWidget {
  final String reportId, role;
  const ReportDetailScreen({super.key, required this.reportId, required this.role});

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  Report? _r;
  List<String> _urls = [];
  List<HistoryItem> _hist = [];
  ConsultSession? _bk, _psy;
  bool _loading = true;
  String? _error;
  String? _newStatus;
  final _note = TextEditingController();

  bool get _staff => widget.role != 'siswa';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final r = await Repo.reportById(widget.reportId, staff: _staff);
      final (urls, hist, bk, psy) = await (
        Repo.evidenceUrls(r.id),
        Repo.history(r.id),
        Repo.sessionFor(r.id, 'bk'),
        Repo.sessionFor(r.id, 'psikolog'),
      ).wait;
      if (!mounted) return;
      setState(() {
        _r = r;
        _urls = urls;
        _hist = hist;
        _bk = bk;
        _psy = psy;
        _error = null;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = errMsg(e);
        _loading = false;
      });
    }
  }

  void _openChat(ConsultSession s, String label) {
    context.push('/chat/${s.id}', extra: '$label • ${_r!.kode}');
  }

  Future<void> _updateStatus() async {
    if (_newStatus == null) {
      snack(context, 'Pilih status terlebih dahulu.');
      return;
    }
    try {
      final note = _note.text.trim();
      await Repo.updateStatus(_r!.id, _newStatus!, note.isEmpty ? null : note);
      _note.clear();
      if (!mounted) return;
      snack(context, 'Status diperbarui.');
      await _load();
    } catch (e) {
      if (mounted) snack(context, errMsg(e));
    }
  }

  Future<void> _refer() async {
    try {
      final list = await Repo.psychologists();
      if (!mounted) return;
      if (list.isEmpty) {
        snack(context, 'Belum ada akun psikolog yang terdaftar.');
        return;
      }
      String? psyId = list.first['id'] as String;
      final noteCtl = TextEditingController();
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Alihkan ke Psikolog'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: psyId,
                decoration: const InputDecoration(labelText: 'Pilih psikolog'),
                items: [
                  for (final p in list)
                    DropdownMenuItem(value: p['id'] as String, child: Text(p['nama'] as String)),
                ],
                onChanged: (v) => psyId = v,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteCtl,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Catatan penilaian / alasan pengalihan'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Alihkan')),
          ],
        ),
      );
      final note = noteCtl.text.trim();
      noteCtl.dispose();
      if (ok != true || psyId == null) return;
      await Repo.referToPsychologist(_r!.id, psyId!, note.isEmpty ? null : note);
      if (!mounted) return;
      snack(context, 'Siswa dialihkan ke psikolog.');
      await _load();
    } catch (e) {
      if (mounted) snack(context, errMsg(e));
    }
  }

  Future<void> _call(String phone) async {
    final ok = await launchUrl(Uri(scheme: 'tel', path: phone));
    if (!ok && mounted) snack(context, 'Tidak dapat membuka aplikasi telepon.');
  }

  Widget _title(String t) => Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 8),
        child: Text(t, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
      );

  Widget _row(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 110, child: Text(k, style: TextStyle(color: Theme.of(context).colorScheme.outline))),
            Expanded(child: Text(v)),
          ],
        ),
      );

  List<Widget> _actions() {
    switch (widget.role) {
      case 'siswa':
        return [
          _title('Konsultasi'),
          if (_bk == null)
            const Text('Ruang konsultasi dengan guru BK akan terbuka setelah laporanmu mulai ditinjau.')
          else
            FilledButton.icon(
              onPressed: () => _openChat(_bk!, 'Guru BK'),
              icon: const Icon(Icons.chat),
              label: const Text('Konsultasi dengan Guru BK'),
            ),
          if (_psy != null) ...[
            const SizedBox(height: 8),
            FilledButton.tonalIcon(
              onPressed: () => _openChat(_psy!, 'Psikolog'),
              icon: const Icon(Icons.psychology),
              label: const Text('Ruang Chat Psikolog'),
            ),
            if ((_psy!.psychologistPhone ?? '').isNotEmpty) ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => _call(_psy!.psychologistPhone!),
                icon: const Icon(Icons.call),
                label: const Text('Telepon Psikolog'),
              ),
            ],
          ],
        ];
      case 'guru_bk':
        return [
          _title('Tindak Lanjut'),
          if (_bk == null)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'Mengubah status untuk pertama kali akan menjadikan Anda penanggung jawab '
                'laporan ini dan membuka ruang konsultasi dengan siswa.',
              ),
            ),
          DropdownButtonFormField<String>(
            initialValue: _newStatus,
            decoration: const InputDecoration(labelText: 'Ubah status'),
            items: [
              for (final s in const ['sedang_ditinjau', 'dalam_penanganan', 'selesai'])
                DropdownMenuItem(value: s, child: Text(statusLabels[s]!)),
            ],
            onChanged: (v) => _newStatus = v,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _note,
            maxLines: 2,
            decoration: const InputDecoration(labelText: 'Catatan (opsional)'),
          ),
          const SizedBox(height: 12),
          FilledButton(onPressed: _updateStatus, child: const Text('Perbarui Status')),
          if (_bk != null) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _openChat(_bk!, 'Siswa'),
              icon: const Icon(Icons.chat),
              label: const Text('Konsultasi dengan Siswa'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _refer,
              icon: const Icon(Icons.support_agent),
              label: const Text('Alihkan ke Psikolog (trauma tinggi)'),
            ),
          ],
          if (_psy != null) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _openChat(_psy!, 'Psikolog'),
              icon: const Icon(Icons.psychology),
              label: const Text('Lihat Ruang Psikolog'),
            ),
          ],
        ];
      default:
        return [
          _title('Pendampingan'),
          if (_psy != null)
            FilledButton.icon(
              onPressed: () => _openChat(_psy!, 'Siswa'),
              icon: const Icon(Icons.chat),
              label: const Text('Buka Ruang Chat'),
            ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = _r;
    return Scaffold(
      appBar: AppBar(title: Text(r?.kode ?? 'Detail Laporan')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null || r == null
              ? Center(child: Padding(padding: const EdgeInsets.all(24), child: Text(_error ?? 'Data tidak ditemukan')))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Row(children: [StatusChip(r.status)]),
                      if (!_staff) ...[
                        const SizedBox(height: 8),
                        Text(_hints[r.status] ?? ''),
                      ],
                      _title('Informasi Laporan'),
                      _row('Kode', r.kode),
                      _row('Kategori', kategoriLabels[r.kategori] ?? r.kategori),
                      _row('Pelapor', r.identitas),
                      _row('Lokasi', r.lokasi),
                      _row('Waktu kejadian', fmtDate(r.waktuKejadian)),
                      _row('Dikirim', fmtDate(r.createdAt)),
                      _title('Kronologi'),
                      SelectableText(r.kronologi, style: const TextStyle(height: 1.5)),
                      if (_urls.isNotEmpty) ...[
                        _title('Bukti Pendukung'),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final u in _urls)
                              GestureDetector(
                                onTap: () => showDialog<void>(
                                  context: context,
                                  builder: (_) => Dialog(child: InteractiveViewer(child: Image.network(u))),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    u,
                                    width: 96,
                                    height: 96,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stack) =>
                                        const SizedBox(width: 96, height: 96, child: Icon(Icons.broken_image)),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                      _title('Riwayat Penanganan'),
                      for (final h in _hist)
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.circle, size: 12),
                          title: Text(statusLabels[h.statusBaru] ?? h.statusBaru),
                          subtitle: Text(
                            '${fmtDate(h.createdAt)}${(h.catatan ?? '').isEmpty ? '' : '\n${h.catatan}'}',
                          ),
                        ),
                      ..._actions(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
    );
  }
}