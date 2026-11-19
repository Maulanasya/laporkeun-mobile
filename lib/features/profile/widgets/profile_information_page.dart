import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'profile_page_header.dart';
import 'profile_info_sections.dart';

class ProfileInformationPage extends StatelessWidget {
  final String nama;
  final String email;
  final String nis;
  final String noTelepon;
  final String role;
  final String tanggalBergabung;

  final VoidCallback onBack;
  final VoidCallback onEdit;
  final Widget footer;

  const ProfileInformationPage({
    super.key,
    required this.nama,
    required this.email,
    required this.nis,
    required this.noTelepon,
    required this.role,
    required this.tanggalBergabung,
    required this.onBack,
    required this.onEdit,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfilePageHeader(
          title: 'Informasi Profil',
          subtitle: 'Rincian informasi akun yang tersimpan pada sistem.',
          onBack: onBack,
        ),
        const SizedBox(height: 28),
        const SizedBox(height: 14),
        ProfileInfoCard(
          items: [
            ProfileInfoItem(
              icon: Icons.person_outline_rounded,
              label: 'Nama lengkap',
              value: nama,
            ),
            ProfileInfoItem(
              icon: Icons.email_outlined,
              label: 'Alamat email',
              value: email,
            ),
            ProfileInfoItem(
              icon: Icons.badge_outlined,
              label: 'NISN',
              value: nis,
            ),
            ProfileInfoItem(
              icon: Icons.phone_outlined,
              label: 'Nomor telepon',
              value: noTelepon,
            ),
            ProfileInfoItem(
              icon: Icons.groups_outlined,
              label: 'Peran akun',
              value: role,
            ),
            ProfileInfoItem(
              icon: Icons.calendar_month_outlined,
              label: 'Tanggal bergabung',
              value: tanggalBergabung,
            ),
          ],
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Edit informasi profil'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryDark,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: AppTextStyles.text(
                13,
                weight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),
          ),
        ),
        const SizedBox(height: 25),
        footer,
      ],
    );
  }
}
