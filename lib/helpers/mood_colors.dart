import 'package:flutter/material.dart';

// color function to get mood color based on emoji
final Map<String, Color> moodColors = {
  '😡': Colors.redAccent,
  '😖': Colors.orangeAccent,
  '😬': Colors.yellowAccent,
  '🙄': Colors.blueGrey,
  '🙂': Colors.lightGreen,
  '😶‍🌫️': Colors.purpleAccent,
  '😕': Colors.amber,
  '😌': Colors.greenAccent,
  '🤔': Colors.indigoAccent,
  '😶': Colors.grey,
  '😒': Colors.brown,
  '🤢': Colors.green,
  '😳': Colors.pinkAccent,
  '🤗': Colors.purple,
  '😩': Colors.deepOrange,
  '😨': Colors.deepPurple,
  '😤': Colors.red,
  '😇': Colors.lightBlueAccent,
  '😔': Colors.blue,
  '😄': Colors.yellow,
  '🫥': Colors.teal,
  '😢': Colors.cyan,
  '🫶': Colors.pink,
  '🫠': Colors.lime,
  '😐': Colors.blueGrey,
  '😵': Colors.indigo,
  '😞': Colors.lightBlue,
  '😭': Colors.blueAccent,
  '🤯': Colors.orange,
  '🤒': Colors.tealAccent,
  '🥱': Colors.cyanAccent,
  '😣': Colors.redAccent,
  '😴': Colors.deepPurpleAccent,
  '🥹': Colors.pinkAccent,
  '😟': Colors.orangeAccent,
};
Color getMoodColor(String emoji) {
  return moodColors[emoji] ?? Colors.grey;
}
