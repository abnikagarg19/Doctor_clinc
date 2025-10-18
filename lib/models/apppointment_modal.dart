class Appointment {
  final String meetingIdFront;
  final String patientName;
  final String fromTime;
  final String description;
  final String status;
  final bool isOnline;
  final String tag;

  Appointment(
      {required this.meetingIdFront,
      required this.patientName,
      required this.fromTime,
      required this.description,
      required this.status,
      required this.isOnline,
      required this.tag});

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      meetingIdFront: json['meeting_id_front'] ?? '',
      patientName: json['patient_name'] ?? 'Unknown Patient',
      fromTime: json['from_time'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'confirmed',
      isOnline: json['is_online'] ?? false,
      tag: json['tag'] ?? "tag",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meeting_id_front': meetingIdFront,
      'patient_name': patientName,
      'from_time': fromTime,
      'description': description,
      'status': status,
      'is_online': isOnline,
      'tag': tag,
    };
  }
}
