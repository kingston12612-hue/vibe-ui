import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/vibes.dart';
import '../models/vibe.dart';
import '../widgets/animated_background.dart';
import '../widgets/vibe_card.dart';
import 'vibe_ambient_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String _prefsKey = 'vibe_id';

  Vibe _active = vibes.first;

  @override
  void initState() {
    super.initState();
    _restoreVibe();
  }

  /// Brings back the vibe chosen in the previous session.
  Future<void> _restoreVibe() async {
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getString(_prefsKey);
    Vibe restored = vibes.first;
    for (final vibe in vibes) {
      if (vibe.id == savedId) {
        restored = vibe;
        break;
      }
    }
    if (mounted) {
      setState(() => _active = restored);
    }
  }

  /// Makes the vibe current, persists it, opens the ambient screen.
  Future<void> _openVibe(Vibe vibe) async {
    setState(() => _active = vibe);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, vibe.id);
    if (!mounted) return;
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 420),
        pageBuilder: (_, __, ___) => VibeAmbientScreen(vibe: vibe),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _active.gradient.first,
      body: Stack(
        children: [
          AnimatedBackground(colors: _active.gradient),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Text(
                    'vibe.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 44,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 0),
                  child: Text(
                    'pick a mood — the whole app follows',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_active.emoji,
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Text(
                          'current: ${_active.name}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.82,
                    ),
                    itemCount: vibes.length,
                    itemBuilder: (context, index) {
                      final vibe = vibes[index];
                      return VibeCard(
                        vibe: vibe,
                        active: vibe.id == _active.id,
                        onTap: () => _openVibe(vibe),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
