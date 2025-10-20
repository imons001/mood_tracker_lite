import 'package:flutter/material.dart';
import '../models/mood_log.dart';

// import all environment files
import '../views/mood_folder/angry_environment.dart';
import '../views/mood_folder/anxious_environment.dart';
import '../views/mood_folder/awkward_environment.dart';
import '../views/mood_folder/bored_environment.dart';
import '../views/mood_folder/calm_environment.dart';
import '../views/mood_folder/conflicted_environment.dart';
import '../views/mood_folder/confused_environment.dart';
import '../views/mood_folder/content_environment.dart';
import '../views/mood_folder/curious_environment.dart';
import '../views/mood_folder/detached_environment.dart';
import '../views/mood_folder/disappointed_environment.dart';
import '../views/mood_folder/disgusted_environment.dart';
import '../views/mood_folder/embarrassed_environment.dart';
import '../views/mood_folder/excited_environment.dart';
import '../views/mood_folder/exhausted_environment.dart';
import '../views/mood_folder/fear_environment.dart';
import '../views/mood_folder/frustrated_environment.dart';
import '../views/mood_folder/grateful_environment.dart';
import '../views/mood_folder/guilt_environment.dart';
import '../views/mood_folder/happy_environment.dart';
import '../views/mood_folder/indecisive_environment.dart';
import '../views/mood_folder/lonely_environment.dart';
import '../views/mood_folder/loving_environment.dart';
import '../views/mood_folder/melting_environment.dart';
import '../views/mood_folder/mood_environment.dart';
import '../views/mood_folder/overwhelmed_environment.dart';
import '../views/mood_folder/regretful_environment.dart';
import '../views/mood_folder/sadness_environment.dart';
import '../views/mood_folder/sick_environment.dart';
import '../views/mood_folder/shocked_environment.dart';
import '../views/mood_folder/sleepy_environment.dart';
import '../views/mood_folder/stressed_environment.dart';
import '../views/mood_folder/tired_environment.dart';
import '../views/mood_folder/vulnerable_environment.dart';
import '../views/mood_folder/worried_environment.dart';

/// Map of label -> environment widget builder
final Map<String, Widget Function(String, String, MoodLog?)> environmentMap = {
  'angry': (emoji, label, existing) =>
      AngryEnvironment(emoji: emoji, label: label, existingLog: existing),
  'anxious': (emoji, label, existing) =>
      AnxiousEnvironment(emoji: emoji, label: label, existingLog: existing),
  'awkward': (emoji, label, existing) =>
      AwkwardEnvironment(emoji: emoji, label: label, existingLog: existing),
  'bored': (emoji, label, existing) =>
      BoredEnvironment(emoji: emoji, label: label, existingLog: existing),
  'calm': (emoji, label, existing) =>
      CalmEnvironment(emoji: emoji, label: label, existingLog: existing),
  'conflicted': (emoji, label, existing) =>
      ConflictedEnvironment(emoji: emoji, label: label, existingLog: existing),
  'confused': (emoji, label, existing) =>
      ConfusedEnvironment(emoji: emoji, label: label, existingLog: existing),
  'content': (emoji, label, existing) =>
      ContentEnvironment(emoji: emoji, label: label, existingLog: existing),
  'curious': (emoji, label, existing) =>
      CuriousEnvironment(emoji: emoji, label: label, existingLog: existing),
  'detached': (emoji, label, existing) =>
      DetachedEnvironment(emoji: emoji, label: label, existingLog: existing),
  'disappointed': (emoji, label, existing) => DisappointedEnvironment(
      emoji: emoji, label: label, existingLog: existing),
  'disgusted': (emoji, label, existing) =>
      DisgustedEnvironment(emoji: emoji, label: label, existingLog: existing),
  'embarrassed': (emoji, label, existing) =>
      EmbarrassedEnvironment(emoji: emoji, label: label, existingLog: existing),
  'excited': (emoji, label, existing) =>
      ExcitedEnvironment(emoji: emoji, label: label, existingLog: existing),
  'exhausted': (emoji, label, existing) =>
      ExhaustedEnvironment(emoji: emoji, label: label, existingLog: existing),
  'fear': (emoji, label, existing) =>
      FearEnvironment(emoji: emoji, label: label, existingLog: existing),
  'frustrated': (emoji, label, existing) =>
      FrustratedEnvironment(emoji: emoji, label: label, existingLog: existing),
  'grateful': (emoji, label, existing) =>
      GratefulEnvironment(emoji: emoji, label: label, existingLog: existing),
  'guilty': (emoji, label, existing) =>
      GuiltEnvironment(emoji: emoji, label: label, existingLog: existing),
  'happy': (emoji, label, existing) =>
      HappyEnvironment(emoji: emoji, label: label, existingLog: existing),
  'indecisive': (emoji, label, existing) =>
      IndecisiveEnvironment(emoji: emoji, label: label, existingLog: existing),
  'lonely': (emoji, label, existing) =>
      LonelyEnvironment(emoji: emoji, label: label, existingLog: existing),
  'loving': (emoji, label, existing) =>
      LovingEnvironment(emoji: emoji, label: label, existingLog: existing),
  'melting': (emoji, label, existing) =>
      MeltingEnvironment(emoji: emoji, label: label, existingLog: existing),
  'overwhelmed': (emoji, label, existing) =>
      OverwhelmedEnvironment(emoji: emoji, label: label, existingLog: existing),
  'regretful': (emoji, label, existing) =>
      RegretfulEnvironment(emoji: emoji, label: label, existingLog: existing),
  'sadness': (emoji, label, existing) =>
      SadnessEnvironment(emoji: emoji, label: label, existingLog: existing),
  'sick': (emoji, label, existing) =>
      SickEnvironment(emoji: emoji, label: label, existingLog: existing),
  'shocked': (emoji, label, existing) =>
      ShockedEnvironment(emoji: emoji, label: label, existingLog: existing),
  'sleepy': (emoji, label, existing) =>
      SleepyEnvironment(emoji: emoji, label: label, existingLog: existing),
  'stressed': (emoji, label, existing) =>
      StressedEnvironment(emoji: emoji, label: label, existingLog: existing),
  'tired': (emoji, label, existing) =>
      TiredEnvironment(emoji: emoji, label: label, existingLog: existing),
  'vulnerable': (emoji, label, existing) =>
      VulnerableEnvironment(emoji: emoji, label: label, existingLog: existing),
  'worried': (emoji, label, existing) =>
      WorriedEnvironment(emoji: emoji, label: label, existingLog: existing),
};

/// Returns the appropriate environment widget
Widget getEnvironmentWidget(String label, String emoji, [MoodLog? existing]) {
  final builder = environmentMap[label.toLowerCase()];
  return builder?.call(emoji, label, existing) ??
      MoodEnvironment(emoji: emoji, label: label, existingLog: existing);
}
