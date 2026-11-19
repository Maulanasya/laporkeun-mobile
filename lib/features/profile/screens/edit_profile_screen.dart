import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/auth_state.dart';
import '../../../data/repository.dart';
import '../widgets/profile_decorations.dart';
import '../widgets/edit_profile_form.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _nisController = TextEditingController();
  final _teleponController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    final profile = auth.profile;

    _namaController.text = profile?.nama ?? '';
    _nisController.text = profile?.nis ?? '';
    _teleponController.text = profile?.noTelepon ?? '';
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nisController.dispose();
    _teleponController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await Repo.updateProfile(
        nama: _namaController.text,
        nis: _nisController.text,
        noTelepon: _teleponController.text,
      );

      await auth.refreshProfile();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil berhasil diperbarui'),
          backgroundColor: AppColors.primaryDark,
          behavior: SnackBarBehavior.floating,
        ),
      );

      context.pop();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui profil: $e'),
          backgroundColor: const Color(0xFFD65B67),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _formatRole(String? role) {
    switch (role?.toLowerCase()) {
      case 'siswa':
        return 'Siswa';
      case 'guru_bk':
        return 'BK';
      case 'psikolog':
        return 'Psikolog';
      default:
        return role ?? '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = auth.profile;
    final email = sb.auth.currentUser?.email ?? '-';

    return Scaffold(
      backgroundColor: AppColors.landingBackground,
      body: SafeArea(
        child: Stack(
          children: [
            // Dekorasi background
            Positioned(
              top: -65,
              right: -65,
              child: ProfileDecorationCircle(
                size: 190,
                color: AppColors.primary.withValues(alpha: 0.13),
              ),
            ),
            Positioned(
              top: 390,
              left: -90,
              child: ProfileDecorationCircle(
                size: 160,
                color: AppColors.mint.withValues(alpha: 0.4),
              ),
            ),

            // Konten halaman
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Navigasi atas
                  Row(
                    children: [
                      ProfileGlassIconButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: () => context.pop(),
                      ),
                      const Spacer(),
                      ProfileGlassIconButton(
                        icon: Icons.edit_note_rounded,
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Judul halaman
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
                    'Edit Profil',
                    style: AppTextStyles.text(
                      29,
                      weight: FontWeight.w800,
                      color: AppColors.ink,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Perbarui informasi pribadimu agar '
                    'data akun selalu sesuai dan terbaru.',
                    style: AppTextStyles.text(
                      13,
                      color: AppColors.ink.withValues(alpha: 0.65),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Informasi akun
                  const _EditSectionTitle(
                    title: 'Informasi akun',
                    subtitle: 'Identitas akun yang terdaftar',
                  ),
                  const SizedBox(height: 14),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(19),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.85),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.ink.withValues(alpha: 0.045),
                              blurRadius: 22,
                              offset: const Offset(0, 9),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _AccountInfoRow(
                              icon: Icons.email_outlined,
                              label: 'Alamat email',
                              value: email,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Divider(
                                height: 1,
                                color: AppColors.ink.withValues(alpha: 0.08),
                              ),
                            ),
                            _AccountInfoRow(
                              icon: Icons.groups_outlined,
                              label: 'Peran akun',
                              value: _formatRole(profile?.role),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Form profil
                  const _EditSectionTitle(
                    title: 'Informasi pribadi',
                    subtitle: 'Data pribadi yang dapat kamu perbarui',
                  ),
                  const SizedBox(height: 14),

                  Form(
                    key: _formKey,
                    child: EditProfileForm(
                      namaController: _namaController,
                      nisController: _nisController,
                      teleponController: _teleponController,
                      isLoading: _isLoading,
                      onSave: _saveProfile,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Catatan
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.48),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          color: AppColors.primaryDark,
                          size: 20,
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Text(
                            'Alamat email dan peran akun tidak dapat '
                            'diubah melalui halaman ini untuk menjaga '
                            'keamanan akun.',
                            style: AppTextStyles.text(
                              11,
                              color: AppColors.ink.withValues(alpha: 0.75),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  Center(
                    child: Text(
                      'LaporKeun! · Ruang aman, tanpa takut bersuara.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.text(
                        10,
                        color: AppColors.ink.withValues(alpha: 0.48),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Judul setiap bagian
class _EditSectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _EditSectionTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.text(
            16,
            weight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: AppTextStyles.text(
            11,
            color: AppColors.ink.withValues(alpha: 0.58),
          ),
        ),
      ],
    );
  }
}

// Informasi akun yang hanya bisa dibaca
class _AccountInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _AccountInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.mint.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: AppColors.primaryDark, size: 19),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.text(
                  10,
                  color: AppColors.ink.withValues(alpha: 0.55),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.text(
                  13,
                  weight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.lock_outline_rounded,
          color: AppColors.primaryDark,
          size: 16,
        ),
      ],
    );
  }
}
