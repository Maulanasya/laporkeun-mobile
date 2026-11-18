import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils.dart';
import '../../../core/theme/app_colors.dart';

import '../../../data/auth_state.dart';
import '../../../data/models.dart';
import '../../../data/repository.dart';

import '../../../shared/widgets/page_backdrop.dart';

import '../widgets/education_header.dart';
import '../widgets/education_intro.dart';
import '../widgets/education_search_field.dart';
import '../widgets/education_category_chips.dart';
import '../widgets/education_article_list.dart';
import '../widgets/education_help_card.dart';
import '../../../shared/widgets/app_bottom_nav.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  static const List<String> _fallbackCovers = [
    'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1509062522246-3755977927d7?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1573497019940-1c28c88b4f3e?auto=format&fit=crop&w=800&q=80',
  ];

  // Sementara hanya tampilan. Hubungkan ke field kategori Article jika sudah ada.
  static const List<String> _categories = [
    'Semua',
    'Bullying',
    'Kesehatan mental',
    'Hak siswa',
    'Tips aman',
  ];

  late Future<List<Article>> _articles = Repo.articles();
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  int _category = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    setState(() => _articles = Repo.articles());
    try {
      await _articles;
    } catch (_) {}
  }

  void _navigateProtected(String loggedOutRoute) {
    if (auth.loggedIn) {
      context.go(homeFor(auth.role));
    } else {
      context.push(loggedOutRoute);
    }
  }

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
            SafeArea(
              bottom: false,
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: _refresh,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 140),
                  children: [
                    EduHeader(
                      onBack: () =>
                          context.canPop() ? context.pop() : context.go('/'),
                    ),
                    const SizedBox(height: 22),
                    const EduIntro(),
                    const SizedBox(height: 18),
                    EduSearchField(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _query = v.trim()),
                      onClear: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                    ),
                    const SizedBox(height: 14),
                    EduCategoryChips(
                      categories: _categories,
                      selectedIndex: _category,
                      onSelected: (i) => setState(() => _category = i),
                    ),
                    const SizedBox(height: 20),
                    EduArticleList(
                      articles: _articles,
                      query: _query,
                      fallbackCovers: _fallbackCovers,
                      onArticleTap: (a) => context.push('/artikel/${a.id}'),
                    ),
                    const SizedBox(height: 10),
                    EduHelpCard(
                      onReportTap: () => _navigateProtected('/register'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const AppBottomNav(currentIndex: NavTab.education),
      )
    );
  }
}