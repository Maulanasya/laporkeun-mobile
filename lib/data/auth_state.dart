import 'package:flutter/foundation.dart';

import 'models.dart';
import 'repository.dart';

class AuthState extends ChangeNotifier {
  Profile? profile;

  bool get loggedIn => sb.auth.currentSession != null && profile != null;
  String get role => profile?.role ?? '';

  Future<void> init() async {
    await _loadProfile();
    sb.auth.onAuthStateChange.listen((_) async {
      await _loadProfile();
      notifyListeners();
    });
  }

  Future<void> _loadProfile() async {
    final user = sb.auth.currentUser;
    if (user == null) {
      profile = null;
      return;
    }
    try {
      final row = await sb
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();
      profile = row == null ? null : Profile.fromMap(row);
    } catch (_) {
      profile = null;
    }
  }

  Future<void> login(String email, String password) async {
    await sb.auth.signInWithPassword(email: email, password: password);
    await _loadProfile();
    notifyListeners();
  }

  /// Mengembalikan false jika Supabase meminta verifikasi email terlebih dahulu.
  Future<bool> register({
    required String nama,
    String? nis,
    required String email,
    required String password,
  }) async {
    final res = await sb.auth.signUp(
      email: email,
      password: password,
      data: {'nama': nama, 'nis': nis ?? ''},
    );
    if (res.session == null) return false;
    await _loadProfile();
    notifyListeners();
    return true;
  }

  Future<void> refreshProfile() async {
    await _loadProfile();
    notifyListeners();
  }

  Future<void> logout() async {
    await sb.auth.signOut();
    profile = null;
    notifyListeners();
  }
}

final auth = AuthState();
