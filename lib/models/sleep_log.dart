//remember the sleep log, save the sleep log, describe sleep log
//sleep have emoji, sleep have time, sleep have description

class SleepLog {
  final String emoji;
  final String label;
  //datetime is now timestamp
  final DateTime timestamp;
  final String? note; // optional note field

  SleepLog({
    required this.emoji,
    required this.label,
    required this.timestamp,
    this.note,
  });
//place toMap
  Map<String, dynamic> toMap() {
    return {
      'emoji': emoji,
      'label': label,
      'timestamp': timestamp.toIso8601String(),
      'note': note,
    };
  }

//load from map
  factory SleepLog.fromMap(Map<String, dynamic> map) {
    return SleepLog(
      emoji: map['emoji'] as String,
      label: map['label'] as String,
      timestamp: DateTime.parse(map['timestamp']),
      note: map['note'] as String?,
    );
  }
}
