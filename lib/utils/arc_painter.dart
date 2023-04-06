import 'dart:math';
import 'package:flutter/material.dart';

class ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // create a bounding square, based on the centre and radius of the arc
    Rect rect =
        new Rect.fromPoints(new Offset(0.0, -90.0), new Offset(372.0, 45.0));

    // a fancy rainbow gradient
    final Gradient gradient = new RadialGradient(
      colors: <Color>[
        Colors.white.withOpacity(1.0),
      ],
      stops: [
        0.0,
      ],
    );

    // create the Shader from the gradient and the bounding square
    final Paint paint = new Paint()..shader = gradient.createShader(rect);

    // and draw an arc
    canvas.drawArc(rect, 0.0, pi, true, paint);
  }

  @override
  bool shouldRepaint(ArcPainter oldDelegate) {
    return true;
  }
}
