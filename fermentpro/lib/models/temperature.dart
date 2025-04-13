class Temperature {
  final int id;
  final int value;

  Temperature({required this.id, required this.value});

  factory Temperature.fromMap(Map<String, dynamic> map) {
    return Temperature(
      id: map['id'],
      value: map['value'],
    );
  }
}