class FermentRecordModel {
  final String id;
  final String dateTime;
  final String deviceId;
  final int photoSensor;
  final double bottleVolume;
  final String type;

  FermentRecordModel({
    required this.id,
    required this.dateTime,
    required this.deviceId,
    required this.photoSensor,
    required this.bottleVolume,
    required this.type,
  });

  factory FermentRecordModel.fromJson(String id, Map<String, dynamic> json) {
    return FermentRecordModel(
      id: id,
      dateTime: json['dateTime'] ?? '',
      deviceId: json['deviceId'] ?? '',
      photoSensor: json['photoSensor'] is int ? json['photoSensor']
          : int.tryParse(json['photoSensor'].toString()) ?? 0,
      bottleVolume: (json['bottleVolume'] is int)
          ? (json['bottleVolume'] as int).toDouble()
          : (json['bottleVolume'] is double)
          ? json['bottleVolume']
          : double.tryParse(json['bottleVolume'].toString()) ?? 0.0,
      type: json['type'] ?? '',
    );
  }

  factory FermentRecordModel.fromMap(Map<String, dynamic> map) {
    return FermentRecordModel(
      id: map['id'],
      dateTime: map['dateTime'],
      deviceId: map['deviceId'],
      photoSensor: map['photoSensor'],
      bottleVolume: map['bottleVolume'],
      type: map['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dateTime': dateTime,
      'deviceId': deviceId,
      'photoSensor': photoSensor,
      'bottleVolume': bottleVolume,
      'type': type,
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
