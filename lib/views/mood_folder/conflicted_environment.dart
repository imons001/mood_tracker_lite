import 'package:flutter/material.dart';
import 'mood_environment.dart';

class ConflictedEnvironment extends MoodEnvironment {
  const ConflictedEnvironment({
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
        Image.asset('assets/images/forest_conflicted.png', fit: BoxFit.cover),
        // Dual-tone split light overlay
      ],
    );
  }
}
