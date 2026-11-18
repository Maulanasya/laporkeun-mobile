import 'package:flutter/material.dart';

import '../painters/mascot_painter.dart';

class Mascot extends StatelessWidget {
  final double size;
  const Mascot({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 1.1,
      child: CustomPaint(painter: MascotPainter()),
    );
  }
}
