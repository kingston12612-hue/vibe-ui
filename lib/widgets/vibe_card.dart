import 'package:flutter/material.dart';

import '../models/vibe.dart';

/// Gradient card with a soft glass shine.
/// Shows a white ring and a checkmark when the vibe is active.
class VibeCard extends StatelessWidget {
  final Vibe vibe;
  final bool active;
  final VoidCallback onTap;

  const VibeCard({
    super.key,
    required this.vibe,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: active ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: vibe.gradient,
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color:
                  active ? Colors.white.withOpacity(0.7) : Colors.transparent,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: vibe.gradient.first.withOpacity(0.45),
                blurRadius: active ? 28 : 16,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -34,
                top: -34,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.10),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(vibe.emoji, style: const TextStyle(fontSize: 34)),
                        if (active)
                          const Icon(Icons.check_circle,
                              color: Colors.white, size: 20),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vibe.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          vibe.tagline,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.78),
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
