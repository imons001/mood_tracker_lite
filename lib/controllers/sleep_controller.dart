import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/sleep_log.dart'; //controller
import '../helpers/sleep_data.dart'; //uh colors

//add sleep log
//save sleep log
//load sleep log
//sleep log history
class SleepController {
  //date helper
  String getFormattedDate() {
    return DateFormat('EEEE, MMM d, yyyy').format(DateTime.now());
  }

  // Save last selected sleep emoji for display on home screen
  Future<void> saveSleep(String sleep) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastSleep', sleep);
  }

  // Load last selected sleep emoji to show
  Future<String?> loadLastSleep() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('lastSleep');
  }

  // Save all logs as JSON strings
  Future<void> saveSleepLogs(List<SleepLog> logs) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = logs.map((log) => jsonEncode(log.toMap())).toList();
    await prefs.setStringList('sleepLogs', encoded);
  }

  // Load logs and decode JSON
  Future<List<SleepLog>> loadSleepLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('sleepLogs') ?? [];
    return saved.map((s) => SleepLog.fromMap(jsonDecode(s))).toList();
  }

  // Add new log and resave list
  Future<void> addLog(SleepLog newLog) async {
    final logs = await loadSleepLogs();
    logs.add(newLog);
    await saveSleepLogs(logs);
  }

  //group logs by date for daily summary
  Future<Map<String, List<SleepLog>>> getDailyLogs() async {
    final logs = await loadSleepLogs();
    final Map<String, List<SleepLog>> grouped = {};

    for (final log in logs) {
      final dateKey = DateFormat('yyyy-MM-dd').format(log.timestamp);
      grouped.putIfAbsent(dateKey, () => []);
      grouped[dateKey]!.add(log);
    }

    return grouped;
  }

  //weekly summary
  Future<List<SleepLog>> getWeeklyLogs() async {
    final logs = await loadSleepLogs();
    final oneWeekAgo = DateTime.now().subtract(const Duration(days: 7));
    return logs.where((log) => log.timestamp.isAfter(oneWeekAgo)).toList();
  }

  //30 days of logs
  Future<List<SleepLog>> getMonthlyLogs() async {
    final logs = await loadSleepLogs();
    final oneMonthAgo = DateTime.now().subtract(const Duration(days: 30));
    return logs.where((log) => log.timestamp.isAfter(oneMonthAgo)).toList();
  }

  // percentage calculation helper for sleep donut
  double calculatePercentage(int part, int total) {
    if (total == 0) return 0.0;
    return (part / total) * 100;
  }

  //get color from sleep_colors.dart
  Color getSleepColor(String emoji) {
    return sleepers.firstWhere(
      (mood) => mood['emoji'] == emoji,
      orElse: () => {'color': Colors.grey},
    )['color'] as Color;
  }
}
