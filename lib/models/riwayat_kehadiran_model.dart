// models/attendance_record.dart
class AttendanceRecord {
  final DateTime date;
  final String status;
  String clockIn;
  String clockOut;
  String? note;

  AttendanceRecord(
    this.date,
    this.status,
    this.clockIn,
    this.clockOut,
    this.note,
  );

  // Optional: Tambahkan method untuk convert ke Map/JSON jika diperlukan
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'status': status,
      'clockIn': clockIn,
      'clockOut': clockOut,
      'note': note,
    };
  }

  // Optional: Factory method untuk create dari Map/JSON
  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      DateTime.parse(json['date']),
      json['status'],
      json['clockIn'],
      json['clockOut'],
      json['note'],
    );
  }
}
