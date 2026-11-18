import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/glass_container.dart';
import '../painters/calm_dawn_painter.dart';
import 'mascot.dart';

class LandingHero extends StatelessWidget {
  final bool isLoggedIn;
  final String logoAssetPath;
  final TextEditingController kodeController;
  final VoidCallback onProfileTap;
  final VoidCallback onLoginTap;
  final VoidCallback onCheckCode;

  const LandingHero({
    super.key,
    required this.isLoggedIn,
    required this.logoAssetPath,
    required this.kodeController,
    required this.onProfileTap,
    required this.onLoginTap,
    required this.onCheckCode,
  });

  @override
  Widget build(BuildContext context) {
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
            child: CustomPaint(painter: CalmDawnPainter()),
          ),
        ),

        // Header logo dan tombol aksi akun
        Positioned(
          top: top + 10,
          left: 20,
          right: 20,
          child: Row(
            children: [
              GlassContainer(
                radius: 14,
                opacity: 0.55,
                blur: 14,
                padding: const EdgeInsets.all(6),
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: Image.asset(
                    logoAssetPath,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Mascot(size: 24),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'LaporKeun!',
                style: AppTextStyles.text(
                  18,
                  weight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              const Spacer(),
              if (isLoggedIn)
                GlassContainer(
                  radius: 21,
                  opacity: 0.55,
                  blur: 14,
                  onTap: onProfileTap,
                  child: const SizedBox(
                    width: 42,
                    height: 42,
                    child: Icon(
                      Icons.person_rounded,
                      color: AppColors.ink,
                      size: 21,
                    ),
                  ),
                )
              else
                GlassContainer(
                  radius: 21,
                  opacity: 0.55,
                  blur: 14,
                  onTap: onLoginTap,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 11,
                  ),
                  child: Text(
                    'Masuk',
                    style: AppTextStyles.text(13, weight: FontWeight.w800),
                  ),
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
                  style: AppTextStyles.text(
                    28,
                    weight: FontWeight.w800,
                    height: 1.18,
                    letterSpacing: -0.7,
                  ),
                ),
                TextSpan(
                  text: 'tanpa takut bersuara.',
                  style: AppTextStyles.text(
                    28,
                    weight: FontWeight.w800,
                    color: AppColors.primaryDark,
                    height: 1.18,
                    letterSpacing: -0.7,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Kolom pengecekan kode laporan
        Padding(
          padding: EdgeInsets.fromLTRB(20, sceneH - 28, 20, 0),
          child: GlassContainer(
            radius: 30,
            opacity: 0.6,
            blur: 20,
            padding: const EdgeInsets.fromLTRB(16, 0, 7, 0),
            child: SizedBox(
              height: 56,
              child: Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: AppColors.ink.withValues(alpha: 0.55),
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: kodeController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => onCheckCode(),
                      style: AppTextStyles.text(14),
                      decoration: InputDecoration(
                        hintText: 'Masukkan kode laporan',
                        hintStyle: AppTextStyles.text(
                          13.5,
                          weight: FontWeight.w500,
                          color: AppColors.ink.withValues(alpha: 0.5),
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onCheckCode,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryDark,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
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
}
