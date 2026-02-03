import 'package:flutter/material.dart';

//combines mood emoji, label, and color into a single data structure
final List<Map<String, dynamic>> mood = [
  {'emoji': '😡', 'label': 'Angry', 'color': Colors.redAccent},
  {'emoji': '😖', 'label': 'Anxious', 'color': Colors.orangeAccent},
  {'emoji': '😬', 'label': 'Awkward', 'color': Colors.yellowAccent},
  {'emoji': '🙄', 'label': 'Bored', 'color': Colors.blueGrey},
  {'emoji': '🙂', 'label': 'Calm', 'color': Colors.lightGreen},
  {'emoji': '😶‍🌫️', 'label': 'Conflicted', 'color': Colors.purpleAccent},
  {'emoji': '😕', 'label': 'Confused', 'color': Colors.indigoAccent},
  {'emoji': '😌', 'label': 'Content', 'color': Colors.tealAccent},
  {'emoji': '🤔', 'label': 'Curious', 'color': Colors.cyan},
  {'emoji': '😶', 'label': 'Detached', 'color': Colors.grey},
  {'emoji': '😒', 'label': 'Disappointed', 'color': Colors.brown},
  {'emoji': '🤢', 'label': 'Disgusted', 'color': Colors.greenAccent},
  {'emoji': '😳', 'label': 'Embarrassed', 'color': Colors.pinkAccent},
  {'emoji': '🤗', 'label': 'Excited', 'color': Colors.amberAccent},
  {
    'emoji': '😩',
    'label': 'Exhausted',
    'color': const Color.fromARGB(176, 117, 37, 12)
  },
  {'emoji': '😨', 'label': 'Fear', 'color': Colors.deepPurple},
  {
    'emoji': '😤',
    'label': 'Frustrated',
    'color': const Color.fromARGB(255, 168, 97, 15)
  },
  {'emoji': '😇', 'label': 'Grateful', 'color': Colors.lightBlueAccent},
  {
    'emoji': '😔',
    'label': 'Guilty',
    'color': const Color.fromARGB(255, 58, 41, 5)
  },
  {'emoji': '😄', 'label': 'Happy', 'color': Colors.yellow},
  {'emoji': '🫥', 'label': 'Indecisive', 'color': Colors.cyanAccent},
  {'emoji': '😢', 'label': 'Lonely', 'color': Colors.indigo},
  {'emoji': '🫶', 'label': 'Loving', 'color': Colors.pink},
  {'emoji': '🫠', 'label': 'Melting', 'color': Colors.orange},
  {'emoji': '😐', 'label': 'Neutral', 'color': Colors.blue},
  {'emoji': '😵', 'label': 'Overwhelmed', 'color': Colors.red},
  {
    'emoji': '😞',
    'label': 'Regretful',
    'color': const Color.fromARGB(255, 31, 20, 95)
  },
  {
    'emoji': '😭',
    'label': 'Sadness',
    'color': const Color.fromARGB(255, 12, 79, 99)
  },
  {'emoji': '🤯', 'label': 'Shocked', 'color': Colors.amber},
  {'emoji': '🤒', 'label': 'Sick', 'color': Colors.green},
  {
    'emoji': '🥱',
    'label': 'Sleepy',
    'color': const Color.fromARGB(255, 49, 21, 179)
  },
  {'emoji': '😣', 'label': 'Stressed', 'color': Colors.deepOrangeAccent},
  {'emoji': '😴', 'label': 'Tired', 'color': Colors.grey},
  {
    'emoji': '🥹',
    'label': 'Vulnerable',
    'color': const Color.fromARGB(255, 231, 70, 105)
  },
  {'emoji': '😟', 'label': 'Worried', 'color': Colors.teal},
];
