import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/vibe.dart';
import '../services/sound_manager.dart';
import '../widgets/animated_background.dart';
import 'breathing_overlay.dart';

/// Full-screen ambient mode for the selected vibe:
/// animated gradient, soundscape, glass quote panel, mute toggle
/// and an optional guided breathing session.
class VibeAmbientScreen extends StatefulWidget {
  final Vibe vibe;

  const VibeAmbientScreen({super.key, required this.vibe});

  @override
  State<VibeAmbientScreen> createState() => _VibeAmbientScreenState();
}

class _VibeAmbientScreenState extends State<VibeAmbientScreen> {
  bool _breathing = false;
  bool _muted = false;

  @override
  void initState() {
    super.initState();
    _muted = SoundManager.instance.muted;
    SoundManager.instance.playVibe(widget.vibe.id);
  }

  @override
  void dispose() {
    SoundManager.instance.stop();
    super.dispose();
  }

  Future<void> _toggleMute() async {
    await SoundManager.instance.toggleMute();
    if (mounted) {
      setState(() => _muted = SoundManager.instance.muted);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vibe = widget.vibe;
    return Scaffold(
      backgroundColor: vibe.gradient.first,
      body: Stack(
        children: [
          AnimatedBackground(colors: vibe.gradient),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    children: [
                      _GlassButton(
                        icon: Icons.arrow_back_ios_new,
                        onTap: () => Navigator.of(context).maybePop(),
                      ),
                      const Spacer(),
                      _GlassButton(
                        icon: _muted ? Icons.volume_off : Icons.volume_up,
                        onTap: _toggleMute,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        vibe.emoji,
                        style: const TextStyle(fontSize: 26),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    vibe.emoji,
                    style: TextStyle(
                      fontSize: 96,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 30,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    vibe.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    vibe.tagline,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 28),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.18),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '\u201C${vibe.quote}\u201D',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                height: 1.4,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '— vibe ui',
                              style: TextStyle(
                                color: vibe.accent,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Breathing session entry
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Material(
                        color: Colors.white.withOpacity(0.12),
                        child: InkWell(
                          onTap: () => setState(() => _breathing = true),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 12,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.self_improvement,
                                    color: vibe.accent, size: 20),
                                const SizedBox(width: 10),
                                const Text(
                                  'breathe with me',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.graphic_eq, color: vibe.accent, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'vibe on — enjoy the gradient',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.65),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          if (_breathing)
            BreathingOverlay(
              vibe: vibe,
              onClose: () => setState(() => _breathing = false),
            ),
        ],
      ),
    );
  }
}

/// Round glassmorphic button used in the top bar.
class _GlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          color: Colors.white.withOpacity(0.12),
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              width: 46,
              height: 46,
              child: Icon(icon, color: Colors.white, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}
