import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/trigger_log.dart';
import 'package:intl/intl.dart';
//for mood colors
import '../helpers/trigger_data.dart';
//data controller for mood logs and preferences
//add triggers
//save trigger
//loadng trigger
//trigger history

class TriggerController {
  // formatted date helper
  String getFormattedDate() {
    return DateFormat('EEEE, MMM d, yyyy').format(DateTime.now());
  }

  // Save last selected mood emoji for display on home screen
  Future<void> saveTrigger(String trigger) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastTrigger', trigger);
  }

  // Load last selected trigger emoji to show
  Future<String?> loadLastTrigger() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('lastTrigger');
  }

  // Save all logs as JSON strings
  Future<void> saveTriggerLogs(List<TriggerLog> logs) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = logs.map((log) => jsonEncode(log.toMap())).toList();
    await prefs.setStringList('triggerLogs', encoded);
  }

  // Load logs and decode JSON
  Future<List<TriggerLog>> loadTriggerLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('triggerLogs') ?? [];
    return saved.map((s) => TriggerLog.fromMap(jsonDecode(s))).toList();
  }

  // Add new log and resave list
  Future<void> addLog(TriggerLog newLog) async {
    final logs = await loadTriggerLogs();
    logs.add(newLog);
    await saveTriggerLogs(logs);
  }

  //Group logs by date for daily summary
  Future<Map<String, List<TriggerLog>>> getDailyLogs() async {
    final logs = await loadTriggerLogs();
    Map<String, List<TriggerLog>> grouped = {};
    for (var log in logs) {
      String dateKey = DateFormat('yyyy-MM-dd').format(log.timestamp);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(log);
    }
    return grouped;
  }

  //Gather 7 days of logs for weekly summary
  Future<List<TriggerLog>> getWeeklyLogs() async {
    final logs = await loadTriggerLogs();
    final oneWeekAgo = DateTime.now().subtract(Duration(days: 7));
    return logs.where((log) => log.timestamp.isAfter(oneWeekAgo)).toList();
  }

  //Gather 30 days of logs for monthly summary
  Future<List<TriggerLog>> getMonthlyLogs() async {
    final logs = await loadTriggerLogs();
    final oneMonthAgo = DateTime.now().subtract(Duration(days: 30));
    return logs.where((log) => log.timestamp.isAfter(oneMonthAgo)).toList();
  }

  //percentage calculation helper for mood chart
  double calculatePercentage(int part, int total) {
    if (total == 0) return 0.0;
    return (part / total) * 100;
  }

  //get color from trigger_data.dart
  Color getTriggerColor(String emoji) {
    return triggers.firstWhere(
      (trigger) => trigger['emoji'] == emoji,
      orElse: () => {'color': Colors.grey},
    )['color'] as Color;
  }

  //get trigger percentages for charting
  //takes trigger logs
  //counts how many each time appears
  //calculates percentage of total
  //add color for each trigger (pulled from trigger color map)
  //returns a structured list or map with trigger name, color, percentage ready for chart display
  Future<List<Map<String, dynamic>>> summarizeLogs() async {
    // load all trigger logs
    final logs = await loadTriggerLogs();

    // maps for counting and storing associated emojis
    Map<String, int> triggerCounts = {};
    Map<String, String> triggerEmojis = {}; // remember emoji for each label

    // count occurrences and store emojis
    for (var log in logs) {
      triggerCounts[log.label] = (triggerCounts[log.label] ?? 0) + 1;
      triggerEmojis[log.label] = log.emoji; // store the emoji for that label
    }

    // total number of logs
    int totalLogs = logs.length;

    // prepare summary list for chart data
    List<Map<String, dynamic>> summary = [];

    triggerCounts.forEach((label, count) {
      summary.add({
        'label': label,
        'color':
            getTriggerColor(triggerEmojis[label]!), // look up color by emoji
        'percentage': calculatePercentage(count, totalLogs),
      });
    });

    return summary;
  }
}
