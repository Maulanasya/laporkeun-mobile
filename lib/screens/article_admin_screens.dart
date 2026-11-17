import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/utils.dart';
import '../data/models.dart';
import '../data/repository.dart';

class ArticleManageScreen extends StatefulWidget {
  const ArticleManageScreen({super.key});

  @override
  State<ArticleManageScreen> createState() => _ArticleManageScreenState();
}

class _ArticleManageScreenState extends State<ArticleManageScreen> {
  late Future<List<Article>> _future = Repo.articles(onlyPublished: false);

  void _reload() {
    setState(() {
      _future = Repo.articles(onlyPublished: false);
    });
  }

  Future<void> _delete(Article a) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus artikel?'),
        content: Text(a.judul),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Hapus')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await Repo.deleteArticle(a.id);
      _reload();
    } catch (e) {
      if (mounted) snack(context, errMsg(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Artikel')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/bk/artikel/form');
          _reload();
        },
        icon: const Icon(Icons.add),
        label: const Text('Artikel Baru'),
      ),
      body: FutureBuilder<List<Article>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) return Center(child: Text(errMsg(snap.error!)));
          final list = snap.data!;
          if (list.isEmpty) return const Center(child: Text('Belum ada artikel.'));
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 88),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final a = list[i];
              return ListTile(
                title: Text(a.judul),
                subtitle: Text('${a.status == 'terbit' ? 'Terbit' : 'Draft'} • ${fmtDate(a.tanggal)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () async {
                        await context.push('/bk/artikel/form', extra: a);
                        _reload();
                      },
                    ),
                    IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => _delete(a)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ArticleFormScreen extends StatefulWidget {
  final Article? article;
  const ArticleFormScreen({super.key, this.article});

  @override
  State<ArticleFormScreen> createState() => _ArticleFormScreenState();
}

class _ArticleFormScreenState extends State<ArticleFormScreen> {
  final _form = GlobalKey<FormState>();
  late final _judul = TextEditingController(text: widget.article?.judul);
  late final _ringkasan = TextEditingController(text: widget.article?.ringkasan);
  late final _isi = TextEditingController(text: widget.article?.isi);
  late final _cover = TextEditingController(text: widget.article?.cover);
  late bool _terbit = (widget.article?.status ?? 'terbit') == 'terbit';
  bool _saving = false;

  @override
  void dispose() {
    _judul.dispose();
    _ringkasan.dispose();
    _isi.dispose();
    _cover.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _saving = true;
    });
    try {
      await Repo.saveArticle(
        id: widget.article?.id,
        judul: _judul.text.trim(),
        ringkasan: _ringkasan.text.trim().isEmpty ? null : _ringkasan.text.trim(),
        isi: _isi.text.trim(),
        cover: _cover.text.trim().isEmpty ? null : _cover.text.trim(),
        terbit: _terbit,
      );
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) snack(context, errMsg(e));
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.article == null ? 'Artikel Baru' : 'Ubah Artikel')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _judul,
              decoration: const InputDecoration(labelText: 'Judul'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Judul wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ringkasan,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Ringkasan'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _isi,
              minLines: 8,
              maxLines: 20,
              decoration: const InputDecoration(labelText: 'Isi artikel', alignLabelWithHint: true),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Isi wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cover,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(labelText: 'URL gambar sampul (opsional)'),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Terbitkan'),
              subtitle: const Text('Jika dimatikan, artikel disimpan sebagai draft.'),
              value: _terbit,
              onChanged: (v) => setState(() {
                _terbit = v;
              }),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(_saving ? 'Menyimpan...' : 'Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}