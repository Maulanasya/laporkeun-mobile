import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class MascotPainter extends CustomPainter {
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
          colors: [Color(0xFF5FB8C6), AppColors.primary],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    final eye = Paint()..color = AppColors.ink;
    canvas.drawCircle(Offset(w * .36, h * .46), w * .06, eye);
    canvas.drawCircle(Offset(w * .64, h * .46), w * .06, eye);

    final blush = Paint()
      ..color = const Color(0xFFFFB3B8).withValues(alpha: 0.85);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * .25, h * .58),
        width: w * .15,
        height: h * .09,
      ),
      blush,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * .75, h * .58),
        width: w * .15,
        height: h * .09,
      ),
      blush,
    );

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(w * .5, h * .56),
        width: w * .22,
        height: h * .15,
      ),
      0.25,
      math.pi - 0.5,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = w * .035
        ..color = AppColors.ink,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
