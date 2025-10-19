import 'package:flutter/material.dart';
import 'mood_environment.dart';

class EmbarrassedEnvironment extends MoodEnvironment {
  const EmbarrassedEnvironment({
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
        Image.asset('assets/images/forest_embarrassed.png', fit: BoxFit.cover),
        // Soft blue-grey overlay for sleepiness
        Container(
          color: Colors.blueGrey.withOpacity(0.35),
        ),
      ],
    );
  }
}
