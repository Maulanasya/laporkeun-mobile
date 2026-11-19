import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../models/report_draft.dart';
import '../widgets/report_form_widgets.dart';
import '../data/report_service.dart';

const int kMaxEvidence = 3;
const int kMaxEvidenceBytes = 5 * 1024 * 1024; // 5 MB
const Set<String> kAllowedExt = {'jpg', 'jpeg', 'png', 'webp'};

/// Form laporan perundungan (LAP-1 s.d. LAP-9).
///
/// Buka dengan `Navigator.push(context, ReportFormScreen.route())`.
/// Mengembalikan kode laporan (String) jika laporan berhasil dikirim.
class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key, this.service = const ReportService()});

  final ReportService service;

  static Route<String?> route() =>
      MaterialPageRoute<String?>(builder: (_) => const ReportFormScreen());

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _categoryKey = GlobalKey();
  final _locationCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final _chronoCtrl = TextEditingController();
  final _picker = ImagePicker();

  ReportCategory? _category;
  bool _categoryError = false;
  DateTime? _occurredAt;
  final List<EvidenceFile> _evidence = [];
  IdentityChoice _identity = IdentityChoice.anonim;
  bool _submitting = false;

  @override
  void dispose() {
    _locationCtrl.dispose();
    _timeCtrl.dispose();
    _chronoCtrl.dispose();
    super.dispose();
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: RK.navy,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
  }

  Future<void> _pickDateTime() async {
    FocusScope.of(context).unfocus();
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _occurredAt ?? now,
      firstDate: DateTime(now.year - 3),
      lastDate: now,
      helpText: 'Tanggal kejadian',
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_occurredAt ?? now),
      helpText: 'Perkiraan jam kejadian',
    );
    if (time == null || !mounted) return;

    setState(() {
      _occurredAt =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
      _timeCtrl.text = formatDateTime(_occurredAt!);
    });
    _formKey.currentState?.validate();
  }

  Future<void> _pickEvidence() async {
    if (_evidence.length >= kMaxEvidence) {
      _toast('Maksimal $kMaxEvidence gambar.');
      return;
    }
    FocusScope.of(context).unfocus();

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F1F6),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library_rounded,
                      color: RK.teal),
                  title: const Text('Pilih dari galeri',
                      style: TextStyle(
                          color: RK.navy, fontWeight: FontWeight.w700)),
                  onTap: () => Navigator.pop(ctx, ImageSource.gallery),
                ),
                ListTile(
                  leading:
                      const Icon(Icons.photo_camera_rounded, color: RK.teal),
                  title: const Text('Ambil foto',
                      style: TextStyle(
                          color: RK.navy, fontWeight: FontWeight.w700)),
                  onTap: () => Navigator.pop(ctx, ImageSource.camera),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (source == null) return;

    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 2048,
      );
      if (picked == null) return;

      final ext = picked.name.contains('.')
          ? picked.name.split('.').last.toLowerCase()
          : '';
      final isImage = kAllowedExt.contains(ext) ||
          (picked.mimeType?.startsWith('image/') ?? false);
      if (!isImage) {
        _toast('Format tidak didukung. Gunakan JPG, PNG, atau WEBP.');
        return;
      }

      final bytes = await picked.readAsBytes();
      if (bytes.length > kMaxEvidenceBytes) {
        _toast('Ukuran gambar maksimal 5 MB.');
        return;
      }
      if (!mounted) return;
      setState(() {
        _evidence.add(EvidenceFile(name: picked.name, bytes: bytes));
      });
    } catch (_) {
      if (mounted) _toast('Gambar tidak bisa dibuka. Coba lagi ya.');
    }
  }

  Future<void> _submit() async {
    if (_submitting) return;
    FocusScope.of(context).unfocus();

    final fieldsOk = _formKey.currentState!.validate();
    final categoryOk = _category != null;
    setState(() => _categoryError = !categoryOk);

    if (!fieldsOk || !categoryOk) {
      _toast('Masih ada isian wajib yang belum lengkap.');
      if (!categoryOk && _categoryKey.currentContext != null) {
        Scrollable.ensureVisible(
          _categoryKey.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
      return;
    }

    setState(() => _submitting = true);
    try {
      final result = await widget.service.submit(
        ReportDraft(
          category: _category!,
          location: _locationCtrl.text.trim(),
          occurredAt: _occurredAt!,
          chronology: _chronoCtrl.text.trim(),
          evidence: List.unmodifiable(_evidence),
          identity: _identity,
        ),
      );
      if (!mounted) return;
      setState(() => _submitting = false);
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => _SuccessDialog(
          code: result.code,
          failedEvidence: result.failedEvidence,
        ),
      );
      if (!mounted) return;
      Navigator.of(context).pop(result.code);
    } on ReportException catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      _toast(e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _submitting = false);
      _toast('Laporan belum terkirim. Periksa koneksi lalu coba lagi.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RkBackground(
        child: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: Form(
                key: _formKey,
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 140),
                  children: [
                    _buildTopBar(),
                    const SizedBox(height: 22),
                    _buildHeading(),
                    const SizedBox(height: 22),
                    _buildCategorySection(),
                    const SizedBox(height: 16),
                    _buildWhenWhereSection(),
                    const SizedBox(height: 16),
                    _buildChronologySection(),
                    const SizedBox(height: 16),
                    _buildEvidenceSection(),
                    const SizedBox(height: 16),
                    _buildIdentitySection(),
                    const SizedBox(height: 16),
                    _buildSafetyNote(),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GlassCard(
                    radius: 36,
                    padding: const EdgeInsets.all(8),
                    child: RkPrimaryButton(
                      label: 'Kirim laporan',
                      icon: Icons.send_rounded,
                      loading: _submitting,
                      onPressed: _submit,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------- header

  Widget _buildTopBar() {
    return Row(
      children: [
        Semantics(
          button: true,
          label: 'Kembali',
          child: GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: RK.white(0.55),
                border: Border.all(color: RK.white(0.9), width: 1.2),
              ),
              child: const Icon(Icons.arrow_back_rounded, color: RK.navy),
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'Lapor aman',
          style: TextStyle(
            color: RK.navy,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildHeading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ceritakan,',
          style: TextStyle(
            color: RK.navy,
            fontWeight: FontWeight.w800,
            fontSize: 32,
            height: 1.15,
          ),
        ),
        const Text(
          'kami dengarkan.',
          style: TextStyle(
            color: RK.teal,
            fontWeight: FontWeight.w800,
            fontSize: 32,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.lock_outline_rounded, size: 16, color: RK.muted),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Isi seperlunya. Kode laporan muncul setelah laporanmu terkirim.',
                style: TextStyle(
                  color: RK.tint(RK.muted, 0.95),
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // -------------------------------------------------------------- sections

  Widget _buildCategorySection() {
    return GlassCard(
      key: _categoryKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            number: 1,
            title: 'Apa yang terjadi?',
            subtitle: 'Pilih yang paling mendekati.',
            color: RK.peach,
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              const gap = 12.0;
              final w = (constraints.maxWidth - gap) / 2;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final c in ReportCategory.values)
                    SizedBox(
                      width: w,
                      child: CategoryTile(
                        category: c,
                        selected: _category == c,
                        onTap: () => setState(() {
                          _category = c;
                          _categoryError = false;
                        }),
                      ),
                    ),
                ],
              );
            },
          ),
          if (_categoryError)
            const Padding(
              padding: EdgeInsets.only(top: 10, left: 4),
              child: Text(
                'Pilih salah satu kategori dulu ya.',
                style: TextStyle(color: RK.error, fontSize: 12.5),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWhenWhereSection() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            number: 2,
            title: 'Kapan dan di mana?',
            subtitle: 'Perkiraan saja juga tidak apa-apa.',
            color: RK.mint,
          ),
          const SizedBox(height: 16),
          RkField(
            label: 'Lokasi kejadian',
            hint: 'Contoh: kantin, kelas 8B, jalan pulang',
            icon: Icons.place_rounded,
            controller: _locationCtrl,
            maxLength: 120,
            textInputAction: TextInputAction.next,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Lokasi wajib diisi.' : null,
          ),
          const SizedBox(height: 14),
          RkField(
            label: 'Waktu kejadian',
            hint: 'Pilih tanggal dan jam',
            icon: Icons.event_rounded,
            controller: _timeCtrl,
            readOnly: true,
            onTap: _pickDateTime,
            suffix: const Icon(Icons.expand_more_rounded, color: RK.muted),
            validator: (v) {
              if (_occurredAt == null) return 'Waktu kejadian wajib diisi.';
              if (_occurredAt!.isAfter(DateTime.now())) {
                return 'Waktu kejadian tidak boleh di masa depan.';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChronologySection() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            number: 3,
            title: 'Ceritakan kejadiannya',
            subtitle: 'Siapa yang terlibat, apa yang dilakukan, dan sudah berapa lama.',
            color: RK.sun,
          ),
          const SizedBox(height: 16),
          RkField(
            label: 'Kronologi',
            hint: 'Tulis dengan bahasamu sendiri…',
            controller: _chronoCtrl,
            minLines: 5,
            maxLines: 9,
            maxLength: 2000,
            validator: (v) {
              final t = v?.trim() ?? '';
              if (t.isEmpty) return 'Kronologi wajib diisi.';
              if (t.length < 20) {
                return 'Ceritakan sedikit lebih detail (min. 20 karakter).';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEvidenceSection() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            number: 4,
            title: 'Bukti pendukung',
            subtitle:
                'Opsional · maks. $kMaxEvidence gambar · JPG/PNG/WEBP · 5 MB per gambar.',
            color: RK.rose,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (var i = 0; i < _evidence.length; i++) _evidenceThumb(i),
              if (_evidence.length < kMaxEvidence) _addEvidenceTile(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _addEvidenceTile() {
    return Semantics(
      button: true,
      label: 'Tambah gambar bukti',
      child: GestureDetector(
        onTap: _pickEvidence,
        child: Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: RK.white(0.5),
            border: Border.all(color: RK.tealSoft, width: 1.6),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_photo_alternate_rounded, color: RK.teal, size: 28),
              SizedBox(height: 4),
              Text(
                'Tambah',
                style: TextStyle(
                  color: RK.teal,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _evidenceThumb(int index) {
    final file = _evidence[index];
    return SizedBox(
      width: 88,
      height: 88,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.memory(
                file.bytes,
                fit: BoxFit.cover,
                semanticLabel: 'Bukti ${index + 1}',
              ),
            ),
          ),
          Positioned(
            top: -6,
            right: -6,
            child: Semantics(
              button: true,
              label: 'Hapus bukti ${index + 1}',
              child: GestureDetector(
                onTap: () => setState(() => _evidence.removeAt(index)),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: RK.navy,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.close_rounded,
                      color: Colors.white, size: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdentitySection() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            number: 5,
            title: 'Tampilkan namamu?',
            subtitle: 'Kamu yang menentukan.',
            color: RK.mint,
          ),
          const SizedBox(height: 16),
          IdentityOption(
            icon: Icons.visibility_off_rounded,
            title: 'Anonim',
            description:
                'Namamu tidak ditampilkan kepada guru BK yang meninjau.',
            selected: _identity == IdentityChoice.anonim,
            onTap: () => setState(() => _identity = IdentityChoice.anonim),
          ),
          const SizedBox(height: 12),
          IdentityOption(
            icon: Icons.badge_rounded,
            title: 'Tampilkan namaku',
            description: 'Guru BK bisa melihat namamu di laporan ini.',
            selected: _identity == IdentityChoice.nama,
            onTap: () => setState(() => _identity = IdentityChoice.nama),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyNote() {
    // Teks sementara: prosedur keadaan darurat masih TBD di PRD (Bab 12).
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: RK.white(0.45),
        border: Border.all(color: RK.white(0.8), width: 1.2),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.favorite_rounded, color: RK.teal, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Kalau kamu sedang dalam bahaya sekarang, segera cari orang dewasa '
              'yang kamu percaya atau hubungi 112. Laporan ini ditinjau guru BK, '
              'bukan layanan darurat.',
              style: TextStyle(color: RK.navy, fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------ dialog

class _SuccessDialog extends StatefulWidget {
  const _SuccessDialog({required this.code, this.failedEvidence = 0});

  final String code;
  final int failedEvidence;

  @override
  State<_SuccessDialog> createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<_SuccessDialog> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    if (mounted) setState(() => _copied = true);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF4EEF8), Color(0xFFE3F3F1)],
          ),
          border: Border.all(color: RK.white(0.9), width: 1.4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: const BoxDecoration(
                color: RK.teal,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded,
                  color: Colors.white, size: 38),
            ),
            const SizedBox(height: 16),
            const Text(
              'Laporanmu terkirim',
              style: TextStyle(
                color: RK.navy,
                fontWeight: FontWeight.w800,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Terima kasih sudah berani bersuara. Simpan kode ini untuk memantau status laporanmu.',
              textAlign: TextAlign.center,
              style: TextStyle(color: RK.muted, fontSize: 13.5, height: 1.4),
            ),
            const SizedBox(height: 18),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: RK.white(0.8),
                border: Border.all(color: RK.tealSoft, width: 1.4),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SelectableText(
                      widget.code,
                      style: const TextStyle(
                        color: RK.navy,
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Salin kode',
                    onPressed: _copy,
                    icon: Icon(
                      _copied ? Icons.check_rounded : Icons.copy_rounded,
                      color: RK.teal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: RK.sun,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'Status: Menunggu Ditinjau',
                style: TextStyle(
                  color: RK.navy,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5,
                ),
              ),
            ),
            if (widget.failedEvidence > 0) ...[
              const SizedBox(height: 12),
              Text(
                '${widget.failedEvidence} gambar bukti belum berhasil diunggah. '
                'Laporanmu tetap tersimpan; kamu bisa menyampaikan buktinya '
                'lewat konsultasi dengan guru BK.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: RK.error,
                  fontSize: 12.5,
                  height: 1.4,
                ),
              ),
            ],
            const SizedBox(height: 20),
            RkPrimaryButton(
              label: 'Selesai',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}