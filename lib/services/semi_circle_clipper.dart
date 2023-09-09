import 'dart:math';

import 'package:flutter/material.dart';

class SemiCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // Move to the top left corner
    path.moveTo(0, 0);

    // Draw a straight line to the top right corner
    path.lineTo(size.width, 0);

    // Draw a straight line to the bottom right corner
    path.lineTo(size.width, size.height / 2);
// Draw two small semi-circles to remove from both sides
    const double radius = 12.0; // Adjust the radius as needed
    final double centerY = size.height / 2;
    // Right semi-circle (removal)
    path.arcTo(
      Rect.fromCircle(center: Offset(size.width, centerY), radius: radius),
      -90 * pi / 180,
      -3.14,
      false,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, size.height / 2);

    path.arcTo(
      Rect.fromCircle(center: Offset(0, centerY), radius: radius),
      90 * pi / 180,
      -3.14,
      false,
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
