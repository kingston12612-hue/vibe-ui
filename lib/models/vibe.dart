import 'package:flutter/material.dart';

/// A "vibe" — a mood that repaints the whole app:
/// gradient, accent color, quote, everything follows it.
class Vibe {
  final String id;
  final String name;
  final String emoji;
  final String tagline;
  final String quote;

  /// Two or three stops used for the animated background and cards.
  final List<Color> gradient;

  /// A single highlight color (icons, small labels).
  final Color accent;

  const Vibe({
    required this.id,
    required this.name,
    required this.emoji,
    required this.tagline,
    required this.quote,
    required this.gradient,
    required this.accent,
  });
}
