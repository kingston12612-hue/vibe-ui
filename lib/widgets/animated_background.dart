import 'dart:math';

import 'package:flutter/material.dart';

/// Full-screen animated background for the current vibe:
/// a base gradient plus slow-drifting blurred blobs and floating dust.
/// Paints every frame via a repeating AnimationController.
class AnimatedBackground extends StatefulWidget {
  final List<Color> colors;

  const AnimatedBackground({super.key, required this.colors});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _VibePainter(t: _controller.value, colors: widget.colors),
          size: Size.infinite,
        );
      },
    );
  }
}

class _BlobSpec {
  final Offset center;
  final double radius;
  final double dx;
  final double dy;
  final double phase;

  const _BlobSpec({
    required this.center,
    required this.radius,
    required this.dx,
    required this.dy,
    required this.phase,
  });
}

class _VibePainter extends CustomPainter {
  final double t;
  final List<Color> colors;

  _VibePainter({required this.t, required this.colors});

  static const List<_BlobSpec> _blobs = [
    _BlobSpec(
      center: Offset(0.26, 0.28),
      radius: 0.42,
      dx: 0.10,
      dy: 0.07,
      phase: 0.0,
    ),
    _BlobSpec(
      center: Offset(0.78, 0.22),
      radius: 0.34,
      dx: 0.07,
      dy: 0.11,
      phase: 2.1,
    ),
    _BlobSpec(
      center: Offset(0.55, 0.78),
      radius: 0.48,
      dx: 0.12,
      dy: 0.05,
      phase: 4.2,
    ),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, background);

    for (final spec in _blobs) {
      final angle = t * 2 * pi + spec.phase;
      final center = Offset(
        (spec.center.dx + spec.dx * sin(angle)) * size.width,
        (spec.center.dy + spec.dy * cos(angle * 0.8)) * size.height,
      );
      final radius = spec.radius * size.shortestSide;
      final blobColor = colors[colors.length - 1].withOpacity(0.30);
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [blobColor, blobColor.withOpacity(0.0)],
        ).createShader(Rect.fromCircle(center: center, radius: radius));
      canvas.drawCircle(center, radius, paint);
    }

    // Floating dust — deterministic positions, drifting upward.
    final random = Random(7);
    final dotPaint = Paint()..color = Colors.white.withOpacity(0.30);
    for (var i = 0; i < 26; i++) {
      final seedX = random.nextDouble();
      final seedY = random.nextDouble();
      final seedR = random.nextDouble();
      final speed = 0.04 + seedR * 0.09;
      final y = ((seedY - t * speed) % 1 + 1) % 1;
      canvas.drawCircle(
        Offset(seedX * size.width, y * size.height),
        1.2 + seedR * 2.2,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _VibePainter oldDelegate) {
    return oldDelegate.t != t || oldDelegate.colors != colors;
  }
}
