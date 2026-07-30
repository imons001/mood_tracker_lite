import 'package:intl/intl.dart';

import '../models/profile_stats.dart';
import 'mood_controller.dart';
import 'sleep_controller.dart';
import 'trigger_controller.dart';
import 'daily_log_controller.dart';

class ProfileController {
  final MoodController moodController;
  final SleepController sleepController;
  final TriggerController triggerController;
  final DailyLogController dailyLogController;

  ProfileController({
    required this.moodController,
    required this.sleepController,
    required this.triggerController,
    required this.dailyLogController,
  });

  //pulls everything needed for the stat cards and streak badge
  Future<ProfileStats> loadStats() async {
    final moods = await moodController.loadMoodLogs();
    final sleep = await sleepController.loadSleepLogs();
    final triggers = await triggerController.loadTriggerLogs();
    final dailyLogs = await dailyLogController.loadAllDailyLogs();

    final topMood = topEntry(moods.map((m) => (m.label, m.emoji)).toList());
    final topSleep = topEntry(sleep.map((s) => (s.label, s.emoji)).toList());
    final topTrigger =
        topEntry(triggers.map((t) => (t.label, t.emoji)).toList());

    return ProfileStats(
      streak: calculateStreak(dailyLogs.map((d) => d.date).toSet()),
      totalLogs: moods.length + sleep.length + triggers.length,
      topMoodEmoji: topMood.$2,
      topMoodlabel: topMood.$1,
      topTriggerEmoji: topTrigger.$2,
      topTriggerlabel: topTrigger.$1,
      topSleepEmoji: topSleep.$2,
      topSleeplabel: topSleep.$1,
    );
  }

  //generic "most frequent label" helper, shared by mood, sleep, and trigger stats
  (String, String) topEntry(List<(String, String)> entries) {
    if (entries.isEmpty) return ('No logs yet', '—');

    final counts = <String, int>{};
    final emojis = <String, String>{};

    for (final e in entries) {
      counts[e.$1] = (counts[e.$1] ?? 0) + 1;
      emojis[e.$1] = e.$2;
    }

    final topLabel =
        counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;

    return (topLabel, emojis[topLabel] ?? '—');
  }

  //counts consecutive days (including today) that have a daily log
  int calculateStreak(Set<String> loggedDateKeys) {
    if (loggedDateKeys.isEmpty) return 0;

    int streak = 0;
    DateTime day = DateTime.now();

    while (loggedDateKeys.contains(
      DateFormat('yyyy-MM-dd').format(day),
    )) {
      streak++;
      day = day.subtract(const Duration(days: 1));
    }

    return streak;
  }
}
