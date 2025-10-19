import 'package:flutter/material.dart';
import 'mood_environment.dart';

class GuiltEnvironment extends MoodEnvironment {
  const GuiltEnvironment({
    super.key,
    required super.emoji,
    required super.label,
    super.existingLog,
  });

  @override
  Widget buildVisuals(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background only — no overlays, no gradients
        Image.asset(
          'assets/images/forest_guilt.png',
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ],
    );
  }
}
