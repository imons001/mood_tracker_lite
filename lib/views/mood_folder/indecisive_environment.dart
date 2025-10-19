import 'package:flutter/material.dart';
import 'mood_environment.dart';

class IndecisiveEnvironment extends MoodEnvironment {
  const IndecisiveEnvironment({
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
          'assets/images/forest_indecisive.png',
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ],
    );
  }
}
