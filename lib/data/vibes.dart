import 'package:flutter/material.dart';

import '../models/vibe.dart';

/// The mood library. Add yours at the end of the list —
/// the home grid and ambient screen pick it up automatically.
const List<Vibe> vibes = [
  Vibe(
    id: 'midnight',
    name: 'Midnight Chill',
    emoji: '🌙',
    tagline: 'late night mode',
    quote: 'Breathe slow. The night is yours.',
    gradient: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
    accent: Color(0xFF7FB3D5),
  ),
  Vibe(
    id: 'sunset',
    name: 'Sunset Drive',
    emoji: '🌇',
    tagline: 'windows down',
    quote: "Golden hour never ends if you don't want it to.",
    gradient: [Color(0xFFFF512F), Color(0xFFF09819)],
    accent: Color(0xFFFFC371),
  ),
  Vibe(
    id: 'lofi',
    name: 'Lo-fi Rain',
    emoji: '☔',
    tagline: 'cozy static',
    quote: 'Rainy beats, warm coffee, zero plans.',
    gradient: [Color(0xFF2C3E50), Color(0xFF4CA1AF)],
    accent: Color(0xFF9BE7E4),
  ),
  Vibe(
    id: 'neon',
    name: 'Neon City',
    emoji: '🌆',
    tagline: 'after midnight',
    quote: 'The lights blur into the music.',
    gradient: [Color(0xFF0F0C29), Color(0xFF302B63), Color(0xFF02AAB0)],
    accent: Color(0xFF00E5FF),
  ),
  Vibe(
    id: 'forest',
    name: 'Forest Calm',
    emoji: '🌲',
    tagline: 'deep breath',
    quote: 'Silence grows on trees here.',
    gradient: [Color(0xFF134E5E), Color(0xFF71B280)],
    accent: Color(0xFFB7E4A8),
  ),
  Vibe(
    id: 'candy',
    name: 'Cotton Candy',
    emoji: '🍬',
    tagline: 'pastel dreams',
    quote: 'Soft thoughts, softer skies.',
    gradient: [Color(0xFFEE9CA7), Color(0xFFFFDDE1)],
    accent: Color(0xFFB993D6),
  ),
];
