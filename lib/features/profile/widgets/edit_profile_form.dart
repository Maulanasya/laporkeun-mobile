import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class EditProfileForm extends StatelessWidget {
  final TextEditingController namaController;
  final TextEditingController nisController;
  final TextEditingController teleponController;
  final VoidCallback onSave;
  final bool isLoading;

  const EditProfileForm({
    super.key,
    required this.namaController,
    required this.nisController,
    required this.teleponController,
    required this.onSave,
    this.isLoading = false,
  });

  InputDecoration _decoration({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.text(
        12,
        color: AppColors.ink.withValues(alpha: 0.38),
      ),
      prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
      filled: true,
      fillColor: AppColors.landingBackground.withValues(alpha: 0.48),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: AppColors.primary.withValues(alpha: 0.12),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: AppColors.primary.withValues(alpha: 0.12),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFD65B67)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFD65B67), width: 1.4),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.text(
            12,
            weight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 9),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          style: AppTextStyles.text(
            13,
            weight: FontWeight.w600,
            color: AppColors.ink,
          ),
          decoration: _decoration(hint: hint, icon: icon),
          validator: validator,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildField(
          label: 'Nama lengkap',
          hint: 'Masukkan nama lengkap',
          icon: Icons.person_outline_rounded,
          controller: namaController,
          textCapitalization: TextCapitalization.words,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Nama lengkap wajib diisi';
            }
            return null;
          },
        ),

        const SizedBox(height: 20),

        _buildField(
          label: 'NISN',
          hint: 'Masukkan NISN',
          icon: Icons.badge_outlined,
          controller: nisController,
          keyboardType: TextInputType.number,
        ),

        const SizedBox(height: 20),

        _buildField(
          label: 'Nomor telepon',
          hint: 'Masukkan nomor telepon',
          icon: Icons.phone_outlined,
          controller: teleponController,
          keyboardType: TextInputType.phone,
        ),

        const SizedBox(height: 28),

        // Tombol simpan
        SizedBox(
          height: 53,
          child: ElevatedButton(
            onPressed: isLoading ? null : onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.primary.withValues(
                alpha: 0.55,
              ),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 21,
                    height: 21,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.save_outlined, size: 19),
                      const SizedBox(width: 9),
                      Text(
                        'Simpan perubahan',
                        style: AppTextStyles.text(
                          13,
                          weight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
