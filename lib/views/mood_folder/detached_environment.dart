import 'package:flutter/material.dart';
import 'mood_environment.dart';

class DetachedEnvironment extends MoodEnvironment {
  const DetachedEnvironment({
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
        Image.asset('assets/images/forest_detached.png', fit: BoxFit.cover),
        // Soft fog overlay
      ],
    );
  }
}
