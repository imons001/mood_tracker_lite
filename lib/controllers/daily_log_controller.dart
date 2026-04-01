import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/daily_log.dart';
import '../models/mood_log.dart';
import '../models/trigger_log.dart';
import '../models/sleep_log.dart';

import '../controllers/mood_controller.dart';
import '../controllers/trigger_controller.dart';
import '../controllers/sleep_controller.dart';

//mood trigger sleep all in one log for a day
class DailyLogController {
  //controllers used to pull logs from each module
  final MoodController moodController;
  final TriggerController triggerController;
  final SleepController sleepController;

  //build daily log for a day by pulling from all 3 controllers
  DailyLogController({
    required this.moodController,
    required this.triggerController,
    required this.sleepController,
  });

  //format a day into yyyy-MM-dd for consistent keys
  String dateKey(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  //date helper for UI display only
  String getFormattedDate() {
    return DateFormat('EEEE, MMM d, yyyy').format(DateTime.now());
  }

  //helper to safely get current user id
  String? _getUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  //user-specific local key for one daily log
  String _dailyLogKey(String userId, String date) => 'dailyLog_${userId}_$date';

  //user-specific local key for all cached daily logs
  String _dailyLogsCacheKey(String userId) => 'dailyLogs_$userId';

  //save one daily log locally as JSON string
  Future<void> saveDailyLogLocal(DailyLog log) async {
    final userId = _getUserId();
    if (userId == null) return;

    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(log.toMap());

    //save single-day lookup
    await prefs.setString(_dailyLogKey(userId, log.date), encoded);
  }

  //save all daily logs locally as JSON list
  Future<void> saveAllDailyLogsLocal(List<DailyLog> logs) async {
    final userId = _getUserId();
    if (userId == null) return;

    final prefs = await SharedPreferences.getInstance();
    final encoded = logs.map((log) => jsonEncode(log.toMap())).toList();
    await prefs.setStringList(_dailyLogsCacheKey(userId), encoded);
  }

  //load one daily log locally by date
  Future<DailyLog?> loadDailyLogLocal(String date) async {
    final userId = _getUserId();
    if (userId == null) return null;

    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_dailyLogKey(userId, date));

    if (saved == null) return null;

    return DailyLog.fromMap(jsonDecode(saved));
  }

  //load all cached daily logs locally
  Future<List<DailyLog>> loadAllDailyLogsLocal() async {
    final userId = _getUserId();
    if (userId == null) return [];

    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_dailyLogsCacheKey(userId)) ?? [];

    return saved.map((s) => DailyLog.fromMap(jsonDecode(s))).toList();
  }

  //save one daily log to firestore
  //using .doc(log.date) gives one document per day like 2026-03-29
  Future<void> saveDailyLogToFirestore(DailyLog log) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('dailyLogs')
        .doc(log.date)
        .set(log.toMap());
  }

  //load one daily log from firestore first, fallback to local cache
  Future<DailyLog?> loadDailyLog(String date) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('dailyLogs')
          .doc(date)
          .get();

      if (!doc.exists || doc.data() == null) {
        return await loadDailyLogLocal(date);
      }

      final log = DailyLog.fromMap(doc.data()!);

      //refresh local cache for this single day
      await saveDailyLogLocal(log);

      return log;
    } catch (e) {
      return await loadDailyLogLocal(date);
    }
  }

  //load all daily logs from firestore first, fallback to local cache
  Future<List<DailyLog>> loadAllDailyLogs() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('dailyLogs')
          .get();

      final logs =
          snapshot.docs.map((doc) => DailyLog.fromMap(doc.data())).toList();

      //sort oldest to newest
      logs.sort((a, b) => a.date.compareTo(b.date));

      //refresh local cache
      await saveAllDailyLogsLocal(logs);

      return logs;
    } catch (e) {
      return await loadAllDailyLogsLocal();
    }
  }

  //group logs by date for weekly summary
  //this version actually limits to the last 7 days
  Future<Map<String, DailyLog>> getWeeklyLogs() async {
    final logs = await loadAllDailyLogs();
    final grouped = <String, DailyLog>{};
    final oneWeekAgo = DateTime.now().subtract(const Duration(days: 7));

    for (final log in logs) {
      final logDate = DateTime.parse(log.date);

      if (logDate.isAfter(oneWeekAgo)) {
        final key = DateFormat('yyyy-MM-dd').format(logDate);
        grouped[key] = log;
      }
    }

    return grouped;
  }

  //group logs by date for monthly summary
  Future<List<DailyLog>> getMonthlyLogs() async {
    final logs = await loadAllDailyLogs();
    final now = DateTime.now();

    return logs.where((log) {
      final logDate = DateTime.parse(log.date);
      return logDate.isAfter(now.subtract(const Duration(days: 30)));
    }).toList();
  }

  //build daily log for a specific day by pulling from all 3 controllers
  Future<DailyLog> buildDailyLogFor(DateTime day) async {
    final key = dateKey(day);

    final moods = await moodController.loadMoodLogs();
    final triggers = await triggerController.loadTriggerLogs();
    final sleep = await sleepController.loadSleepLogs();

    //match by formatted date string instead of comparing DateTime to String
    final moodsForDay = moods
        .where((m) => DateFormat('yyyy-MM-dd').format(m.timestamp) == key)
        .toList();

    final triggersForDay = triggers
        .where((t) => DateFormat('yyyy-MM-dd').format(t.timestamp) == key)
        .toList();

    final sleepForDay = sleep
        .where((s) => DateFormat('yyyy-MM-dd').format(s.timestamp) == key)
        .toList();

    return DailyLog(
      date: key,
      moods: moodsForDay,
      triggers: triggersForDay,
      sleep: sleepForDay,
    );
  }

  //build today's daily log and save both locally and to firestore
  Future<DailyLog> buildAndSaveToday() async {
    final log = await buildDailyLogFor(DateTime.now());

    //save local cache
    await saveDailyLogLocal(log);

    //save cloud copy
    await saveDailyLogToFirestore(log);

    return log;
  }

  //rebuild and save a specific day
  Future<DailyLog> rebuildAndSaveFor(DateTime day) async {
    final log = await buildDailyLogFor(day);

    await saveDailyLogLocal(log);
    await saveDailyLogToFirestore(log);

    return log;
  }

  //calculate percent of a specific mood inside one daily log
  double calculateMoodPercent(DailyLog log, String moodEmoji) {
    if (log.moods.isEmpty) return 0.0;

    final count = log.moods.where((m) => m.emoji == moodEmoji).length;
    return count / log.moods.length;
  }
}
