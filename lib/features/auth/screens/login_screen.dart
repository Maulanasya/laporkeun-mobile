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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();

  bool _busy = false;
  bool _hide = true;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;

    setState(() => _busy = true);

    try {
      await auth.login(_email.text.trim(), _pass.text);

      if (mounted) {
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
            const AuthMascot(size: 92),

            const SizedBox(height: 20),

            const Text(
              'Selamat Datang!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Masuk ke akunmu dan mulai suarakan kepedulian.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: AppColors.ink.withValues(alpha: 0.58),
              ),
            ),

            const SizedBox(height: 28),

            const _AuthLabel('Email'),

            const SizedBox(height: 8),

            AuthField(
              controller: _email,
              hint: 'Masukkan email kamu',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: emailValidator,
            ),

            const SizedBox(height: 18),

            const _AuthLabel('Password'),

            const SizedBox(height: 8),

            AuthField(
              controller: _pass,
              hint: 'Masukkan password',
              icon: Icons.lock_outline_rounded,
              obscureText: _hide,
              validator: requiredValidator,
              suffix: IconButton(
                onPressed: () {
                  setState(() => _hide = !_hide);
                },
                icon: Icon(
                  _hide
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.primaryDark.withValues(alpha: 0.7),
                  size: 19,
                ),
              ),
            ),

            const SizedBox(height: 26),

            AuthButton(
              label: 'Masuk',
              icon: Icons.arrow_forward_rounded,
              loading: _busy,
              onTap: _submit,
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: Divider(color: AppColors.ink.withValues(alpha: 0.15)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'atau',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.ink.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(color: AppColors.ink.withValues(alpha: 0.15)),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Belum punya akun? ',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.ink.withValues(alpha: 0.65),
                  ),
                ),
                GestureDetector(
                  onTap: () => context.pushReplacement('/register'),
                  child: const Text(
                    'Daftar sekarang',
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
