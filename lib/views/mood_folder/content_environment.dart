import 'package:flutter/material.dart';
import 'mood_environment.dart';

class ContentEnvironment extends MoodEnvironment {
  const ContentEnvironment({
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
          'assets/images/forest_begin.png',
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),

        // Gentle sunlight overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.yellow.withOpacity(0.25),
                Colors.transparent,
              ],
              stops: const [0.0, 0.7],
            ),
          ),
        ),
      ],
    );
  }
}
