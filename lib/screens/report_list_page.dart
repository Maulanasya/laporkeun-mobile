import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/utils.dart';
import '../data/auth_state.dart';
import '../data/models.dart';
import '../data/repository.dart';

class ReportListPage extends StatefulWidget {
  final String title, detailBase, emptyText;
  final Future<List<Report>> Function() loader;
  final String? createRoute;
  final List<Widget> extraActions;

  const ReportListPage({
    super.key,
    required this.title,
    required this.detailBase,
    required this.emptyText,
    required this.loader,
    this.createRoute,
    this.extraActions = const [],
  });

  @override
  State<ReportListPage> createState() => _ReportListPageState();
}

class _ReportListPageState extends State<ReportListPage> {
  late Future<List<Report>> _future = widget.loader();
  String? _filter;

  Future<void> _reload() async {
    setState(() {
      _future = widget.loader();
    });
    try {
      await _future;
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: 'Edukasi',
            icon: const Icon(Icons.menu_book_outlined),
            onPressed: () => context.go('/'),
          ),
          ...widget.extraActions,
          IconButton(
            tooltip: 'Keluar',
            icon: const Icon(Icons.logout),
            onPressed: () => auth.logout(),
          ),
        ],
      ),
      floatingActionButton: widget.createRoute == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () async {
                await context.push(widget.createRoute!);
                _reload();
              },
              icon: const Icon(Icons.add),
              label: const Text('Buat Laporan'),
            ),
      body: Column(
        children: [
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: const Text('Semua'),
                    selected: _filter == null,
                    onSelected: (_) => setState(() {
                      _filter = null;
                    }),
                  ),
                ),
                for (final e in statusLabels.entries)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(e.value),
                      selected: _filter == e.key,
                      onSelected: (_) => setState(() {
                        _filter = e.key;
                      }),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _reload,
              child: FutureBuilder<List<Report>>(
                future: _future,
                builder: (context, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snap.hasError) {
                    return ListView(children: [
                      Padding(padding: const EdgeInsets.all(24), child: Text(errMsg(snap.error!))),
                    ]);
                  }
                  final items = snap.data!.where((r) => _filter == null || r.status == _filter).toList();
                  if (items.isEmpty) {
                    return ListView(children: [
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(widget.emptyText, textAlign: TextAlign.center),
                      ),
                    ]);
                  }
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 88),
                    itemCount: items.length,
                    itemBuilder: (context, i) {
                      final r = items[i];
                      return Card(
                        child: ListTile(
                          onTap: () async {
                            await context.push('${widget.detailBase}/${r.id}');
                            _reload();
                          },
                          title: Text(r.kode, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(kategoriLabels[r.kategori] ?? r.kategori),
                              Text('${r.identitas} • ${fmtDate(r.createdAt)}'),
                              const SizedBox(height: 6),
                              StatusChip(r.status),
                            ],
                          ),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StudentHome extends StatelessWidget {
  const StudentHome({super.key});

  @override
  Widget build(BuildContext context) {
    return ReportListPage(
      title: 'Laporan Saya',
      detailBase: '/siswa/laporan',
      emptyText: 'Belum ada laporan.\nKetuk Buat Laporan untuk memulai.',
      loader: Repo.myReports,
      createRoute: '/siswa/lapor',
    );
  }
}

class BkHome extends StatelessWidget {
  const BkHome({super.key});

  @override
  Widget build(BuildContext context) {
    return ReportListPage(
      title: 'Laporan Masuk',
      detailBase: '/bk/laporan',
      emptyText: 'Belum ada laporan masuk.',
      loader: Repo.staffReports,
      extraActions: [
        IconButton(
          tooltip: 'Kelola Artikel',
          icon: const Icon(Icons.article_outlined),
          onPressed: () => context.push('/bk/artikel'),
        ),
      ],
    );
  }
}

class PsychologistHome extends StatelessWidget {
  const PsychologistHome({super.key});

  @override
  Widget build(BuildContext context) {
    return ReportListPage(
      title: 'Siswa Dampingan',
      detailBase: '/psikolog/laporan',
      emptyText: 'Belum ada siswa yang dialihkan kepada Anda.',
      loader: Repo.staffReports,
    );
  }
}