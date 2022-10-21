final String tableScans = 'scans';

class ScanFields {
  static final List<String> values = [
    /// Add all fields
    id, result, time, device
  ];

  static final String id = '_id';
  static final String result = 'result';
  static final String time = 'time';
  static final String device = 'device';
}

class Scan {
  final int? id;
  final String result;
  final DateTime createdTime;
  final String? device;
  String? fireBaseId=null;

  Scan({
    this.id,
    required this.result,
    required this.createdTime,
    this.device,
  });

  Scan copy({
    int? id,
    String? result,
    DateTime? createdTime,
    String? device,
  }) =>
      Scan(
        id: id ?? this.id,
        result: result ?? this.result,
        createdTime: createdTime ?? this.createdTime,
        device: device ?? this.device,
      );

  static Scan fromJson(Map<String, Object?> json) => Scan(
      id: json[ScanFields.id] as int?,
      result: json[ScanFields.result] as String,
      createdTime: DateTime.parse(json[ScanFields.time] as String),
      device: json[ScanFields.device] as String);

  Map<String, Object?> toJson() => {
        ScanFields.id: id,
        ScanFields.result: result,
        ScanFields.time: createdTime.toIso8601String(),
        ScanFields.device: device,
      };
}
