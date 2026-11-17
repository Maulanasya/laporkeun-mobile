import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../core/utils.dart';
import '../data/repository.dart';

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key});

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  static const _maxImages = 3;
  static const _maxBytes = 5 * 1024 * 1024;

  final _form = GlobalKey<FormState>();
  final _lokasi = TextEditingController();
  final _kronologi = TextEditingController();
  final List<XFile> _images = [];
  String? _kategori;
  DateTime? _waktu;
  bool _waktuError = false;
  bool _tampilkanNama = true;
  bool _sending = false;

  @override
  void dispose() {
    _lokasi.dispose();
    _kronologi.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _waktu ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (d == null || !mounted) return;
    final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (t == null) return;
    setState(() {
      _waktu = DateTime(d.year, d.month, d.day, t.hour, t.minute);
      _waktuError = false;
    });
  }

  Future<void> _pickImages() async {
    final picked = await ImagePicker().pickMultiImage(imageQuality: 80, maxWidth: 1600);
    if (!mounted) return;
    for (final x in picked) {
      if (_images.length >= _maxImages) {
        snack(context, 'Maksimal $_maxImages gambar.');
        break;
      }
      final ext = x.name.split('.').last.toLowerCase();
      if (!['jpg', 'jpeg', 'png', 'webp'].contains(ext)) {
        snack(context, '${x.name}: hanya JPG, PNG, atau WebP.');
        continue;
      }
      final size = await x.length();
      if (!mounted) return;
      if (size > _maxBytes) {
        snack(context, '${x.name}: ukuran melebihi 5 MB.');
        continue;
      }
      _images.add(x);
    }
    setState(() {});
  }

  Future<void> _submit() async {
    final valid = _form.currentState!.validate();
    if (_waktu == null) {
      setState(() {
        _waktuError = true;
      });
    }
    if (!valid || _waktu == null) return;

    setState(() {
      _sending = true;
    });
    try {
      final report = await Repo.createReport(
        kategori: _kategori!,
        lokasi: _lokasi.text.trim(),
        waktu: _waktu!,
        kronologi: _kronologi.text.trim(),
        tampilkanNama: _tampilkanNama,
      );
      String? warning;
      if (_images.isNotEmpty) {
        try {
          await Repo.uploadEvidence(report.id, _images);
        } catch (e) {
          warning = 'Laporan terkirim, tetapi sebagian bukti gagal diunggah: ${errMsg(e)}';
        }
      }
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
          title: const Text('Laporan Terkirim'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Simpan kode laporan ini untuk merujuk laporanmu:'),
              const SizedBox(height: 8),
              SelectableText(
                report.kode,
                style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Status saat ini: Menunggu Ditinjau. Kamu bisa memantaunya di halaman Laporan Saya.'),
              if (warning != null) ...[
                const SizedBox(height: 8),
                Text(warning, style: const TextStyle(color: Colors.red)),
              ],
            ],
          ),
          actions: [FilledButton(onPressed: () => Navigator.pop(ctx), child: const Text('Selesai'))],
        ),
      );
      if (mounted) context.pop();
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
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Buat Laporan')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              color: cs.secondaryContainer,
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Ceritakan dengan jujur. Laporanmu hanya dapat dibaca oleh pihak sekolah yang berwenang.',
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _kategori,
              decoration: const InputDecoration(labelText: 'Kategori kasus'),
              items: [
                for (final e in kategoriLabels.entries)
                  DropdownMenuItem(value: e.key, child: Text(e.value)),
              ],
              onChanged: (v) => _kategori = v,
              validator: (v) => v == null ? 'Pilih kategori kasus' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lokasi,
              decoration: const InputDecoration(
                labelText: 'Lokasi kejadian',
                hintText: 'Contoh: kantin, lantai 2 gedung B',
              ),
              validator: (v) => (v == null || v.trim().length < 3) ? 'Lokasi wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _pickDateTime,
              icon: const Icon(Icons.event),
              label: Text(_waktu == null ? 'Pilih tanggal dan waktu kejadian' : fmtDate(_waktu!)),
            ),
            if (_waktuError)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 12),
                child: Text('Waktu kejadian wajib diisi', style: TextStyle(color: cs.error, fontSize: 12)),
              ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _kronologi,
              minLines: 5,
              maxLines: 10,
              decoration: const InputDecoration(
                labelText: 'Kronologi kejadian',
                alignLabelWithHint: true,
                helperText: 'Apa yang terjadi, siapa yang terlibat (jika kamu bersedia), dan dampaknya bagimu.',
                helperMaxLines: 2,
              ),
              validator: (v) => (v == null || v.trim().length < 20) ? 'Kronologi minimal 20 karakter' : null,
            ),
            const SizedBox(height: 20),
            Text('Bukti gambar (opsional)', style: tt.titleSmall),
            Text('Maksimal $_maxImages gambar, JPG/PNG/WebP, masing-masing maksimal 5 MB.', style: tt.bodySmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final x in _images)
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(File(x.path), width: 88, height: 88, fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 2,
                        right: 2,
                        child: InkWell(
                          onTap: () => setState(() {
                            _images.remove(x);
                          }),
                          child: const CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.black54,
                            child: Icon(Icons.close, size: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                if (_images.length < _maxImages)
                  OutlinedButton.icon(
                    onPressed: _pickImages,
                    icon: const Icon(Icons.add_photo_alternate_outlined),
                    label: const Text('Tambah gambar'),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Identitas pelapor', style: tt.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, icon: Icon(Icons.person), label: Text('Tampilkan nama')),
                ButtonSegment(value: false, icon: Icon(Icons.visibility_off), label: Text('Anonim')),
              ],
              selected: {_tampilkanNama},
              onSelectionChanged: (s) => setState(() {
                _tampilkanNama = s.first;
              }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                _tampilkanNama
                    ? 'Namamu akan terlihat oleh guru BK yang meninjau laporan.'
                    : 'Namamu disembunyikan dari guru BK dan psikolog pada laporan ini.',
                style: tt.bodySmall,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _sending ? null : _submit,
              icon: _sending
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.send),
              label: Text(_sending ? 'Mengirim...' : 'Kirim Laporan'),
            ),
          ],
        ),
      ),
    );
  }
}