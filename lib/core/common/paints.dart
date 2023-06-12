import 'dart:math';
import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..strokeWidth = 4
      ..color = const Color.fromARGB(106, 255, 255, 255)
      ..style = PaintingStyle.stroke;

    final arcRect = Rect.fromCircle(
        center: size.topCenter(Offset.zero), radius: size.shortestSide);

    canvas.drawArc(arcRect, 0, pi, false, line);
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) => false;
}

class MyPainter01 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..strokeWidth = 4
      ..color = const Color.fromARGB(106, 255, 255, 255)
      ..style = PaintingStyle.stroke;

    final rectangle = const Offset(4, 4) & const Size(110, 60);

    canvas.drawRect(rectangle, line);
  }

  @override
  bool shouldRepaint(MyPainter01 oldDelegate) => false;
}

class MyPainter02 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..strokeWidth = 4
      ..color = const Color.fromARGB(106, 255, 255, 255)
      ..style = PaintingStyle.stroke;

    final rectangle = const Offset(4, 4) & const Size(290, 140);

    canvas.drawRect(rectangle, line);
  }

  @override
  bool shouldRepaint(MyPainter02 oldDelegate) => false;
}
