import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/repository.dart';

Future<void> showChangePasswordDialog(BuildContext context) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const ChangePasswordDialog(),
  );
}

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();

  final _oldPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscureOldPassword = true;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final messenger = ScaffoldMessenger.of(context);

    try {
      final email = sb.auth.currentUser?.email;

      if (email == null || email.isEmpty) {
        throw Exception('Email akun tidak ditemukan');
      }

      // Verifikasi kata sandi lama.
      await sb.auth.signInWithPassword(
        email: email,
        password: _oldPasswordController.text,
      );

      // Perbarui kata sandi.
      await sb.auth.updateUser(
        UserAttributes(password: _passwordController.text),
      );

      if (!mounted) return;

      Navigator.of(context).pop();

      messenger.showSnackBar(
        const SnackBar(
          content: Text('Kata sandi berhasil diperbarui'),
          backgroundColor: AppColors.primaryDark,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Kata sandi lama salah atau gagal memperbarui kata sandi.',
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      title: Text(
        'Ganti kata sandi',
        style: AppTextStyles.text(
          18,
          weight: FontWeight.w800,
          color: AppColors.ink,
        ),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPasswordField(
              controller: _oldPasswordController,
              label: 'Kata sandi lama',
              obscure: _obscureOldPassword,
              onToggle: () {
                setState(() {
                  _obscureOldPassword = !_obscureOldPassword;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kata sandi lama wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            _buildPasswordField(
              controller: _passwordController,
              label: 'Kata sandi baru',
              obscure: _obscurePassword,
              onToggle: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kata sandi wajib diisi';
                }

                if (value.length < 8) {
                  return 'Minimal 8 karakter';
                }

                if (value == _oldPasswordController.text) {
                  return 'Gunakan kata sandi yang berbeda';
                }

                return null;
              },
            ),
            const SizedBox(height: 14),
            _buildPasswordField(
              controller: _confirmController,
              label: 'Konfirmasi kata sandi',
              obscure: _obscureConfirm,
              onToggle: () {
                setState(() {
                  _obscureConfirm = !_obscureConfirm;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Konfirmasi kata sandi wajib diisi';
                }

                if (value != _passwordController.text) {
                  return 'Kata sandi tidak sama';
                }

                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _submit,
          style: FilledButton.styleFrom(backgroundColor: AppColors.primaryDark),
          child: _isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Simpan'),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(
            obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          ),
        ),
      ),
    );
  }
}
