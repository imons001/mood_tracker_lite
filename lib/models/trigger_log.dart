//individual trigger log model
import 'package:flutter/widgets.dart';

class TriggerLog {
  final String emoji;
  final String label;
  final Color color;
  final DateTime timestamp;
  final String? note; // optional note field

  TriggerLog({
    required this.emoji,
    required this.label,
    required this.color,
    required this.timestamp,
    this.note,
  });
//to map
  Map<String, dynamic> toMap() {
    return {
      'emoji': emoji,
      'label': label,
      'color': color.value,
      'timestamp': timestamp.toIso8601String(),
      'note': note,
    };
  }

//load from map
  factory TriggerLog.fromMap(Map<String, dynamic> map) {
    return TriggerLog(
      emoji: map['emoji'],
      label: map['label'],
      color: Color(map['color']),
      timestamp: DateTime.parse(map['timestamp']),
      note: map['note'] as String?,
    );
  }
}
