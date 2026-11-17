import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/utils.dart';
import '../data/auth_state.dart';
import '../data/models.dart';
import '../data/repository.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  late Future<List<Article>> _articles = Repo.articles();

  Future<void> _refresh() async {
    setState(() {
      _articles = Repo.articles();
    });
    try {
      await _articles;
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return ListenableBuilder(
      listenable: auth,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: const Text('LaporKeun!'),
          actions: auth.loggedIn
              ? [
                  TextButton(
                    onPressed: () => context.go(homeFor(auth.role)),
                    child: const Text('Dashboard'),
                  ),
                ]
              : [
                  TextButton(onPressed: () => context.push('/login'), child: const Text('Masuk')),
                  TextButton(onPressed: () => context.push('/register'), child: const Text('Daftar')),
                ],
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Berani bersuara, kamu tidak sendirian.',
                      style: tt.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'LaporKeun! adalah platform pelaporan perundungan dan pendampingan siswa. '
                      'Lapor dengan nama atau anonim, pantau perkembangannya, dan berkonsultasi '
                      'dengan guru BK maupun psikolog.',
                      style: TextStyle(color: cs.onPrimaryContainer),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => auth.loggedIn
                          ? context.go(homeFor(auth.role))
                          : context.push('/register'),
                      icon: const Icon(Icons.edit_note),
                      label: Text(auth.loggedIn ? 'Buka Dashboard' : 'Mulai Melapor'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text('Layanan Utama', style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const _Feature(
                icon: Icons.lock_outline,
                title: 'Lapor dengan aman',
                text: 'Pilih menampilkan nama atau melapor secara anonim.',
              ),
              const _Feature(
                icon: Icons.timeline,
                title: 'Pantau perkembangan',
                text: 'Lihat status laporanmu dari ditinjau sampai selesai.',
              ),
              const _Feature(
                icon: Icons.forum_outlined,
                title: 'Konsultasi pendampingan',
                text: 'Berkonsultasi dengan guru BK, dan dengan psikolog bila diperlukan.',
              ),
              Card(
                color: cs.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Jika kamu atau orang lain berada dalam bahaya langsung, segera hubungi '
                    'orang dewasa yang kamu percaya atau nomor darurat 112.',
                    style: TextStyle(color: cs.onErrorContainer),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Edukasi Perundungan', style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              FutureBuilder<List<Article>>(
                future: _articles,
                builder: (context, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (snap.hasError) return Text(errMsg(snap.error!));
                  final list = snap.data!;
                  if (list.isEmpty) return const Text('Belum ada artikel.');
                  return Column(
                    children: [
                      for (final a in list)
                        Card(
                          child: ListTile(
                            isThreeLine: true,
                            title: Text(a.judul, style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text(
                              '${a.ringkasan ?? ''}\n${fmtDate(a.tanggal)}',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => context.push('/artikel/${a.id}'),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  final IconData icon;
  final String title, text;
  const _Feature({required this.icon, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(leading: Icon(icon), title: Text(title), subtitle: Text(text)),
    );
  }
}

class ArticleDetailScreen extends StatelessWidget {
  final String id;
  const ArticleDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Artikel')),
      body: FutureBuilder<Article>(
        future: Repo.articleById(id),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) return Center(child: Text(errMsg(snap.error!)));
          final a = snap.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (a.cover != null && a.cover!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      a.cover!,
                      errorBuilder: (context, error, stack) => const SizedBox.shrink(),
                    ),
                  ),
                ),
              Text(a.judul, style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(fmtDate(a.tanggal), style: tt.bodySmall),
              if (a.ringkasan != null) ...[
                const SizedBox(height: 12),
                Text(a.ringkasan!, style: tt.titleSmall),
              ],
              const Divider(height: 32),
              SelectableText(a.isi, style: const TextStyle(height: 1.6)),
            ],
          );
        },
      ),
    );
  }
}