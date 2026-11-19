import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils.dart';

class BkReportActionPanel extends StatelessWidget {
  final bool hasBkSession;
  final bool hasPsychologistSession;
  final List<String> statusOptions;
  final String? selectedStatus;
  final ValueChanged<String?> onStatusChanged;
  final TextEditingController noteController;
  final VoidCallback onUpdateStatus;
  final VoidCallback onRefer;
  final VoidCallback? onChatBk;
  final VoidCallback? onChatPsychologist;

  const BkReportActionPanel({
    super.key,
    required this.hasBkSession,
    required this.hasPsychologistSession,
    required this.statusOptions,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.noteController,
    required this.onUpdateStatus,
    required this.onRefer,
    this.onChatBk,
    this.onChatPsychologist,
  });

  Widget _fieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon == null ? null : Icon(icon, size: 19),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.65),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      hintStyle: TextStyle(
        fontSize: 13,
        color: AppColors.ink.withValues(alpha: 0.4),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.ink.withValues(alpha: 0.08)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.ink.withValues(alpha: 0.10)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
      ),
    );
  }

  Widget _informationNote(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primaryDark,
            size: 19,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: AppColors.ink.withValues(alpha: 0.75),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required VoidCallback? onPressed,
    bool primary = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: primary
          ? FilledButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 19),
              label: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.primaryDark.withValues(
                  alpha: 0.4,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
            )
          : OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 19),
              label: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryDark,
                side: BorderSide(
                  color: AppColors.primaryDark.withValues(alpha: 0.25),
                ),
                backgroundColor: Colors.white.withValues(alpha: 0.35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!hasBkSession) ...[
          _informationNote(
            'Mengubah status untuk pertama kali akan menjadikan Anda '
            'penanggung jawab laporan ini dan membuka ruang konsultasi '
            'dengan siswa.',
          ),
          const SizedBox(height: 18),
        ],

        _fieldLabel('Status Laporan'),
        DropdownButtonFormField<String>(
          initialValue: selectedStatus,
          isExpanded: true,
          decoration: _inputDecoration(
            hint: 'Pilih status laporan',
            icon: Icons.flag_outlined,
          ),
          items: [
            for (final status in statusOptions)
              DropdownMenuItem(
                value: status,
                child: Text(
                  statusLabels[status] ?? status,
                  style: const TextStyle(fontSize: 13, color: AppColors.ink),
                ),
              ),
          ],
          onChanged: onStatusChanged,
        ),

        const SizedBox(height: 16),
        _fieldLabel('Catatan Tindak Lanjut'),
        TextField(
          controller: noteController,
          maxLines: 3,
          style: const TextStyle(fontSize: 13, color: AppColors.ink),
          decoration: _inputDecoration(
            hint: 'Tambahkan catatan untuk laporan ini (opsional)',
            icon: Icons.edit_note_rounded,
          ),
        ),

        const SizedBox(height: 18),
        _actionButton(
          label: 'Simpan Perubahan Status',
          icon: Icons.save_outlined,
          onPressed: onUpdateStatus,
          primary: true,
        ),

        if (hasBkSession) ...[
          const SizedBox(height: 20),
          Divider(height: 1, color: AppColors.ink.withValues(alpha: 0.08)),
          const SizedBox(height: 16),
          _fieldLabel('Aksi Pendampingan'),
          _actionButton(
            label: 'Konsultasi dengan Siswa',
            icon: Icons.chat_outlined,
            onPressed: onChatBk,
          ),
          const SizedBox(height: 10),
          _actionButton(
            label: 'Alihkan ke Psikolog',
            icon: Icons.support_agent_rounded,
            onPressed: onRefer,
          ),
        ],

        if (hasPsychologistSession) ...[
          const SizedBox(height: 10),
          _actionButton(
            label: 'Lihat Ruang Psikolog',
            icon: Icons.psychology_outlined,
            onPressed: onChatPsychologist,
          ),
        ],
      ],
    );
  }
}
