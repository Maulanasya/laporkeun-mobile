import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/auth_state.dart';
import '../../../data/repository.dart';

import '../widgets/profile_decorations.dart';
import '../widgets/change_password_dialog.dart';
import '../widgets/profile_information_page.dart';
import '../widgets/profile_security_page.dart';
import '../widgets/profile_main_page.dart';

enum ProfilePage { main, information, security }

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfilePage _currentPage = ProfilePage.main;

  void _openPage(ProfilePage page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _backToMain() {
    setState(() {
      _currentPage = ProfilePage.main;
    });
  }

  String _formatRole(String role) {
    switch (role.toLowerCase()) {
      case 'siswa':
        return 'Siswa';
      case 'guru_bk':
        return 'BK';
      case 'psikolog':
        return 'Psikolog';
      default:
        return role.isEmpty ? 'Pengguna' : role;
    }
  }

  String _formatDate(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) return '-';

    final date = DateTime.tryParse(createdAt);
    if (date == null) return '-';

    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Keluar dari akun?'),
        content: const Text(
          'Apakah kamu yakin ingin keluar dari akun LaporKeun?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (confirm != true || !context.mounted) return;

    try {
      await auth.logout();

      if (context.mounted) {
        context.go('/login');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal logout: $e')));
      }
    }
  }

  // HALAMAN UTAMA PROFIL

  Widget _buildMainPage({
    required dynamic profile,
    required String email,
    required User? user,
  }) {
    return ProfileMainPage(
      nama: profile.nama,
      email: email,
      role: _formatRole(profile.role),
      nis: profile.nis,
      onBack: () => context.pop(),
      onSettings: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pengaturan akun ditampilkan di halaman ini.'),
          ),
        );
      },
      onEdit: () => context.push('/edit-profile'),
      onInformation: () => _openPage(ProfilePage.information),
      onSecurity: () => _openPage(ProfilePage.security),
      onLogout: () => _logout(context),
      onRoleMenu: () {
        switch (profile.role.toLowerCase()) {
          case 'siswa':
            context.push('/siswa');
            break;
          case 'guru_bk':
            context.push('/bk');
            break;
          case 'psikolog':
            context.push('/psikolog');
            break;
        }
      },
      footer: _footer(),
    );
  }

  // HALAMAN INFORMASI PROFIL
  Widget _buildInformationPage({
    required dynamic profile,
    required String email,
    required User? user,
  }) {
    return ProfileInformationPage(
      nama: profile.nama,
      email: email,
      nis: profile.nis?.isNotEmpty == true ? profile.nis! : '-',
      noTelepon: profile.noTelepon?.isNotEmpty == true
          ? profile.noTelepon!
          : '-',
      role: _formatRole(profile.role),
      tanggalBergabung: _formatDate(user?.createdAt),
      onBack: _backToMain,
      onEdit: () => context.push('/edit-profile'),
      footer: _footer(),
    );
  }

  // HALAMAN KEAMANAN AKUN
  Widget _buildSecurityPage() {
    return ProfileSecurityPage(
      onBack: _backToMain,
      onChangePassword: () => showChangePasswordDialog(context),
      footer: _footer(),
    );
  }

  Widget _footer() {
    return Center(
      child: Text(
        'LaporKeun! · Ruang aman, tanpa takut bersuara.',
        textAlign: TextAlign.center,
        style: AppTextStyles.text(
          10,
          color: AppColors.ink.withValues(alpha: 0.48),
        ),
      ),
    );
  }

  Widget _buildBackground(Widget child) {
    return Stack(
      children: [
        Positioned(
          top: -65,
          right: -65,
          child: ProfileDecorationCircle(
            size: 190,
            color: AppColors.primary.withValues(alpha: 0.13),
          ),
        ),
        Positioned(
          top: 350,
          left: -90,
          child: ProfileDecorationCircle(
            size: 160,
            color: AppColors.mint.withValues(alpha: 0.4),
          ),
        ),
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: child,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: auth,
      builder: (context, child) {
        final profile = auth.profile;
        final user = sb.auth.currentUser;
        final email = user?.email ?? '-';

        if (profile == null) {
          return Scaffold(
            backgroundColor: AppColors.landingBackground,
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.person_off_outlined,
                        size: 54,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Data profil belum tersedia',
                        style: AppTextStyles.text(18, weight: FontWeight.w800),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Informasi akun belum dapat dimuat. '
                        'Silakan coba login kembali.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.text(
                          13,
                          color: AppColors.ink.withValues(alpha: 0.65),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: () => context.pop(),
                        child: const Text('Kembali'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        Widget page;

        switch (_currentPage) {
          case ProfilePage.main:
            page = KeyedSubtree(
              key: const ValueKey('profile-main'),
              child: _buildMainPage(profile: profile, email: email, user: user),
            );
            break;

          case ProfilePage.information:
            page = KeyedSubtree(
              key: const ValueKey('profile-information'),
              child: _buildInformationPage(
                profile: profile,
                email: email,
                user: user,
              ),
            );
            break;

          case ProfilePage.security:
            page = KeyedSubtree(
              key: const ValueKey('profile-security'),
              child: _buildSecurityPage(),
            );
            break;
        }

        return Scaffold(
          backgroundColor: AppColors.landingBackground,
          body: SafeArea(child: _buildBackground(page)),
        );
      },
    );
  }
}
