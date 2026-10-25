import 'package:flutter/material.dart';

import '../models/vibe.dart';
import '../widgets/animated_background.dart';

/// Guided 4-4-4 breathing session over the current vibe:
/// 4 s inhale — 4 s hold — 4 s exhale, with a growing/shrinking orb.
class BreathingOverlay extends StatefulWidget {
  final Vibe vibe;
  final VoidCallback onClose;

  const BreathingOverlay({
    super.key,
    required this.vibe,
    required this.onClose,
  });

  @override
  State<BreathingOverlay> createState() => _BreathingOverlayState();
}

class _BreathingOverlayState extends State<BreathingOverlay>
    with SingleTickerProviderStateMixin {
  /// One full cycle: inhale (4 s) + hold (4 s) + exhale (4 s) = 12 s.
  static const Duration _cycle = Duration(seconds: 12);

  late final AnimationController _controller;
  final Stopwatch _stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _cycle)..repeat();
    _stopwatch.start();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ({double scale, String label, String hint}) _phaseFor(double t) {
    const double maxScale = 1.55;
    if (t < 1 / 3) {
      final k = Curves.easeInOut.transform(t * 3);
      return (
        scale: 1.0 + (maxScale - 1.0) * k,
        label: 'Breathe in',
        hint: 'through the nose',
      );
    }
    if (t < 2 / 3) {
      return (scale: maxScale, label: 'Hold', hint: 'soft and still');
    }
    final k = Curves.easeInOut.transform((t - 2 / 3) * 3);
    return (
      scale: maxScale - (maxScale - 1.0) * k,
      label: 'Breathe out',
      hint: 'slow and long',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.35),
      body: Stack(
        children: [
          AnimatedBackground(colors: widget.vibe.gradient),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: Material(
                          color: Colors.white.withOpacity(0.12),
                          child: InkWell(
                            onTap: widget.onClose,
                            child: const SizedBox(
                              width: 46,
                              height: 46,
                              child: Icon(Icons.close,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '4 · 4 · 4',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Breathing orb
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      final phase = _phaseFor(_controller.value);
                      final cycles =
                          _stopwatch.elapsed.inSeconds ~/ 12 + 1;
                      return Column(
                        children: [
                          Transform.scale(
                            scale: phase.scale,
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.85),
                                    widget.vibe.accent
                                        .withOpacity(0.55),
                                    widget.vibe.accent
                                        .withOpacity(0.05),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.vibe.accent
                                        .withOpacity(0.35),
                                    blurRadius: 60,
                                    spreadRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Text(
                            phase.label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            phase.hint,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.65),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'cycle $cycles',
                            style: TextStyle(
                              color: widget.vibe.accent,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const Spacer(),
                  Text(
                    'follow the orb — nothing else to do',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.55),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
