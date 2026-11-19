import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_glass_card.dart';

class PsychologistReferralDialog extends StatefulWidget {
  final List<Map<String, dynamic>> psychologists;

  const PsychologistReferralDialog({super.key, required this.psychologists});

  @override
  State<PsychologistReferralDialog> createState() =>
      _PsychologistReferralDialogState();
}

class _PsychologistReferralDialogState
    extends State<PsychologistReferralDialog> {
  late String? _psychologistId;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _psychologistId = widget.psychologists.first['id'] as String;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_psychologistId == null) return;

    Navigator.pop(context, {
      'psychologistId': _psychologistId,
      'note': _noteController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: AppGlassCard(
        borderRadius: 24,
        padding: const EdgeInsets.all(22),
        backgroundColor: Colors.white.withValues(alpha: 0.90),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.psychology_outlined,
                  color: AppColors.primaryDark,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Alihkan ke Psikolog',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                ),
              ),
            ),
            const SizedBox(height: 7),
            Text(
              'Pilih psikolog yang akan menangani siswa dan tambahkan catatan pengalihan jika diperlukan.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: AppColors.ink.withValues(alpha: 0.65),
              ),
            ),
            const SizedBox(height: 22),

            const Text(
              'Psikolog Tujuan',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _psychologistId,
              isExpanded: true,
              decoration: _inputDecoration(
                prefixIcon: const Icon(Icons.person_outline_rounded),
              ),
              items: [
                for (final psychologist in widget.psychologists)
                  DropdownMenuItem(
                    value: psychologist['id'] as String,
                    child: Text(
                      psychologist['nama'] as String,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: (value) {
                setState(() => _psychologistId = value);
              },
            ),

            const SizedBox(height: 17),
            const Text(
              'Catatan Pengalihan',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: _inputDecoration(
                hintText: 'Alasan atau catatan penilaian (opsional)',
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _psychologistId == null ? null : _submit,
                    icon: const Icon(Icons.send_rounded, size: 17),
                    label: const Text('Alihkan'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    Widget? prefixIcon,
    String? hintText,
    bool alignLabelWithHint = false,
  }) {
    return InputDecoration(
      prefixIcon: prefixIcon,
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: 12,
        color: AppColors.ink.withValues(alpha: 0.4),
      ),
      alignLabelWithHint: alignLabelWithHint,
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.7),
      contentPadding: const EdgeInsets.all(14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.ink.withValues(alpha: 0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
      ),
    );
  }
}
