import 'mood_log.dart';
import 'trigger_log.dart';

//daily log now combines mood and trigger logs for a day
class DailyLog {
  final String date; // YYYY-MM-DD
  final List<MoodLog> moods;
  final List<TriggerLog> triggers;

  DailyLog({
    required this.date,
    required this.moods,
    required this.triggers,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'moods': moods.map((m) => m.toMap()).toList(),
      'triggers': triggers.map((t) => t.toMap()).toList(),
    };
  }

//date moods triggers
//facotry for new instance
  factory DailyLog.fromMap(Map<String, dynamic> map) {
    return DailyLog(
      date: map['date'],
      moods: (map['moods'] as List).map((m) => MoodLog.fromMap(m)).toList(),
      triggers:
          (map['triggers'] as List).map((t) => TriggerLog.fromMap(t)).toList(),
    ); //DAilyLog
  }
}
