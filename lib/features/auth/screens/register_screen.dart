import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils.dart';
import '../../../data/auth_state.dart';
import '../validators/auth_validators.dart';
import '../widgets/auth_layout.dart';
import '../widgets/auth_mascot.dart';
import '../widgets/auth_field.dart';
import '../widgets/auth_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();

  final _nama = TextEditingController();
  final _nis = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirmPass = TextEditingController();

  bool _busy = false;
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  @override
  void dispose() {
    _nama.dispose();
    _nis.dispose();
    _email.dispose();
    _pass.dispose();
    _confirmPass.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;

    setState(() => _busy = true);

    try {
      final success = await auth.register(
        nama: _nama.text.trim(),
        nis: _nis.text.trim(),
        email: _email.text.trim(),
        password: _pass.text,
      );

      if (!mounted) return;

      if (!success) {
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              icon: const Icon(
                Icons.mark_email_read_rounded,
                color: AppColors.primary,
                size: 48,
              ),
              title: const Text(
                'Periksa Email Kamu!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w800,
                ),
              ),
              content: Text(
                'Kami telah mengirimkan tautan verifikasi ke '
                '${_email.text.trim()}. '
                'Silakan periksa email kamu untuk mengaktifkan akun.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.ink.withValues(alpha: 0.7),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Mengerti'),
                ),
              ],
            );
          },
        );

        if (!mounted) return;

        context.go('/login');
      } else {
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        snack(context, errMsg(e));
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AuthMascot(size: 82),

            const SizedBox(height: 18),

            const Text(
              'Buat Akun Baru',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Bergabunglah dan mulai suarakan kepedulianmu.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: AppColors.ink.withValues(alpha: 0.58),
              ),
            ),

            const SizedBox(height: 26),

            const _AuthLabel('Nama Lengkap'),

            const SizedBox(height: 8),

            AuthField(
              controller: _nama,
              hint: 'Masukkan nama lengkap',
              icon: Icons.person_outline_rounded,
              textCapitalization: TextCapitalization.words,
              validator: requiredValidator,
            ),

            const SizedBox(height: 16),

            const _AuthLabel('NIS'),

            const SizedBox(height: 8),

            AuthField(
              controller: _nis,
              hint: 'Masukkan Nomor Induk Siswa',
              icon: Icons.badge_outlined,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),

            const _AuthLabel('Email'),

            const SizedBox(height: 8),

            AuthField(
              controller: _email,
              hint: 'Masukkan email kamu',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: emailValidator,
            ),

            const SizedBox(height: 16),

            const _AuthLabel('Password'),

            const SizedBox(height: 8),

            AuthField(
              controller: _pass,
              hint: 'Buat password',
              icon: Icons.lock_outline_rounded,
              obscureText: _hidePassword,
              validator: requiredValidator,
              suffix: IconButton(
                onPressed: () {
                  setState(() {
                    _hidePassword = !_hidePassword;
                  });
                },
                icon: Icon(
                  _hidePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.primaryDark.withValues(alpha: 0.7),
                  size: 19,
                ),
              ),
            ),

            const SizedBox(height: 16),

            const _AuthLabel('Konfirmasi Password'),

            const SizedBox(height: 8),

            AuthField(
              controller: _confirmPass,
              hint: 'Ulangi password',
              icon: Icons.lock_reset_rounded,
              obscureText: _hideConfirmPassword,
              validator: (value) {
                final requiredError = requiredValidator(value);

                if (requiredError != null) {
                  return requiredError;
                }

                if (value != _pass.text) {
                  return 'Password tidak sama';
                }

                return null;
              },
              suffix: IconButton(
                onPressed: () {
                  setState(() {
                    _hideConfirmPassword = !_hideConfirmPassword;
                  });
                },
                icon: Icon(
                  _hideConfirmPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.primaryDark.withValues(alpha: 0.7),
                  size: 19,
                ),
              ),
            ),

            const SizedBox(height: 26),

            AuthButton(
              label: 'Daftar Sekarang',
              icon: Icons.arrow_forward_rounded,
              loading: _busy,
              onTap: _submit,
            ),

            const SizedBox(height: 22),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sudah punya akun? ',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.ink.withValues(alpha: 0.65),
                  ),
                ),
                GestureDetector(
                  onTap: () => context.pushReplacement('/login'),
                  child: const Text(
                    'Masuk',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDark,
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
}

class _AuthLabel extends StatelessWidget {
  final String text;

  const _AuthLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
      ),
    );
  }
}
