import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'profile_decorations.dart';
import 'profile_header.dart';
import 'profile_info_sections.dart';

class ProfileMainPage extends StatelessWidget {
  final String nama;
  final String email;
  final String role;
  final String? nis;

  final VoidCallback onBack;
  final VoidCallback onSettings;
  final VoidCallback onEdit;
  final VoidCallback onInformation;
  final VoidCallback onSecurity;
  final VoidCallback onLogout;

  final Widget footer;

  const ProfileMainPage({
    super.key,
    required this.nama,
    required this.email,
    required this.role,
    required this.nis,
    required this.onBack,
    required this.onSettings,
    required this.onEdit,
    required this.onInformation,
    required this.onSecurity,
    required this.onLogout,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ProfileGlassIconButton(
              icon: Icons.arrow_back_rounded,
              onTap: onBack,
            ),
            const Spacer(),
            ProfileGlassIconButton(
              icon: Icons.settings_outlined,
              onTap: onSettings,
            ),
          ],
        ),
        const SizedBox(height: 28),
        Text(
          'PENGATURAN AKUN',
          style: AppTextStyles.text(
            11,
            weight: FontWeight.w800,
            color: AppColors.primaryDark,
            letterSpacing: 1.8,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          'Profil saya',
          style: AppTextStyles.text(
            29,
            weight: FontWeight.w800,
            color: AppColors.ink,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          'Kelola informasi akun dan keamanan dalam satu tempat.',
          style: AppTextStyles.text(
            13,
            color: AppColors.ink.withValues(alpha: 0.65),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        ProfileAccountHeader(
          nama: nama,
          email: email,
          role: role,
          nis: nis,
          onEdit: onEdit,
        ),
        const SizedBox(height: 28),
        const ProfileSectionTitle(
          title: 'Menu pengaturan',
          subtitle: 'Informasi dan perlindungan akun',
        ),
        const SizedBox(height: 14),
        ProfileSettingMenuCard(
          icon: Icons.person_outline_rounded,
          iconColor: AppColors.primaryDark,
          iconBackground: AppColors.mint,
          title: 'Informasi profil',
          subtitle: 'Lihat informasi personal akun Anda',
          onTap: onInformation,
        ),
        const SizedBox(height: 11),
        ProfileSettingMenuCard(
          icon: Icons.shield_outlined,
          iconColor: AppColors.primaryDark,
          iconBackground: AppColors.mint,
          title: 'Keamanan akun',
          subtitle: 'Privasi dan perlindungan informasi akun',
          onTap: onSecurity,
        ),
        const SizedBox(height: 28),
        const ProfileAccountStatusCard(),
        const SizedBox(height: 26),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onLogout,
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Keluar dari akun'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFD65B67),
              side: const BorderSide(color: Color(0xFFE8B8BD)),
              backgroundColor: Colors.white.withValues(alpha: 0.65),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              textStyle: AppTextStyles.text(13, weight: FontWeight.w800),
            ),
          ),
        ),
        const SizedBox(height: 25),
        footer,
      ],
    );
  }
}
