import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class PhoneToggleScenePainter extends CustomPainter {
  const PhoneToggleScenePainter();

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
    canvas.drawPath(band, Paint()..color = AppColors.rose);

    canvas.drawRect(
      Rect.fromCenter(center: Offset(bx, by - 57), width: 10, height: 9),
      Paint()..color = const Color(0xFFFFE7A8),
    );
    final roof = Path()
      ..moveTo(bx - 7, by - 61.5)
      ..lineTo(bx, by - 69)
      ..lineTo(bx + 7, by - 61.5)
      ..close();
    canvas.drawPath(
      roof,
      Paint()..color = AppColors.ink.withValues(alpha: 0.75),
    );

    final phone = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * .36, h * .02, w * .6, h * .96),
      const Radius.circular(18),
    );
    canvas.drawRRect(phone, Paint()..color = AppColors.ink);

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
    canvas.drawPath(shield, Paint()..color = AppColors.primary);

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
    canvas.drawRRect(track, Paint()..color = AppColors.primary);
    canvas.drawCircle(
      Offset(cx + tw / 2 - 9, h * .52),
      7,
      Paint()..color = Colors.white,
    );

    final line = Paint()..color = AppColors.ink.withValues(alpha: 0.12);
    for (int i = 0; i < 3; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            w * .45,
            h * (.64 + i * .08),
            w * (i == 2 ? .24 : .42),
            5,
          ),
          const Radius.circular(3),
        ),
        line,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
