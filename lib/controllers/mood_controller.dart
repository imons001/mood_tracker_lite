import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mood_log.dart';
import 'package:intl/intl.dart';

class MoodController {
  // formatted date helper
  String getFormattedDate() {
    return DateFormat('EEEE, MMM d, yyyy').format(DateTime.now());
  }

  // Save last selected mood emoji
  Future<void> saveMood(String mood) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastMood', mood);
  }

  // Load last selected mood emoji to show
  Future<String?> loadLastMood() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('lastMood');
  }

  // Save all logs as JSON strings
  Future<void> saveMoodLogs(List<MoodLog> logs) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = logs.map((log) => jsonEncode(log.toMap())).toList();
    await prefs.setStringList('moodLogs', encoded);
  }

  // Load logs and decode JSON
  Future<List<MoodLog>> loadMoodLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('moodLogs') ?? [];
    return saved.map((s) => MoodLog.fromMap(jsonDecode(s))).toList();
  }

  // Add new log and resave list
  Future<void> addLog(MoodLog newLog) async {
    final logs = await loadMoodLogs();
    logs.add(newLog);
    await saveMoodLogs(logs);
  }
}
