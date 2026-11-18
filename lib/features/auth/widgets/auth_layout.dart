import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../landing/widgets/mascot.dart';
import 'auth_backdrop.dart';
import 'auth_glass.dart';

class AuthLayout extends StatelessWidget {
  final Widget child;

  const AuthLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.landingBackground,
      body: Stack(
        children: [
          const Positioned.fill(child: AuthBackdrop()),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 30),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          AuthGlass(
                            radius: 16,
                            padding: const EdgeInsets.all(8),
                            child: const Mascot(size: 28),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'LaporKeun!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.ink,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => context.go('/'),
                            child: AuthGlass(
                              radius: 22,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.arrow_back_rounded,
                                    color: AppColors.ink,
                                    size: 16,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Beranda',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      AuthGlass(
                        radius: 32,
                        opacity: 0.64,
                        blur: 24,
                        padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
                        child: child,
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'LaporKeun! · Ruang aman untuk berani bersuara.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.ink.withValues(alpha: 0.48),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
