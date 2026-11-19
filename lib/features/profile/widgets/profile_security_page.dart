import 'package:flutter/material.dart';

import 'profile_page_header.dart';
import 'profile_security_section.dart';

class ProfileSecurityPage extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onChangePassword;
  final Widget footer;

  const ProfileSecurityPage({
    super.key,
    required this.onBack,
    required this.onChangePassword,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfilePageHeader(
          title: 'Keamanan Akun',
          subtitle: 'Kelola keamanan akses dan privasi akun LaporKeun!.',
          onBack: onBack,
        ),
        const SizedBox(height: 28),
        const SizedBox(height: 14),
        ProfileSecuritySection(onChangePassword: onChangePassword),
        const SizedBox(height: 25),
        footer,
      ],
    );
  }
}
