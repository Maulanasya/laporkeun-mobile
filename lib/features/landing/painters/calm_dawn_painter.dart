import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class CalmDawnPainter extends CustomPainter {
  const CalmDawnPainter();

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
      moon,
      30,
      Paint()..color = Colors.white.withValues(alpha: 0.22),
    );
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
      c.drawPath(p, Paint()..color = AppColors.rose);
    }

    c.drawRect(
      Rect.fromCenter(
        center: Offset(base.dx, topY),
        width: tw * 1.6,
        height: 3,
      ),
      Paint()..color = AppColors.ink.withValues(alpha: 0.55),
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
    c.drawPath(roof, Paint()..color = AppColors.ink.withValues(alpha: 0.75));
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
