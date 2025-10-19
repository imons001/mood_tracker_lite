//individual mood story, describe the mood, remember the mood, save the mood
// a mood has an emoji, label, date and time, note or reflection

class MoodLog {
  final String emoji;
  final String label;
  final DateTime dateTime;
  final String entryText;
  final String? bgImage;
  //maybe add bgImage for custom background per mood
  //maybe add music or soundscape for each here ?......i dunno yet

//constructor
  MoodLog({
    required this.emoji,
    required this.label,
    required this.dateTime,
    this.entryText = '',
    this.bgImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'emoji': emoji,
      'label': label,
      'dateTime': dateTime.toIso8601String(),
      'entryText': entryText,
      'bgImage': bgImage,
    };
  }

  factory MoodLog.fromMap(Map<String, dynamic> map) {
    return MoodLog(
      emoji: map['emoji'],
      label: map['label'],
      dateTime: DateTime.parse(map['dateTime']),
      entryText: map['entryText'] ?? '',
      bgImage: map['bgImage'],
    );
  }
}
