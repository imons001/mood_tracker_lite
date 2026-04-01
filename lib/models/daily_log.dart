import 'mood_log.dart';
import 'trigger_log.dart';
import 'sleep_log.dart';

//daily log combines mood trigger and sleep logs for one day
class DailyLog {
  final String date; // YYYY-MM-DD key for grouping

  //multiple mood entries possible per day
  final List<MoodLog> moods;

  //multiple triggers possible per day
  final List<TriggerLog> triggers;

  //multiple sleep entries possible (nap, bedtime etc)
  final List<SleepLog> sleep;

  DailyLog({
    required this.date,
    required this.moods,
    required this.triggers,
    required this.sleep,
  });

  //convert object into map for storage (Firestore or local JSON)
  Map<String, dynamic> toMap() {
    return {
      'date': date,

      //convert each mood object into map
      'moods': moods.map((m) => m.toMap()).toList(),

      //convert triggers
      'triggers': triggers.map((t) => t.toMap()).toList(),

      //convert sleep logs
      'sleep': sleep.map((s) => s.toMap()).toList(),
    };
  }

  //factory builds DailyLog from stored map data
  factory DailyLog.fromMap(Map<String, dynamic> map) {
    return DailyLog(
      date: map['date'],

      //rebuild mood objects
      moods: (map['moods'] as List).map((m) => MoodLog.fromMap(m)).toList(),

      //rebuild trigger objects
      triggers:
          (map['triggers'] as List).map((t) => TriggerLog.fromMap(t)).toList(),

      //rebuild sleep objects
      sleep: (map['sleep'] as List).map((s) => SleepLog.fromMap(s)).toList(),
    );
  }
}
