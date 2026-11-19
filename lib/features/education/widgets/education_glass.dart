import 'package:flutter/material.dart';

BoxDecoration eduGlass({double radius = 28}) => BoxDecoration(
  color: Colors.white.withValues(alpha: 0.55),
  borderRadius: BorderRadius.circular(radius),
  border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
);