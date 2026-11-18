import 'package:flutter/material.dart';

import 'glass_container.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.radius = 26,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      radius: radius,
      opacity: 0.5,
      blur: 20,
      padding: padding,
      onTap: onTap,
      child: child,
    );
  }
}
