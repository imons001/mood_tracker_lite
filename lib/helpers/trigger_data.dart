import 'package:flutter/material.dart';

// Combined trigger helper:
// - single source of truth
// - emoji + label + color
// - map for fast lookup
// - list for ordered UI grids

final List<Map<String, dynamic>> triggers = [
  {
    'emoji': '💻',
    'label': 'Apps / Social Media',
    'color': Colors.lightBlueAccent
  },
  {'emoji': '🍺', 'label': 'Alcohol', 'color': Colors.deepPurpleAccent},
  {
    'emoji': '🚬',
    'label': 'Cigarettes / Smoking',
    'color': Color.fromARGB(255, 194, 87, 48)
  },
  {
    'emoji': '☕',
    'label': 'Coffee / Caffeine',
    'color': Color.fromARGB(255, 109, 73, 60)
  },
  {
    'emoji': '🍫',
    'label': 'Chocolate / Sugar',
    'color': Color.fromARGB(255, 83, 48, 36)
  },
  {
    'emoji': '🍔',
    'label': 'Fast Food / Junk Food',
    'color': Colors.deepOrangeAccent
  },
  {'emoji': '💰', 'label': 'Finances / Money Stress', 'color': Colors.green},
  {'emoji': '🎮', 'label': 'Gaming', 'color': Colors.cyanAccent},
  {
    'emoji': '💬',
    'label': 'Gossip / Overthinking / Arguments',
    'color': Colors.blueAccent
  },
  {'emoji': '🏠', 'label': 'Home Stress', 'color': Colors.grey},
  {
    'emoji': '💤',
    'label': 'Insomnia / Fatigue',
    'color': Colors.lightBlueAccent
  },
  {'emoji': '💼', 'label': 'Job / Work', 'color': Colors.blueGrey},
  {
    'emoji': '💔',
    'label': 'Loneliness / Heartbreak',
    'color': Colors.redAccent
  },
  {
    'emoji': '🍕',
    'label': 'Late Night Snacks',
    'color': Colors.deepOrangeAccent
  },
  {
    'emoji': '📱',
    'label': 'Phone Addiction / Doomscrolling',
    'color': Colors.lightBlueAccent
  },
  {'emoji': '💊', 'label': 'Drugs / Medication', 'color': Colors.purpleAccent},
  {
    'emoji': '😱',
    'label': 'Scary / Anxiety Triggers',
    'color': Colors.redAccent
  },
  {
    'emoji': '🎬',
    'label': 'TV / Binge Watching',
    'color': Colors.deepPurpleAccent
  },
  {'emoji': '🌧️', 'label': 'Weather / Gloomy Days', 'color': Colors.blueGrey},
  {'emoji': '🚗', 'label': 'Traffic / Commuting', 'color': Colors.grey},
  {'emoji': '💸', 'label': 'Spending / Shopping', 'color': Colors.lightGreen},
  {'emoji': '📚', 'label': 'Studying / Overwork', 'color': Colors.indigoAccent},
  {'emoji': '👥', 'label': 'Social Pressure', 'color': Colors.teal},
  {
    'emoji': '🕒',
    'label': 'Time Pressure / Deadlines',
    'color': Colors.purpleAccent
  },
  {'emoji': '🍷', 'label': 'Wine / Drinking', 'color': Colors.purpleAccent},
  {'emoji': '💡', 'label': 'Overthinking / Ideas', 'color': Colors.amber},
  {'emoji': '🎧', 'label': 'Loud Music / Noise', 'color': Colors.blueAccent},
  {
    'emoji': '💉',
    'label': 'Medical / Doctor Anxiety',
    'color': Colors.deepPurpleAccent
  },
  {'emoji': '🔥', 'label': 'Anger / Conflict', 'color': Colors.red},
  {
    'emoji': '🛒',
    'label': 'Shopping / Overspending',
    'color': Colors.amberAccent
  },
];

// O(1) lookup map for colors / labels / halos
final Map<String, Map<String, dynamic>> triggerByEmoji = {
  for (final trigger in triggers) trigger['emoji']: trigger,
};
