import 'dart:math' as math;

import 'package:flutter/material.dart';

class BouncingDots extends StatefulWidget {
  const BouncingDots({super.key, this.color, this.size = 10});
  final Color? color;
  final double size;

  @override
  State<BouncingDots> createState() => _BouncingDotsState();
}

class _BouncingDotsState extends State<BouncingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 850),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        final start = i * 0.12; // stagger, like the SVG's 0.1s offsets
        final anim = CurvedAnimation(
          parent: _c,
          curve: Interval(start, start + 0.7),
        );
        return AnimatedBuilder(
          animation: anim,
          builder: (_, __) {
            final t = math.sin(anim.value * math.pi); // 0 -> 1 -> 0
            return Transform.translate(
              offset: Offset(0, -widget.size * 0.8 * t),
              child: Container(
                width: widget.size,
                height: widget.size,
                margin: EdgeInsets.symmetric(horizontal: widget.size * 0.25),
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            );
          },
        );
      }),
    );
  }
}
