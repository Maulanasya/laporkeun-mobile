import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/utils.dart';
import '../data/auth_state.dart';
import '../data/models.dart';
import '../data/repository.dart';

// Palet warna tema "Fajar Tenang"
const Color _ink = Color(0xFF023346);
const Color _teal = Color(0xFF3191A0);
const Color _tealDeep = Color(0xFF17707D);
const Color _danger = Color(0xFFEA2143);
const Color _lavender = Color(0xFFDAD6F3);
const Color _peach = Color(0xFFFFD9C2);
const Color _mint = Color(0xFFCDEAE4);
const Color _pink = Color(0xFFF3D3DB);
const Color _lemon = Color(0xFFFFEBB8);
const Color _rose = Color(0xFFE8A0A6);

/// Helper tipografi standar untuk menjaga konsistensi gaya teks di seluruh halaman.
TextStyle _t(
  double size, {
  FontWeight w = FontWeight.w600,
  Color color = _ink,
  double height = 1.35,
  double ls = 0,
}) {
  return TextStyle(
    fontSize: size,
    fontWeight: w,
    color: color,
    height: height,
    letterSpacing: ls,
  );
}

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  static const String _logoAssetPath = 'assets/images/logo.png';

  /// Gambar cadangan apabila artikel dari backend tidak menyertakan URL cover.
  static const List<String> _fallbackCovers = [
    'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1509062522246-3755977927d7?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1573497019940-1c28c88b4f3e?auto=format&fit=crop&w=800&q=80',
  ];

  late Future<List<Article>> _articles = Repo.articles();
  final TextEditingController _kodeController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Key referensi untuk navigasi gulir otomatis (smooth scroll) dari bottom bar
  final GlobalKey _edukasiKey = GlobalKey();
  final GlobalKey _bantuanKey = GlobalKey();

  bool _showAllArticles = false;
  int _navIndex = 0;

  @override
  void dispose() {
    _kodeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    setState(() {
      _articles = Repo.articles();
    });
    try {
      await _articles;
    } catch (_) {}
  }

  void _scrollToSection(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _toast(String msg, {SnackBarAction? action}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _ink,
        content: Text(msg, style: const TextStyle(color: Colors.white)),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        action: action,
      ),
    );
  }

  /// Validasi input kode laporan dan arahkan pengguna sesuai status autentikasi.
  void _handleCekKodeLaporan() {
    final kode = _kodeController.text.trim();
    if (kode.isEmpty) {
      _toast('Masukkan kode laporan terlebih dahulu.');
      return;
    }
    if (auth.loggedIn) {
      context.go(homeFor(auth.role));
    } else {
      _toast(
        'Masuk dulu untuk melihat status kode "$kode".',
        action: SnackBarAction(
          label: 'Masuk',
          textColor: _peach,
          onPressed: () => context.push('/login'),
        ),
      );
    }
  }

  /// Mengarahkan ke dashboard sesuai role jika sudah login, atau ke rute auth jika belum.
  void _navigateProtected(String loggedOutRoute) {
    if (auth.loggedIn) {
      context.go(homeFor(auth.role));
    } else {
      context.push(loggedOutRoute);
    }
  }

  Widget _pad(Widget child) =>
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: child);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: auth,
      builder: (context, _) => Scaffold(
        backgroundColor: const Color(0xFFEFECFA),
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            const Positioned.fill(child: _PageBackdrop()),
            RefreshIndicator(
              color: _teal,
              onRefresh: _refresh,
              child: ListView(
                controller: _scrollController,
                // Beri ruang ekstra di bawah agar konten terakhir tidak tertutup floating bottom nav
                padding: const EdgeInsets.only(bottom: 140),
                children: [
                  _buildHero(context),
                  _pad(_buildSearchHint()),
                  const SizedBox(height: 22),
                  _pad(_buildAnonymousCard()),
                  const SizedBox(height: 30),
                  _pad(_buildFeatureCircles()),
                  const SizedBox(height: 34),
                  _pad(_buildHowItWorks()),
                  const SizedBox(height: 22),
                  _pad(_buildPrivacyCard()),
                  const SizedBox(height: 34),
                  _pad(_buildArticles()),
                  const SizedBox(height: 22),
                  _pad(_buildEmergency()),
                  const SizedBox(height: 34),
                  _pad(_buildFaq()),
                  const SizedBox(height: 24),
                  _pad(_buildCta()),
                  const SizedBox(height: 22),
                  _buildFooter(),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  // ===========================================================================
  // BAGIAN KONTEN UTAMA
  // ===========================================================================

  Widget _buildHero(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final sceneH = 350.0 + top;

    return Stack(
      children: [
        // Latar ilustrasi fajar dengan sudut bawah melengkung
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: sceneH,
          child: const ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(38)),
            child: CustomPaint(painter: _CalmDawnPainter()),
          ),
        ),

        // Header logo & tombol aksi akun
        Positioned(
          top: top + 10,
          left: 20,
          right: 20,
          child: Row(
            children: [
              _Glass(
                radius: 14,
                opacity: 0.55,
                blur: 14,
                padding: const EdgeInsets.all(6),
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: Image.asset(
                    _logoAssetPath,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const _Mascot(size: 24),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text('LaporKeun!', style: _t(18, w: FontWeight.w800, ls: -0.3)),
              const Spacer(),
              if (auth.loggedIn)
                _Glass(
                  radius: 21,
                  opacity: 0.55,
                  blur: 14,
                  onTap: () => context.go(homeFor(auth.role)),
                  child: const SizedBox(
                    width: 42,
                    height: 42,
                    child: Icon(Icons.person_rounded, color: _ink, size: 21),
                  ),
                )
              else
                _Glass(
                  radius: 21,
                  opacity: 0.55,
                  blur: 14,
                  onTap: () => context.push('/login'),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
                  child: Text('Masuk', style: _t(13, w: FontWeight.w800)),
                ),
            ],
          ),
        ),

        // Tagline utama
        Positioned(
          top: top + 70,
          left: 20,
          right: 20,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Ruang aman,\n',
                  style: _t(28, w: FontWeight.w800, height: 1.18, ls: -0.7),
                ),
                TextSpan(
                  text: 'tanpa takut bersuara.',
                  style: _t(
                    28,
                    w: FontWeight.w800,
                    color: _tealDeep,
                    height: 1.18,
                    ls: -0.7,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Kolom cek kode laporan diposisikan menimpa batas bawah ilustrasi hero (sceneH - setengah tinggi input)
        Padding(
          padding: EdgeInsets.fromLTRB(20, sceneH - 28, 20, 0),
          child: _Glass(
            radius: 30,
            opacity: 0.6,
            blur: 20,
            padding: const EdgeInsets.fromLTRB(16, 0, 7, 0),
            child: SizedBox(
              height: 56,
              child: Row(
                children: [
                  Icon(Icons.search_rounded,
                      color: _ink.withValues(alpha: 0.55), size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _kodeController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _handleCekKodeLaporan(),
                      style: _t(14),
                      decoration: InputDecoration(
                        hintText: 'Masukkan kode laporan',
                        hintStyle: _t(
                          13.5,
                          w: FontWeight.w500,
                          color: _ink.withValues(alpha: 0.5),
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _handleCekKodeLaporan,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: _tealDeep,
                      ),
                      child: const Icon(Icons.arrow_forward_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchHint() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
      child: Row(
        children: [
          Icon(Icons.lock_outline_rounded,
              size: 14, color: _ink.withValues(alpha: 0.55)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'Kode muncul otomatis setelah laporanmu terkirim.',
              style:
                  _t(12, w: FontWeight.w500, color: _ink.withValues(alpha: 0.62)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnonymousCard() {
    return _Glass(
      radius: 28,
      tint: _teal.withValues(alpha: 0.26),
      padding: const EdgeInsets.fromLTRB(20, 18, 8, 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Takut ketahuan?',
                    style: _t(18, w: FontWeight.w800, ls: -0.3)),
                const SizedBox(height: 6),
                Text(
                  'Kamu bisa melapor anonim. Namamu tidak ditampilkan kepada guru BK yang meninjau.',
                  style: _t(
                    12.5,
                    w: FontWeight.w500,
                    color: _ink.withValues(alpha: 0.8),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () => _navigateProtected('/register'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: _ink,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.edit_note_rounded,
                            color: Colors.white, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          auth.loggedIn ? 'Buka dashboard' : 'Mulai melapor',
                          style: _t(12.5, w: FontWeight.w700, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          const SizedBox(
            width: 108,
            height: 118,
            child: CustomPaint(painter: _PhoneToggleScenePainter()),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCircles() {
    final items = [
      (
        label: 'Lapor aman',
        icon: Icons.shield_rounded,
        bg: _peach,
        onTap: () => _navigateProtected('/register'),
      ),
      (
        label: 'Konsultasi',
        icon: Icons.forum_rounded,
        bg: _mint,
        onTap: () => _navigateProtected('/login'),
      ),
      (
        label: 'Pantau status',
        icon: Icons.track_changes_rounded,
        bg: _lemon,
        onTap: () => _navigateProtected('/login'),
      ),
      (
        label: 'Riwayat',
        icon: Icons.history_rounded,
        bg: _pink,
        onTap: () => _navigateProtected('/login'),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Yang bisa kamu lakukan',
            style: _t(18, w: FontWeight.w800, ls: -0.3)),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final f in items)
              Expanded(
                child: GestureDetector(
                  onTap: f.onTap,
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.6),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.9),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _ink.withValues(alpha: 0.08),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: f.bg),
                          child: Icon(f.icon, color: _ink, size: 25),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        f.label,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _t(11.5, w: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildHowItWorks() {
    const steps = [
      (
        num: '1',
        title: 'Ceritakan semampumu',
        desc:
            'Pilih kategori, lalu isi lokasi, waktu, dan kronologi. Foto bukti boleh ditambahkan jika ada.'
      ),
      (
        num: '2',
        title: 'Simpan kode laporan',
        desc:
            'Kode unik muncul setelah laporan terkirim. Pakai untuk memantau statusnya.'
      ),
      (
        num: '3',
        title: 'Ditinjau guru BK',
        desc:
            'Status awalnya “Menunggu Ditinjau”. Perubahannya bisa kamu lihat kapan saja.'
      ),
      (
        num: '4',
        title: 'Didampingi',
        desc:
            'Guru BK mengajakmu berkonsultasi. Jika perlu, kamu dialihkan ke psikolog.'
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Cara kerjanya', style: _t(18, w: FontWeight.w800, ls: -0.3)),
        const SizedBox(height: 4),
        Text(
          'Empat langkah, tanpa ribet.',
          style: _t(12.5, w: FontWeight.w500, color: _ink.withValues(alpha: 0.64)),
        ),
        const SizedBox(height: 14),
        _Card(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
          child: Column(
            children: [
              for (int i = 0; i < steps.length; i++)
                // IntrinsicHeight memastikan garis konektor vertikal menyesuaikan tinggi deskripsi teks
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        width: 34,
                        child: Column(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _lavender.withValues(alpha: 0.9),
                              ),
                              child: Text(steps[i].num,
                                  style: _t(13.5, w: FontWeight.w800)),
                            ),
                            if (i != steps.length - 1)
                              Expanded(
                                child: Center(
                                  child: Container(
                                    width: 1.6,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    color: _teal.withValues(alpha: 0.3),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 5,
                            bottom: i == steps.length - 1 ? 0 : 18,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(steps[i].title,
                                  style: _t(14, w: FontWeight.w800)),
                              const SizedBox(height: 2),
                              Text(
                                steps[i].desc,
                                style: _t(
                                  12.5,
                                  w: FontWeight.w500,
                                  color: _ink.withValues(alpha: 0.72),
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacyCard() {
    Widget privacyPoint(IconData icon, String title, String desc) {
      return Padding(
        padding: const EdgeInsets.only(top: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: _peach, size: 19),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: _t(13.5, w: FontWeight.w700, color: Colors.white)),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: _t(
                      12,
                      w: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.74),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return _Glass(
      radius: 28,
      tint: _ink.withValues(alpha: 0.84),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Privasimu dijaga',
              style: _t(18, w: FontWeight.w800, color: Colors.white, ls: -0.3)),
          privacyPoint(Icons.visibility_off_rounded, 'Pilihan anonim',
              'Namamu bisa disembunyikan saat melapor.'),
          privacyPoint(Icons.admin_panel_settings_rounded, 'Akses sesuai peran',
              'Laporan dibuka guru BK, dan psikolog hanya bila kamu dialihkan.'),
          privacyPoint(
              Icons.folder_special_rounded,
              'Bukti tidak terbuka untuk umum',
              'Foto yang kamu unggah hanya bisa dibuka pihak yang berwenang.'),
        ],
      ),
    );
  }

  Widget _buildArticles() {
    return Column(
      key: _edukasiKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Bacaan untukmu', style: _t(18, w: FontWeight.w800, ls: -0.3)),
        const SizedBox(height: 4),
        Text(
          'Kenali tandanya, tahu langkahnya.',
          style: _t(12.5, w: FontWeight.w500, color: _ink.withValues(alpha: 0.64)),
        ),
        const SizedBox(height: 14),
        FutureBuilder<List<Article>>(
          future: _articles,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Padding(
                padding: EdgeInsets.all(28),
                child: Center(child: CircularProgressIndicator(color: _teal)),
              );
            }
            if (snap.hasError) {
              return _Card(
                padding: const EdgeInsets.all(16),
                child: Text(errMsg(snap.error!)),
              );
            }
            final list = snap.data ?? [];
            if (list.isEmpty) {
              return const _Card(
                padding: EdgeInsets.all(18),
                child: Text('Belum ada artikel edukasi.'),
              );
            }

            // Artikel pertama dijadikan sorotan utama, sisanya ditampilkan sebagai daftar ringkas
            final featured = list.first;
            final rest = list.skip(1).toList();
            final shown = _showAllArticles ? rest : rest.take(3).toList();

            return Column(
              children: [
                _FeaturedArticle(
                  article: featured,
                  fallbackImageUrl: _fallbackCovers[0],
                  onTap: () => context.push('/artikel/${featured.id}'),
                ),
                const SizedBox(height: 12),
                for (int i = 0; i < shown.length; i++) ...[
                  _ArticleRow(
                    article: shown[i],
                    fallbackImageUrl:
                        _fallbackCovers[(i + 1) % _fallbackCovers.length],
                    onTap: () => context.push('/artikel/${shown[i].id}'),
                  ),
                  const SizedBox(height: 10),
                ],
                if (rest.length > 3) ...[
                  const SizedBox(height: 4),
                  _PillButton(
                    label: _showAllArticles
                        ? 'Tampilkan lebih sedikit'
                        : 'Lihat semua artikel',
                    filled: false,
                    onTap: () =>
                        setState(() => _showAllArticles = !_showAllArticles),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmergency() {
    return _Glass(
      radius: 24,
      tint: _danger.withValues(alpha: 0.1),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: const Icon(Icons.emergency_rounded, color: _danger, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dalam bahaya sekarang?',
                    style: _t(14, w: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(
                  'Jangan tunggu laporan ditinjau. Segera hubungi orang dewasa yang kamu percaya atau layanan darurat 112.',
                  style: _t(
                    12.5,
                    w: FontWeight.w500,
                    color: _ink.withValues(alpha: 0.82),
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaq() {
    const faqs = [
      (
        q: 'Apakah identitas saya aman?',
        a: 'Ya. Kamu dapat memilih opsi Anonim saat mengirim laporan sehingga namamu tidak ditampilkan pada laporan yang ditinjau.',
      ),
      (
        q: 'Siapa yang membaca laporan saya?',
        a: 'Laporan hanya ditinjau oleh Guru BK sekolah. Jika dinilai mengalami trauma tinggi, Guru BK dapat mengalihkan pendampingan ke Psikolog.',
      ),
      (
        q: 'Apa itu kode laporan?',
        a: 'Kode unik yang dibuat otomatis setelah laporan dikirim, dipakai untuk memantau status peninjauan dari Guru BK.',
      ),
      (
        q: 'Bukti apa yang bisa saya lampirkan?',
        a: 'Kamu bisa mengunggah gambar sebagai bukti pendukung, misalnya tangkapan layar pesan. Bukti hanya bisa dibuka oleh pihak yang berwenang menangani laporanmu.',
      ),
    ];

    return Column(
      key: _bantuanKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pertanyaan yang sering muncul',
            style: _t(18, w: FontWeight.w800, ls: -0.3)),
        const SizedBox(height: 14),
        for (final item in faqs) ...[
          _Card(
            radius: 22,
            // Hapus garis pemisah bawaan ExpansionTile agar menyatu dengan kartu kaca
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                shape: const Border(),
                collapsedShape: const Border(),
                backgroundColor: Colors.transparent,
                collapsedBackgroundColor: Colors.transparent,
                tilePadding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
                childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                iconColor: _tealDeep,
                collapsedIconColor: _ink,
                title: Text(item.q, style: _t(13.5, w: FontWeight.w700)),
                children: [
                  Text(
                    item.a,
                    style: _t(
                      12.5,
                      w: FontWeight.w500,
                      color: _ink.withValues(alpha: 0.8),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _buildCta() {
    return _Glass(
      radius: 28,
      tint: _peach.withValues(alpha: 0.6),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Kamu tidak sendirian.',
              style: _t(21, w: FontWeight.w800, ls: -0.4)),
          const SizedBox(height: 8),
          Text(
            'Tidak harus sekarang, tidak harus semuanya. Mulai dari satu cerita, guru BK siap mendengarkan.',
            style: _t(
              13,
              w: FontWeight.w500,
              color: _ink.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          _PillButton(
            label: auth.loggedIn ? 'Buka dashboard' : 'Buat laporan',
            filled: true,
            onTap: () => _navigateProtected('/register'),
          ),
          if (!auth.loggedIn) ...[
            const SizedBox(height: 12),
            Center(
              child: GestureDetector(
                onTap: () => context.push('/login'),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Sudah punya akun? ',
                        style: _t(
                          12.5,
                          w: FontWeight.w500,
                          color: _ink.withValues(alpha: 0.7),
                        ),
                      ),
                      TextSpan(
                        text: 'Masuk',
                        style: _t(12.5, w: FontWeight.w800, color: _tealDeep),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        'LaporKeun! · Platform pelaporan perundungan dan pendampingan siswa.',
        textAlign: TextAlign.center,
        style: _t(11, w: FontWeight.w500, color: _ink.withValues(alpha: 0.5)),
      ),
    );
  }

  Widget _buildBottomNav() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        child: SizedBox(
          height: 82,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              _Glass(
                radius: 32,
                opacity: 0.55,
                blur: 26,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  height: 64,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _NavItem(
                        icon: Icons.home_rounded,
                        label: 'Beranda',
                        active: _navIndex == 0,
                        onTap: () {
                          setState(() => _navIndex = 0);
                          _scrollController.animateTo(
                            0,
                            duration: const Duration(milliseconds: 450),
                            curve: Curves.easeOutCubic,
                          );
                        },
                      ),
                      _NavItem(
                        icon: Icons.menu_book_rounded,
                        label: 'Edukasi',
                        active: _navIndex == 1,
                        onTap: () {
                          setState(() => _navIndex = 1);
                          _scrollToSection(_edukasiKey);
                        },
                      ),
                      // Ruang kosong di tengah untuk tombol melayang "Lapor"
                      const SizedBox(width: 60),
                      _NavItem(
                        icon: Icons.help_outline_rounded,
                        label: 'Bantuan',
                        active: _navIndex == 3,
                        onTap: () {
                          setState(() => _navIndex = 3);
                          _scrollToSection(_bantuanKey);
                        },
                      ),
                      _NavItem(
                        icon: Icons.person_outline_rounded,
                        label: auth.loggedIn ? 'Profil' : 'Masuk',
                        active: _navIndex == 4,
                        onTap: () {
                          setState(() => _navIndex = 4);
                          _navigateProtected('/login');
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                child: GestureDetector(
                  onTap: () => _navigateProtected('/register'),
                  child: Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _tealDeep,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: _tealDeep.withValues(alpha: 0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_rounded,
                            color: Colors.white, size: 22),
                        Text(
                          'Lapor',
                          style: _t(
                            10.5,
                            w: FontWeight.w800,
                            color: Colors.white,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// KOMPONEN UI PENDUKUNG
// =============================================================================

/// Kontainer efek glassmorphism (blur latar + gradasi transparan + border cahaya).
class _Glass extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final double opacity;
  final double blur;
  final Color? tint;
  final VoidCallback? onTap;

  const _Glass({
    required this.child,
    this.padding = EdgeInsets.zero,
    this.radius = 24,
    this.opacity = 0.5,
    this.blur = 22,
    this.tint,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(radius);
    final t = tint;
    final colors = t == null
        ? [
            Colors.white.withValues(alpha: (opacity + 0.15).clamp(0.0, 1.0)),
            Colors.white.withValues(alpha: (opacity - 0.12).clamp(0.0, 1.0)),
          ]
        : [t, t.withValues(alpha: t.a * 0.75)];

    final body = Container(
      decoration: BoxDecoration(
        borderRadius: r,
        boxShadow: [
          BoxShadow(
            color: _ink.withValues(alpha: 0.09),
            blurRadius: 26,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: r,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: r,
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.8),
                width: 1.2,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );

    if (onTap == null) return body;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: body,
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final VoidCallback? onTap;

  const _Card({
    required this.child,
    this.padding = EdgeInsets.zero,
    this.radius = 26,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _Glass(
      radius: radius,
      opacity: 0.5,
      blur: 20,
      padding: padding,
      onTap: onTap,
      child: child,
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback onTap;

  const _PillButton({
    required this.label,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled ? _tealDeep : Colors.white.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: filled ? _tealDeep : Colors.white.withValues(alpha: 0.9),
            width: 1.2,
          ),
          boxShadow: filled
              ? [
                  BoxShadow(
                    color: _tealDeep.withValues(alpha: 0.3),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: _t(14, w: FontWeight.w800, color: filled ? Colors.white : _ink),
        ),
      ),
    );
  }
}

class _FeaturedArticle extends StatelessWidget {
  final Article article;
  final String fallbackImageUrl;
  final VoidCallback onTap;

  const _FeaturedArticle({
    required this.article,
    required this.fallbackImageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = (article.cover != null && article.cover!.isNotEmpty)
        ? article.cover!
        : fallbackImageUrl;

    return _Card(
      onTap: onTap,
      radius: 28,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: _mint,
                  child: const Center(
                    child: Icon(Icons.image_outlined, color: _teal),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fmtDate(article.tanggal),
                  style: _t(11.5, w: FontWeight.w700, color: _tealDeep, ls: 0.2),
                ),
                const SizedBox(height: 6),
                Text(
                  article.judul,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: _t(17, w: FontWeight.w800, height: 1.25, ls: -0.3),
                ),
                if (article.ringkasan != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    article.ringkasan!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: _t(
                      12.5,
                      w: FontWeight.w500,
                      color: _ink.withValues(alpha: 0.72),
                      height: 1.45,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Text('Baca selengkapnya →',
                    style: _t(12.5, w: FontWeight.w800, color: _tealDeep)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticleRow extends StatelessWidget {
  final Article article;
  final String fallbackImageUrl;
  final VoidCallback onTap;

  const _ArticleRow({
    required this.article,
    required this.fallbackImageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = (article.cover != null && article.cover!.isNotEmpty)
        ? article.cover!
        : fallbackImageUrl;

    return _Card(
      onTap: onTap,
      radius: 22,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: 76,
              height: 76,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: _mint,
                  child: const Icon(Icons.image_outlined, color: _teal),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.judul,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: _t(13.5, w: FontWeight.w800, height: 1.25),
                ),
                const SizedBox(height: 4),
                Text(
                  fmtDate(article.tanggal),
                  style: _t(
                    11.5,
                    w: FontWeight.w500,
                    color: _ink.withValues(alpha: 0.58),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded,
              color: _ink.withValues(alpha: 0.4), size: 22),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? _tealDeep : _ink.withValues(alpha: 0.62);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 2),
            Text(
              label,
              style: _t(
                10.5,
                w: active ? FontWeight.w800 : FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Latar belakang gradasi dengan pendar radial lembut agar efek blur kaca terlihat kontras.
class _PageBackdrop extends StatelessWidget {
  const _PageBackdrop();

  Widget _glow(Alignment center, Color color, double radius) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: center,
            radius: radius,
            colors: [color, color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFEFECFA),
                  Color(0xFFE3EFF3),
                  Color(0xFFFBEEE4)
                ],
                stops: [0, 0.55, 1],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        _glow(const Alignment(1.0, -0.35), _lavender.withValues(alpha: 0.95),
            0.95),
        _glow(const Alignment(-1.0, 0.1),
            const Color(0xFFB9E0E3).withValues(alpha: 0.9), 0.9),
        _glow(const Alignment(0.9, 0.8), _peach.withValues(alpha: 0.85), 0.9),
        _glow(const Alignment(-0.8, 1.0), _pink.withValues(alpha: 0.7), 0.7),
      ],
    );
  }
}

// =============================================================================
// CUSTOM PAINTERS (ILUSTRASI VEKTOR)
// =============================================================================

/// Ilustrasi lanskap fajar berlapis bukit dengan mercusuar sebagai simbol tempat aman.
class _CalmDawnPainter extends CustomPainter {
  const _CalmDawnPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()
        ..shader = const LinearGradient(
          colors: [
            Color(0xFFCBC7EC),
            Color(0xFFEBD3E6),
            Color(0xFFFFE4D2),
            Color(0xFFFFF1E4),
          ],
          stops: [0, 0.42, 0.68, 1],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    final star = Paint()..color = Colors.white.withValues(alpha: 0.75);
    for (final o in [
      Offset(w * .3, h * .06),
      Offset(w * .52, h * .05),
      Offset(w * .97, h * .1),
      Offset(w * .93, h * .3),
    ]) {
      canvas.drawCircle(o, 1.6, star);
    }

    final moon = Offset(w * .6, h * .2);
    canvas.drawCircle(
        moon, 30, Paint()..color = Colors.white.withValues(alpha: 0.22));
    canvas.drawCircle(moon, 14, Paint()..color = const Color(0xFFFFF9EE));

    _wisp(canvas, Offset(w * .22, h * .56), w * .42);

    // Lapisan bukit disusun dari belakang ke depan untuk menciptakan kedalaman (parallax visual)
    final farHill = Path()
      ..moveTo(0, h * .66)
      ..cubicTo(w * .22, h * .56, w * .42, h * .63, w * .6, h * .64)
      ..cubicTo(w * .78, h * .65, w * .9, h * .57, w, h * .6)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(farHill, Paint()..color = const Color(0xFFC3CBEA));

    final midHill = Path()
      ..moveTo(0, h * .77)
      ..cubicTo(w * .25, h * .68, w * .5, h * .77, w * .72, h * .73)
      ..cubicTo(w * .86, h * .71, w * .95, h * .74, w, h * .73)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(midHill, Paint()..color = const Color(0xFF9CC3D1));

    _lighthouse(canvas, Offset(w * .78, h * .745), h * .2);

    final nearHill = Path()
      ..moveTo(0, h * .85)
      ..cubicTo(w * .3, h * .79, w * .6, h * .89, w, h * .81)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(nearHill, Paint()..color = const Color(0xFF5FA9B2));

    _pine(canvas, Offset(w * .08, h * .835), h * .16, const Color(0xFF2A7480));
    _pine(canvas, Offset(w * .16, h * .855), h * .11, const Color(0xFF3A8590));
    _pine(canvas, Offset(w * .94, h * .805), h * .13, const Color(0xFF2A7480));

    final frontHill = Path()
      ..moveTo(0, h * .93)
      ..cubicTo(w * .35, h * .89, w * .7, h * .97, w, h * .91)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(frontHill, Paint()..color = const Color(0xFF3F8F9A));
  }

  void _wisp(Canvas c, Offset o, double width) {
    c.drawOval(
      Rect.fromCenter(center: o, width: width, height: 12),
      Paint()..color = Colors.white.withValues(alpha: 0.35),
    );
  }

  void _lighthouse(Canvas c, Offset base, double ht) {
    final bw = ht * .22;
    final tw = ht * .14;
    final topY = base.dy - ht;

    final lampCenter = Offset(base.dx, topY - ht * .07);
    c.drawCircle(
      lampCenter,
      ht * .55,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFFFE7A8).withValues(alpha: 0.6),
            const Color(0xFFFFE7A8).withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: lampCenter, radius: ht * .55)),
    );

    // Interpolasi lebar menara pada rasio ketinggian t (0 = dasar, 1 = puncak)
    double widthAt(double t) => bw + (tw - bw) * t;

    final tower = Path()
      ..moveTo(base.dx - bw / 2, base.dy)
      ..lineTo(base.dx + bw / 2, base.dy)
      ..lineTo(base.dx + tw / 2, topY)
      ..lineTo(base.dx - tw / 2, topY)
      ..close();
    c.drawPath(tower, Paint()..color = const Color(0xFFFFF8F0));

    for (final band in [(0.22, 0.4), (0.6, 0.78)]) {
      final y0 = base.dy - ht * band.$1;
      final y1 = base.dy - ht * band.$2;
      final w0 = widthAt(band.$1);
      final w1 = widthAt(band.$2);
      final p = Path()
        ..moveTo(base.dx - w0 / 2, y0)
        ..lineTo(base.dx + w0 / 2, y0)
        ..lineTo(base.dx + w1 / 2, y1)
        ..lineTo(base.dx - w1 / 2, y1)
        ..close();
      c.drawPath(p, Paint()..color = _rose);
    }

    c.drawRect(
      Rect.fromCenter(
          center: Offset(base.dx, topY), width: tw * 1.6, height: 3),
      Paint()..color = _ink.withValues(alpha: 0.55),
    );
    final lantern = Rect.fromCenter(
      center: Offset(base.dx, topY - ht * .055),
      width: tw * .85,
      height: ht * .11,
    );
    c.drawRect(lantern, Paint()..color = const Color(0xFFFFE7A8));

    final roof = Path()
      ..moveTo(base.dx - tw * .6, lantern.top)
      ..lineTo(base.dx, lantern.top - ht * .09)
      ..lineTo(base.dx + tw * .6, lantern.top)
      ..close();
    c.drawPath(roof, Paint()..color = _ink.withValues(alpha: 0.75));
  }

  void _pine(Canvas c, Offset base, double ht, Color color) {
    c.drawRect(
      Rect.fromLTWH(base.dx - 2.5, base.dy - ht * .14, 5, ht * .14),
      Paint()..color = const Color(0xFF4E4A5E),
    );
    final p = Paint()..color = color;
    for (int i = 0; i < 3; i++) {
      final topY = base.dy - ht + i * ht * .24;
      final wd = ht * (.42 + i * .14);
      final path = Path()
        ..moveTo(base.dx, topY)
        ..lineTo(base.dx - wd / 2, topY + ht * .42)
        ..lineTo(base.dx + wd / 2, topY + ht * .42)
        ..close();
      c.drawPath(path, p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Ilustrasi ikon mode anonim (perisai terverifikasi dan sakelar aktif di layar ponsel).
class _PhoneToggleScenePainter extends CustomPainter {
  const _PhoneToggleScenePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bx = w * .1;
    final by = h * .82;
    final tower = Path()
      ..moveTo(bx - 11, by)
      ..lineTo(bx + 11, by)
      ..lineTo(bx + 7, by - 52)
      ..lineTo(bx - 7, by - 52)
      ..close();
    canvas.drawPath(tower, Paint()..color = const Color(0xFFFFF8F0));

    final band = Path()
      ..moveTo(bx - 9.6, by - 14)
      ..lineTo(bx + 9.6, by - 14)
      ..lineTo(bx + 8.4, by - 26)
      ..lineTo(bx - 8.4, by - 26)
      ..close();
    canvas.drawPath(band, Paint()..color = _rose);

    canvas.drawRect(
      Rect.fromCenter(center: Offset(bx, by - 57), width: 10, height: 9),
      Paint()..color = const Color(0xFFFFE7A8),
    );
    final roof = Path()
      ..moveTo(bx - 7, by - 61.5)
      ..lineTo(bx, by - 69)
      ..lineTo(bx + 7, by - 61.5)
      ..close();
    canvas.drawPath(roof, Paint()..color = _ink.withValues(alpha: 0.75));

    final phone = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * .36, h * .02, w * .6, h * .96),
      const Radius.circular(18),
    );
    canvas.drawRRect(phone, Paint()..color = _ink);

    final screen = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * .36 + 5, h * .02 + 5, w * .6 - 10, h * .96 - 10),
      const Radius.circular(14),
    );
    canvas.drawRRect(screen, Paint()..color = const Color(0xFFF4FAF9));

    final cx = w * .66;
    final shield = Path()
      ..moveTo(cx, h * .14)
      ..quadraticBezierTo(cx + 13, h * .18, cx + 13, h * .2)
      ..lineTo(cx + 13, h * .27)
      ..quadraticBezierTo(cx + 12, h * .34, cx, h * .37)
      ..quadraticBezierTo(cx - 12, h * .34, cx - 13, h * .27)
      ..lineTo(cx - 13, h * .2)
      ..quadraticBezierTo(cx - 13, h * .18, cx, h * .14)
      ..close();
    canvas.drawPath(shield, Paint()..color = _teal);

    final tick = Path()
      ..moveTo(cx - 5, h * .255)
      ..lineTo(cx - 1, h * .29)
      ..lineTo(cx + 6, h * .22);
    canvas.drawPath(
      tick,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = 2.2
        ..color = Colors.white,
    );

    final tw = w * .34;
    final track = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, h * .52), width: tw, height: 18),
      const Radius.circular(9),
    );
    canvas.drawRRect(track, Paint()..color = _teal);
    canvas.drawCircle(
        Offset(cx + tw / 2 - 9, h * .52), 7, Paint()..color = Colors.white);

    final line = Paint()..color = _ink.withValues(alpha: 0.12);
    for (int i = 0; i < 3; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
              w * .45, h * (.64 + i * .08), w * (i == 2 ? .24 : .42), 5),
          const Radius.circular(3),
        ),
        line,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Maskot perisai fallback apabila aset gambar logo gagal dimuat.
class _Mascot extends StatelessWidget {
  final double size;
  const _Mascot({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 1.1,
      child: CustomPaint(painter: _MascotPainter()),
    );
  }
}

class _MascotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final shield = Path()
      ..moveTo(w * .5, h * .02)
      ..cubicTo(w * .62, h * .12, w * .8, h * .16, w * .94, h * .16)
      ..lineTo(w * .94, h * .5)
      ..cubicTo(w * .94, h * .78, w * .74, h * .94, w * .5, h * .99)
      ..cubicTo(w * .26, h * .94, w * .06, h * .78, w * .06, h * .5)
      ..lineTo(w * .06, h * .16)
      ..cubicTo(w * .2, h * .16, w * .38, h * .12, w * .5, h * .02)
      ..close();

    canvas.drawPath(
      shield,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF5FB8C6), _teal],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    final eye = Paint()..color = _ink;
    canvas.drawCircle(Offset(w * .36, h * .46), w * .06, eye);
    canvas.drawCircle(Offset(w * .64, h * .46), w * .06, eye);

    final blush = Paint()
      ..color = const Color(0xFFFFB3B8).withValues(alpha: 0.85);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(w * .25, h * .58), width: w * .15, height: h * .09),
      blush,
    );
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(w * .75, h * .58), width: w * .15, height: h * .09),
      blush,
    );

    canvas.drawArc(
      Rect.fromCenter(
          center: Offset(w * .5, h * .56), width: w * .22, height: h * .15),
      0.25,
      math.pi - 0.5,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = w * .035
        ..color = _ink,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// =============================================================================
// HALAMAN DETAIL ARTIKEL
// =============================================================================

class ArticleDetailScreen extends StatelessWidget {
  final String id;
  const ArticleDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFECFA),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: _ink),
        title: Text('Artikel Edukasi', style: _t(17, w: FontWeight.w800)),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: _PageBackdrop()),
          SafeArea(
            child: FutureBuilder<Article>(
              future: Repo.articleById(id),
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const Center(
                    child: CircularProgressIndicator(color: _teal),
                  );
                }
                if (snap.hasError) {
                  return Center(child: Text(errMsg(snap.error!)));
                }
                final a = snap.data!;
                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                  children: [
                    _Card(
                      radius: 28,
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (a.cover != null && a.cover!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  a.cover!,
                                  errorBuilder: (_, __, ___) =>
                                      const SizedBox.shrink(),
                                ),
                              ),
                            ),
                          Text(
                            a.judul,
                            style: _t(
                              22,
                              w: FontWeight.w800,
                              height: 1.25,
                              ls: -0.4,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            fmtDate(a.tanggal),
                            style:
                                _t(12.5, color: _ink.withValues(alpha: 0.62)),
                          ),
                          if (a.ringkasan != null) ...[
                            const SizedBox(height: 14),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: _mint.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Text(
                                a.ringkasan!,
                                style: _t(13.5, height: 1.45),
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          Divider(color: _ink.withValues(alpha: 0.1)),
                          const SizedBox(height: 10),
                          SelectableText(
                            a.isi,
                            style: _t(14.5, w: FontWeight.w500, height: 1.7),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}