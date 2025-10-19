import 'package:flutter/material.dart';
import 'mood_environment.dart';

class FearEnvironment extends MoodEnvironment {
  const FearEnvironment({
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
        Image.asset(
          'assets/images/forest_fear.png',
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ],
    );
  }
}
