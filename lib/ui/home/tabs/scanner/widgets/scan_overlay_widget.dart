import 'package:flutter/material.dart';

class ScanOverlayWidget extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(painter: _OverLayPainter(), size: Size.infinite),
    );
  }
}

class _OverLayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final side = size.width * .75;
    final window = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: size.center(Offset.zero),
        width: side,
        height: side,
      ),
      const Radius.circular(16),
    );
    final dim = Path.combine(
      PathOperation.difference,
      Path()..addRect(Offset.zero & size),
      Path()..addRRect(window),
    );
    canvas.drawPath(dim, Paint()..color = Colors.black54);
    canvas.drawRRect(
      window,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
