import 'package:flutter/material.dart';
import 'mood_environment.dart';

class CalmEnvironment extends MoodEnvironment {
  const CalmEnvironment({
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
        // Background forest (soft and peaceful)
        Image.asset(
          'assets/images/forest_calm.png',
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ],
    );
  }
}
