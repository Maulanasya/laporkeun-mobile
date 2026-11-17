import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/theme.dart';
import 'core/utils.dart';
import 'data/auth_state.dart';
import 'data/models.dart';
import 'screens/article_admin_screens.dart';
import 'screens/auth_screens.dart';
import 'screens/chat_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/report_detail_screen.dart';
import 'screens/report_form_screen.dart';
import 'screens/report_list_page.dart';

class LaporKeunApp extends StatelessWidget {
  final GoRouter router;
  const LaporKeunApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'LaporKeun!',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      routerConfig: router,
    );
  }
}

GoRouter buildRouter(AuthState auth) {
  return GoRouter(
    initialLocation: auth.loggedIn ? homeFor(auth.role) : '/',
    refreshListenable: auth,
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final isAuthPage = loc == '/login' || loc == '/register';
      final pathRole = loc.startsWith('/siswa')
          ? 'siswa'
          : loc.startsWith('/bk')
              ? 'guru_bk'
              : loc.startsWith('/psikolog')
                  ? 'psikolog'
                  : null;

      if (!auth.loggedIn) {
        return (pathRole != null || loc.startsWith('/chat')) ? '/login' : null;
      }
      if (isAuthPage) return homeFor(auth.role);
      if (pathRole != null && pathRole != auth.role) return homeFor(auth.role);
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (c, s) => const LandingScreen()),
      GoRoute(
        path: '/artikel/:id',
        builder: (c, s) => ArticleDetailScreen(id: s.pathParameters['id']!),
      ),
      GoRoute(path: '/login', builder: (c, s) => const LoginScreen()),
      GoRoute(path: '/register', builder: (c, s) => const RegisterScreen()),

      // Siswa
      GoRoute(path: '/siswa', builder: (c, s) => const StudentHome()),
      GoRoute(path: '/siswa/lapor', builder: (c, s) => const ReportFormScreen()),
      GoRoute(
        path: '/siswa/laporan/:id',
        builder: (c, s) => ReportDetailScreen(reportId: s.pathParameters['id']!, role: 'siswa'),
      ),

      // Guru BK
      GoRoute(path: '/bk', builder: (c, s) => const BkHome()),
      GoRoute(
        path: '/bk/laporan/:id',
        builder: (c, s) => ReportDetailScreen(reportId: s.pathParameters['id']!, role: 'guru_bk'),
      ),
      GoRoute(path: '/bk/artikel', builder: (c, s) => const ArticleManageScreen()),
      GoRoute(
        path: '/bk/artikel/form',
        builder: (c, s) => ArticleFormScreen(article: s.extra as Article?),
      ),

      // Psikolog
      GoRoute(path: '/psikolog', builder: (c, s) => const PsychologistHome()),
      GoRoute(
        path: '/psikolog/laporan/:id',
        builder: (c, s) => ReportDetailScreen(reportId: s.pathParameters['id']!, role: 'psikolog'),
      ),

      // Chat (semua peran; akses sesi dibatasi RLS)
      GoRoute(
        path: '/chat/:sid',
        builder: (c, s) => ChatScreen(
          sessionId: s.pathParameters['sid']!,
          title: (s.extra as String?) ?? 'Konsultasi',
        ),
      ),
    ],
  );
}