class Temperature {
  final int id;
  final int value;
  final int time;

  Temperature({required this.id, required this.value, this.time=15});

  factory Temperature.fromMap(Map<String, dynamic> map) {
    return Temperature(
      id: map['id'],
      value: map['value'],
      time: map['time'],
    );
  }
}