class ProfileStats {
  final int streak;
  final int totalLogs;
  final String topMoodEmoji;
  final String topMoodlabel;
  final String topTriggerEmoji;
  final String topTriggerlabel;
  final String topSleepEmoji;
  final String topSleeplabel;

  const ProfileStats({
    required this.streak,
    required this.totalLogs,
    required this.topMoodEmoji,
    required this.topMoodlabel,
    required this.topTriggerEmoji,
    required this.topTriggerlabel,
    required this.topSleepEmoji,
    required this.topSleeplabel,
  });

  factory ProfileStats.empty() {
    return const ProfileStats(
      streak: 0,
      totalLogs: 0,
      topMoodEmoji: '',
      topMoodlabel: '',
      topTriggerEmoji: '',
      topTriggerlabel: '',
      topSleepEmoji: '',
      topSleeplabel: '',
    );
  }
}
