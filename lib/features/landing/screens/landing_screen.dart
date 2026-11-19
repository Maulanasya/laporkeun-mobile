import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils.dart';
import '../../../core/theme/app_colors.dart';

import '../../../data/auth_state.dart';
import '../../../data/models.dart';
import '../../../data/repository.dart';

import '../../../shared/widgets/page_backdrop.dart';
import '../../../shared/widgets/app_bottom_nav.dart';

import '../widgets/search_hint.dart';
import '../widgets/anonymous_card.dart';
import '../widgets/feature_circles.dart';
import '../widgets/how_it_works.dart';
import '../widgets/privacy_card.dart';
import '../widgets/articles_section.dart';
import '../widgets/emergency_card.dart';
import '../widgets/faq_section.dart';
import '../widgets/cta_section.dart';
import '../widgets/landing_footer.dart';
import '../widgets/landing_hero.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  static const String _logoAssetPath = 'assets/images/logo.png';

  static const List<String> _fallbackCovers = [
    'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1509062522246-3755977927d7?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1573497019940-1c28c88b4f3e?auto=format&fit=crop&w=800&q=80',
  ];

  late Future<List<Article>> _articles = Repo.articles();
  final TextEditingController _kodeController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _edukasiKey = GlobalKey();
  final GlobalKey _bantuanKey = GlobalKey();

  bool _showAllArticles = false;
  int _navIndex = NavTab.home;

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

  void _toast(String msg, {SnackBarAction? action}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.ink,
        content: Text(msg, style: const TextStyle(color: Colors.white)),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        action: action,
      ),
    );
  }

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
          textColor: AppColors.peach,
          onPressed: () => context.push('/login'),
        ),
      );
    }
  }

  void _navigateProtected(String loggedOutRoute) {
    if (auth.loggedIn) {
      context.go(homeFor(auth.role));
    } else {
      context.push(loggedOutRoute);
    }
  }

  Widget _pad(Widget child) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: child,
  );

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: auth,
      builder: (context, _) => Scaffold(
        backgroundColor: AppColors.landingBackground,
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            const Positioned.fill(child: PageBackdrop()),
            RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _refresh,
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.only(bottom: 140),
                children: [
                  LandingHero(
                    isLoggedIn: auth.loggedIn,
                    logoAssetPath: _logoAssetPath,
                    kodeController: _kodeController,
                    onProfileTap: () => context.push('/profile'),
                    onLoginTap: () => context.push('/login'),
                    onCheckCode: _handleCekKodeLaporan,
                  ),
                  _pad(const SearchHint()),
                  const SizedBox(height: 22),
                  _pad(
                    AnonymousCard(
                      isLoggedIn: auth.loggedIn,
                      onTap: () => _navigateProtected('/register'),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _pad(FeatureCircles(onNavigate: _navigateProtected)),
                  const SizedBox(height: 34),
                  _pad(const HowItWorks()),
                  const SizedBox(height: 22),
                  _pad(const PrivacyCard()),
                  const SizedBox(height: 34),
                  _pad(
                    ArticlesSection(
                      sectionKey: _edukasiKey,
                      articles: _articles,
                      fallbackCovers: _fallbackCovers,
                      showAllArticles: _showAllArticles,
                      onToggleArticles: () {
                        setState(() {
                          _showAllArticles = !_showAllArticles;
                        });
                      },
                      onArticleTap: (article) {
                        context.push('/artikel/${article.id}');
                      },
                    ),
                  ),
                  const SizedBox(height: 22),
                  _pad(const EmergencyCard()),
                  const SizedBox(height: 34),
                  _pad(FaqSection(sectionKey: _bantuanKey)),
                  const SizedBox(height: 24),
                  _pad(
                    CtaSection(
                      isLoggedIn: auth.loggedIn,
                      onRegisterTap: () => _navigateProtected('/register'),
                      onLoginTap: () => context.push('/login'),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const LandingFooter(),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: AppBottomNav(
          currentIndex: _navIndex,
          onHomeTap: () {
            setState(() => _navIndex = NavTab.home);
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeOutCubic,
            );
          },
        ),
      ),
    );
  }
}
