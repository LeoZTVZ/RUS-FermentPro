// models/bubble_count.dart
class BubbleCount {
  final int id;
  final int count;
  final int time;

  BubbleCount({required this.id, required this.count, required this.time});

  factory BubbleCount.fromMap(Map<String, dynamic> map) {
    return BubbleCount(
      id: map['id'],
      count: map['count'],
      time: map['time'],
    );
  }
}
