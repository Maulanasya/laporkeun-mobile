import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/glass_container.dart';
import 'nav_item.dart';

class LandingBottomNav extends StatelessWidget {
  final int navIndex;
  final bool isLoggedIn;
  final VoidCallback onHomeTap;
  final VoidCallback onEducationTap;
  final VoidCallback onHelpTap;
  final VoidCallback onProfileTap;
  final VoidCallback onReportTap;

  const LandingBottomNav({
    super.key,
    required this.navIndex,
    required this.isLoggedIn,
    required this.onHomeTap,
    required this.onEducationTap,
    required this.onHelpTap,
    required this.onProfileTap,
    required this.onReportTap,
  });

  @override
  Widget build(BuildContext context) {
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
                        active: navIndex == 0,
                        onTap: onHomeTap,
                      ),
                      NavItem(
                        icon: Icons.menu_book_rounded,
                        label: 'Edukasi',
                        active: navIndex == 1,
                        onTap: onEducationTap,
                      ),
                      const SizedBox(width: 60),
                      NavItem(
                        icon: Icons.help_outline_rounded,
                        label: 'Bantuan',
                        active: navIndex == 3,
                        onTap: onHelpTap,
                      ),
                      NavItem(
                        icon: Icons.person_outline_rounded,
                        label: isLoggedIn ? 'Profil' : 'Masuk',
                        active: navIndex == 4,
                        onTap: onProfileTap,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                child: GestureDetector(
                  onTap: onReportTap,
                  child: Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryDark,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryDark.withValues(alpha: 0.4),
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
  }
}
