final String tableScans = 'scans';

class ScanFields {
  static final List<String> values = [
    /// Add all fields
    id, result, time
  ];

  static final String id = '_id';
  static final String result = 'result';
  static final String time = 'time';
}

class Scan {
  final int? id;
  final String result;
  final DateTime createdTime;

  const Scan({
    this.id,
    required this.result,
    required this.createdTime,
  });

  Scan copy({
    int? id,
    String? result,
    DateTime? createdTime,
  }) =>
      Scan(
        id: id ?? this.id,
        result: result ?? this.result,
        createdTime: createdTime ?? this.createdTime,
      );

  static Scan fromJson(Map<String, Object?> json) => Scan(
        id: json[ScanFields.id] as int?,
        result: json[ScanFields.result] as String,
        createdTime: DateTime.parse(json[ScanFields.time] as String),
      );

  Map<String, Object?> toJson() => {
        ScanFields.id: id,
        ScanFields.result: result,
        ScanFields.time: createdTime.toIso8601String(),
      };
}
