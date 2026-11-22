import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

class ObjectPainter extends CustomPainter {
  final List<DetectedObject> objects;
  final Size absoluteImageSize;
  final InputImageRotation rotation;

  ObjectPainter({
    required this.objects,
    required this.absoluteImageSize,
    required this.rotation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.cyanAccent;

    for (final detectedObject in objects) {
      final rect = _scaleRect(
        rect: detectedObject.boundingBox,
        imageSize: absoluteImageSize,
        widgetSize: size,
        rotation: rotation,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(12)),
        paint,
      );

      if (detectedObject.labels.isNotEmpty) {
        final topLabel = detectedObject.labels.first;
        final textPainter = TextPainter(
          text: TextSpan(
            text:
                '${topLabel.text} ${(topLabel.confidence * 100).toStringAsFixed(0)}%',
            style: const TextStyle(
              color: Colors.black,
              backgroundColor: Colors.cyanAccent,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        textPainter.paint(canvas, Offset(rect.left, rect.top - 22));
      }
    }
  }

  Rect _scaleRect({
    required Rect rect,
    required Size imageSize,
    required Size widgetSize,
    required InputImageRotation rotation,
  }) {
    final isRotated =
        Platform.isAndroid &&
        (rotation == InputImageRotation.rotation90deg ||
            rotation == InputImageRotation.rotation270deg);

    final double imgW = isRotated ? imageSize.height : imageSize.width;
    final double imgH = isRotated ? imageSize.width : imageSize.height;

    final scaleX = widgetSize.width / imgW;
    final scaleY = widgetSize.height / imgH;

    return Rect.fromLTRB(
      rect.left * scaleX,
      rect.top * scaleY,
      rect.right * scaleX,
      rect.bottom * scaleY,
    );
  }

  @override
  bool shouldRepaint(covariant ObjectPainter oldDelegate) =>
      oldDelegate.objects != objects;
}
