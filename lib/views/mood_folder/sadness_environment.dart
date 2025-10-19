import 'package:flutter/material.dart';

import 'mood_environment.dart';

class SadnessEnvironment extends MoodEnvironment {
  const SadnessEnvironment({
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
        // Background: deep sadness forest
        Image.asset(
          'assets/images/forest_sadness.png',
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ],
    );
  }
}
