import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mood_log.dart';
import 'package:intl/intl.dart';
//for mood colors
import '../helpers/mood_data.dart';
//data controller for mood logs and preferences

class MoodController {
  // formatted date helper
  String getFormattedDate() {
    return DateFormat('EEEE, MMM d, yyyy').format(DateTime.now());
  }

  // Save last selected mood emoji for display on home screen
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

  //Group logs by date for daily summary
  Future<Map<String, List<MoodLog>>> getDailyLogs() async {
    final logs = await loadMoodLogs();
    Map<String, List<MoodLog>> grouped = {};
    for (var log in logs) {
      String dateKey = DateFormat('yyyy-MM-dd').format(log.dateTime);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(log);
    }
    return grouped;
  }

  //Gather 7 days of logs for weekly summary
  Future<List<MoodLog>> getWeeklyLogs() async {
    final logs = await loadMoodLogs();
    final oneWeekAgo = DateTime.now().subtract(Duration(days: 7));
    return logs.where((log) => log.dateTime.isAfter(oneWeekAgo)).toList();
  }

  //Gather 30 days of logs for monthly summary
  Future<List<MoodLog>> getMonthlyLogs() async {
    final logs = await loadMoodLogs();
    final oneMonthAgo = DateTime.now().subtract(Duration(days: 30));
    return logs.where((log) => log.dateTime.isAfter(oneMonthAgo)).toList();
  }

  //percentage calculation helper for mood chart
  double calculatePercentage(int part, int total) {
    if (total == 0) return 0.0;
    return (part / total) * 100;
  }

  //get color from mood_colors.dart
  Color getMoodColor(String emoji) {
    return mood.firstWhere(
      (mood) => mood['emoji'] == emoji,
      orElse: () => {'color': Colors.grey},
    )['color'] as Color;
  }

  //get mood percentages for charting
  //takes mood logs
  //counts how many each time appears
  //calculates percentage of total
  //add color for each mood (pulled from mood color map)
  //returns a structured list or map with mood name, color, percentage ready for chart diplay
  Future<List<Map<String, dynamic>>> summarizeLogs() async {
    // load all mood logs
    final logs = await loadMoodLogs();

    // maps for counting and storing associated emojis
    Map<String, int> moodCounts = {};
    Map<String, String> moodEmojis = {}; // remember emoji for each label

    // count occurrences and store emojis
    for (var log in logs) {
      moodCounts[log.label] = (moodCounts[log.label] ?? 0) + 1;
      moodEmojis[log.label] = log.emoji; // store the emoji for that label
    }

    // total number of logs
    int totalLogs = logs.length;

    // prepare summary list for chart data
    List<Map<String, dynamic>> summary = [];

    moodCounts.forEach((label, count) {
      summary.add({
        'label': label,
        'color': getMoodColor(moodEmojis[label]!), // look up color by emoji
        'percentage': calculatePercentage(count, totalLogs),
      });
    });

    return summary;
  }
}
