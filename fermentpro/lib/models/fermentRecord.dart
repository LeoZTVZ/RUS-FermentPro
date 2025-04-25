class FermentRecordModel {
  final String id; // <- New field
  final String dateTime;
  final String deviceId;
  final int photoSensor;
  final int temperature;

  FermentRecordModel({
    required this.id,
    required this.dateTime,
    required this.deviceId,
    required this.photoSensor,
    required this.temperature,
  });

  factory FermentRecordModel.fromJson(String id, Map<String, dynamic> json) {
    return FermentRecordModel(
      id: id,
      dateTime: json['dateTime'],
      deviceId: json['deviceId'],
      photoSensor: json['photoSensor'],
      temperature: json['temperature'],
    );
  }
  factory FermentRecordModel.fromMap(Map<String, dynamic> map) {
    return FermentRecordModel(
      id: map['id'],
      dateTime: map['dateTime'],
      deviceId: map['deviceId'],
      photoSensor: map['photoSensor'],
      temperature: map['temperature'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dateTime': dateTime,
      'deviceId': deviceId,
      'photoSensor': photoSensor,
      'temperature': temperature,
    };
  }
}

class FermentRecordResponse {
  final List<FermentRecordModel> records;

  FermentRecordResponse({required this.records});

  factory FermentRecordResponse.fromJson(Map<String, dynamic> json) {
    final records = <FermentRecordModel>[];
    json.forEach((key, value) {
      records.add(FermentRecordModel.fromJson(key, value));
    });
    return FermentRecordResponse(records: records);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    for (var record in records) {
      data[record.id] = record.toJson();
    }
    return data;
  }

}
