class WorkoutPreset {
  final String id;
  final String name;
  final String type;
  final Duration duration;
  final int dayOfWeek; // 1 = Monday, 7 = Sunday
  final int hour;
  final int minute;

  WorkoutPreset({
    required this.id,
    required this.name,
    required this.type,
    required this.duration,
    required this.dayOfWeek,
    required this.hour,
    required this.minute,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'duration': duration.inMinutes,
      'dayOfWeek': dayOfWeek,
      'hour': hour,
      'minute': minute,
    };
  }

  factory WorkoutPreset.fromJson(Map<String, dynamic> json) {
    return WorkoutPreset(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      duration: Duration(minutes: json['duration']),
      dayOfWeek: json['dayOfWeek'],
      hour: json['hour'],
      minute: json['minute'],
    );
  }

  String get dayName {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[dayOfWeek - 1];
  }

  String get timeString {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  String get durationString {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}