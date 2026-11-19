import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils.dart';
import '../../../data/models.dart';
import '../../../data/repository.dart';
import '../../../shared/layouts/app_background.dart';

import '../widgets/report_action_section.dart';
import '../widgets/report_chronology_card.dart';
import '../widgets/report_detail_header.dart';
import '../widgets/report_evidence_section.dart';
import '../widgets/report_history_section.dart';
import '../widgets/report_information_card.dart';
import '../widgets/psychologist_referral_dialog.dart';

class ReportDetailScreen extends StatefulWidget {
  final String reportId;
  final String role;

  const ReportDetailScreen({
    super.key,
    required this.reportId,
    required this.role,
  });

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  Report? _report;
  List<String> _evidenceUrls = [];
  List<HistoryItem> _history = [];

  ConsultSession? _bkSession;
  ConsultSession? _psychologistSession;

  bool _loading = true;
  String? _error;
  String? _newStatus;

  final TextEditingController _noteController = TextEditingController();

  bool get _isStaff => widget.role != 'siswa';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  // Memuat data laporan dan informasi pendukung.
  Future<void> _load() async {
    try {
      final report = await Repo.reportById(widget.reportId, staff: _isStaff);

      final (urls, history, bk, psychologist) = await (
        Repo.evidenceUrls(report.id),
        Repo.history(report.id),
        Repo.sessionFor(report.id, 'bk'),
        Repo.sessionFor(report.id, 'psikolog'),
      ).wait;

      if (!mounted) return;

      setState(() {
        _report = report;
        _evidenceUrls = urls;
        _history = history;
        _bkSession = bk;
        _psychologistSession = psychologist;
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

  // Membuka ruang konsultasi.
  void _openChat(ConsultSession session, String label) {
    context.push('/chat/${session.id}', extra: '$label • ${_report!.kode}');
  }

  // Memperbarui status laporan oleh Guru BK.
  Future<void> _updateStatus() async {
    if (_newStatus == null) {
      snack(context, 'Pilih status terlebih dahulu.');
      return;
    }

    try {
      final note = _noteController.text.trim();

      await Repo.updateStatus(
        _report!.id,
        _newStatus!,
        note.isEmpty ? null : note,
      );

      _noteController.clear();

      if (!mounted) return;

      snack(context, 'Status diperbarui.');
      await _load();
    } catch (e) {
      if (mounted) {
        snack(context, errMsg(e));
      }
    }
  }

  // Mengalihkan laporan kepada Psikolog.
  Future<void> _refer() async {
    try {
      final psychologists = await Repo.psychologists();

      if (!mounted) return;

      if (psychologists.isEmpty) {
        snack(context, 'Belum ada akun psikolog yang terdaftar.');
        return;
      }

      final result = await showDialog<Map<String, dynamic>>(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withValues(alpha: 0.13),
        builder: (_) =>
            PsychologistReferralDialog(psychologists: psychologists),
      );

      if (result == null) return;

      final psychologistId = result['psychologistId'] as String?;
      final note = result['note'] as String? ?? '';

      if (psychologistId == null) return;

      await Repo.referToPsychologist(
        _report!.id,
        psychologistId,
        note.isEmpty ? null : note,
      );

      if (!mounted) return;

      snack(context, 'Siswa dialihkan ke psikolog.');
      await _load();
    } catch (e) {
      if (mounted) {
        snack(context, errMsg(e));
      }
    }
  }

  // Membuka aplikasi telepon.
  Future<void> _callPsychologist(String phone) async {
    final success = await launchUrl(Uri(scheme: 'tel', path: phone));

    if (!success && mounted) {
      snack(context, 'Tidak dapat membuka aplikasi telepon.');
    }
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
        ),
      ),
    );
  }

  Widget _buildContent(Report report) {
    final phone = _psychologistSession?.psychologistPhone;

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
        children: [
          ReportDetailHeader(
            kode: report.kode,
            status: report.status,
            role: widget.role,
          ),

          _sectionTitle('Informasi Laporan'),
          ReportInformationCard(report: report),

          _sectionTitle('Kronologi Kejadian'),
          ReportChronologyCard(chronology: report.kronologi),

          if (_evidenceUrls.isNotEmpty) ...[
            _sectionTitle('Bukti Pendukung'),
            ReportEvidenceSection(urls: _evidenceUrls),
          ],

          _sectionTitle('Riwayat Penanganan'),
          ReportHistorySection(history: _history),

          _sectionTitle(
            widget.role == 'siswa'
                ? 'Konsultasi'
                : widget.role == 'guru_bk'
                ? 'Tindak Lanjut'
                : 'Pendampingan',
          ),

          ReportActionSection(
            role: widget.role,
            hasBkSession: _bkSession != null,
            hasPsychologistSession: _psychologistSession != null,
            statusOptions: const [
              'sedang_ditinjau',
              'dalam_penanganan',
              'selesai',
            ],
            selectedStatus: _newStatus,
            onStatusChanged: (value) {
              setState(() {
                _newStatus = value;
              });
            },
            noteController: _noteController,
            onUpdateStatus: _updateStatus,
            onRefer: _refer,
            onChatBk: _bkSession == null
                ? null
                : () => _openChat(_bkSession!, 'Siswa'),
            onChatPsychologist: _psychologistSession == null
                ? null
                : () => _openChat(
                    _psychologistSession!,
                    widget.role == 'siswa' ? 'Psikolog' : 'Siswa',
                  ),
            onCallPsychologist: phone == null || phone.isEmpty
                ? null
                : () => _callPsychologist(phone),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final report = _report;

    return Scaffold(
      backgroundColor: AppColors.landingBackground,
      body: SafeArea(
        child: AppBackground(
          child: _loading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : _error != null || report == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.cloud_off_outlined,
                          size: 48,
                          color: AppColors.primaryDark,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Gagal Memuat Detail Laporan',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _error ?? 'Data laporan tidak ditemukan.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              _loading = true;
                            });
                            _load();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  ),
                )
              : _buildContent(report),
        ),
      ),
    );
  }
}
