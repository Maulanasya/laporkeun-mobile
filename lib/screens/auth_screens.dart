import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/utils.dart';
import '../data/auth_state.dart';

String? _required(String? v) => (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null;

String? _emailRule(String? v) {
  if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
  if (!v.contains('@') || !v.contains('.')) return 'Format email tidak valid';
  return null;
}

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
    setState(() {
      _busy = true;
    });
    try {
      await auth.login(_email.text.trim(), _pass.text);
      // Router otomatis mengarahkan ke dashboard sesuai peran.
    } catch (e) {
      if (mounted) snack(context, errMsg(e));
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Masuk')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.shield_outlined, size: 64, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 12),
                  Text(
                    'Selamat datang di LaporKeun!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: _emailRule,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _pass,
                    obscureText: _hide,
                    decoration: InputDecoration(
                      labelText: 'Kata sandi',
                      suffixIcon: IconButton(
                        icon: Icon(_hide ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() {
                          _hide = !_hide;
                        }),
                      ),
                    ),
                    validator: (v) => (v == null || v.isEmpty) ? 'Kata sandi wajib diisi' : null,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _busy ? null : _submit,
                    child: _busy
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Masuk'),
                  ),
                  TextButton(
                    onPressed: () => context.pushReplacement('/register'),
                    child: const Text('Belum punya akun? Daftar sebagai siswa'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
  final _pass2 = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _nama.dispose();
    _nis.dispose();
    _email.dispose();
    _pass.dispose();
    _pass2.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
    });
    try {
      final loggedIn = await auth.register(
        nama: _nama.text.trim(),
        nis: _nis.text.trim(),
        email: _email.text.trim(),
        password: _pass.text,
      );
      if (!loggedIn && mounted) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Periksa Email Kamu'),
            content: const Text('Akun berhasil dibuat. Buka tautan verifikasi yang dikirim ke emailmu, lalu masuk.'),
            actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
          ),
        );
        if (mounted) context.go('/login');
      }
    } catch (e) {
      if (mounted) snack(context, errMsg(e));
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Akun Siswa')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nama,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(labelText: 'Nama lengkap'),
                    validator: _required,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nis,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'NIS / NISN (opsional)'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: _emailRule,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _pass,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Kata sandi (minimal 8 karakter)'),
                    validator: (v) => (v == null || v.length < 8) ? 'Minimal 8 karakter' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _pass2,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Ulangi kata sandi'),
                    validator: (v) => v != _pass.text ? 'Kata sandi tidak sama' : null,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _busy ? null : _submit,
                    child: _busy
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Daftar'),
                  ),
                  TextButton(
                    onPressed: () => context.pushReplacement('/login'),
                    child: const Text('Sudah punya akun? Masuk'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}