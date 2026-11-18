import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ProfileSecuritySection extends StatelessWidget {
  final VoidCallback onChangePassword;

  const ProfileSecuritySection({super.key, required this.onChangePassword});

  Widget _buildSecurityCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
    required String title,
    required Widget content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.ink.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: iconColor, size: 21),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.text(
                    14,
                    weight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          content,
        ],
      ),
    );
  }

  Widget _description(String text) {
    return Text(
      text,
      style: AppTextStyles.text(
        12,
        color: AppColors.ink.withValues(alpha: 0.7),
        height: 1.6,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSecurityCard(
          icon: Icons.lock_outline_rounded,
          iconColor: AppColors.primaryDark,
          iconBackground: AppColors.mint,
          title: 'Privasi Informasi',
          content: _description(
            'Privasi Anda merupakan hal penting bagi LaporKeun. '
            'Informasi akun digunakan untuk mendukung layanan, '
            'pengelolaan akun, dan pengalaman penggunaan aplikasi. '
            'Kami berupaya menjaga informasi pribadi Anda.',
          ),
        ),

        const SizedBox(height: 13),

        _buildSecurityCard(
          icon: Icons.password_rounded,
          iconColor: AppColors.primaryDark,
          iconBackground: AppColors.mint,
          title: 'Kata Sandi',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _description(
                'Gunakan kata sandi yang kuat dan berbeda dari '
                'akun lain. Kata sandi sebaiknya memiliki minimal '
                '8 karakter agar akun lebih terlindungi.',
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onChangePassword,
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Ganti kata sandi'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: AppTextStyles.text(12, weight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 13),

        _buildSecurityCard(
          icon: Icons.visibility_off_outlined,
          iconColor: AppColors.primaryDark,
          iconBackground: AppColors.mint,
          title: 'Anonimitas Laporan',
          content: _description(
            'Anonimitas diatur pada setiap laporan yang Anda '
            'buat, bukan sebagai pengaturan umum pada akun. '
            'Pilihan anonimitas disimpan melalui kolom isAnonim '
            'pada data masing-masing laporan. Dengan demikian, '
            'Anda dapat menentukan anonimitas secara terpisah '
            'untuk setiap laporan.',
          ),
        ),
      ],
    );
  }
}
