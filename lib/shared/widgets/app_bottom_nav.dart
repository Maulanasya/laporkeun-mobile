import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils.dart';
import '../../data/auth_state.dart';
import 'glass_container.dart';
import 'nav_item.dart';

abstract class NavTab {
  static const int home = 0;
  static const int education = 1;
  static const int help = 3;
  static const int profile = 4;
}

class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  final VoidCallback? onHomeTap;
  final VoidCallback? onEducationTap;
  final VoidCallback? onHelpTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onReportTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    this.onHomeTap,
    this.onEducationTap,
    this.onHelpTap,
    this.onProfileTap,
    this.onReportTap,
  });

  // ---------- Navigasi default ----------

  void _goHome(BuildContext context) {
    if (currentIndex == NavTab.home) return;
    context.go('/');
  }

  void _goEducation(BuildContext context) {
    if (currentIndex == NavTab.education) return;
    context.go('/edukasi');
  }

  void _goHelp(BuildContext context) {
    if (currentIndex == NavTab.help) return;
    context.go('/bantuan');
  }

  void _goProtected(BuildContext context, String loggedOutRoute) {
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
      builder: (context, _) {
        final isLoggedIn = auth.loggedIn;
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
                  GlassContainer(
                    radius: 32,
                    opacity: 0.55,
                    blur: 26,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SizedBox(
                      height: 64,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          NavItem(
                            icon: Icons.home_rounded,
                            label: 'Beranda',
                            active: currentIndex == NavTab.home,
                            onTap: onHomeTap ?? () => _goHome(context),
                          ),
                          NavItem(
                            icon: Icons.menu_book_rounded,
                            label: 'Edukasi',
                            active: currentIndex == NavTab.education,
                            onTap:
                                onEducationTap ?? () => _goEducation(context),
                          ),
                          const SizedBox(width: 60),
                          NavItem(
                            icon: Icons.help_outline_rounded,
                            label: 'Bantuan',
                            active: currentIndex == NavTab.help,
                            onTap: onHelpTap ?? () => _goHelp(context),
                          ),
                          NavItem(
                            icon: Icons.person_outline_rounded,
                            label: isLoggedIn ? 'Profil' : 'Masuk',
                            active: currentIndex == NavTab.profile,
                            onTap:
                                onProfileTap ??
                                () => _goProtected(context, '/login'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: GestureDetector(
                      onTap:
                          onReportTap ??
                          () => _goProtected(context, '/register'),
                      child: Container(
                        width: 62,
                        height: 62,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryDark,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryDark.withValues(
                                alpha: 0.4,
                              ),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                            Text(
                              'Lapor',
                              style: AppTextStyles.text(
                                10.5,
                                weight: FontWeight.w800,
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
      },
    );
  }
}