class DoctorModelMeeting {
  DoctorModelMeeting({
      this.status, 
      this.data, 
      this.message,});

  DoctorModelMeeting.fromJson(dynamic json) {
    status = json['status'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
    message = json['message'];
  }
  bool? status;
  List<Data>? data;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['message'] = message;
    return map;
  }

}

class Data {
  Data({
      this.title, 
      this.id, 
      this.url, 
      this.fromDatetime, 
      this.category, 
      this.doctorId, 
      this.updatedAt, 
      this.isDeleted, 
      this.description, 
      this.meetingIdFront, 
      this.userId, 
      this.status, 
      this.toDatetime, 
      this.isEmergency, 
      this.createdAt, 
      this.deletedAt,});

  Data.fromJson(dynamic json) {
    title = json['title'];
    id = json['id'];
    url = json['url'];
    fromDatetime = json['from_datetime'];
    category = json['category'];
    doctorId = json['doctor_id'];
    updatedAt = json['updated_at'];
    isDeleted = json['is_deleted'];
    description = json['description'];
    meetingIdFront = json['meeting_id_front'];
    userId = json['user_id'];
    status = json['status'];
    toDatetime = json['to_datetime'];
    isEmergency = json['is_emergency'];
    createdAt = json['created_at'];
    deletedAt = json['deleted_at'];
  }
  String? title;
  int? id;
  String? url;
  String? fromDatetime;
  int? category;
  dynamic doctorId;
  String? updatedAt;
  bool? isDeleted;
  String? description;
  dynamic meetingIdFront;
  int? userId;
  int? status;
  String? toDatetime;
  bool? isEmergency;
  String? createdAt;
  dynamic deletedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['id'] = id;
    map['url'] = url;
    map['from_datetime'] = fromDatetime;
    map['category'] = category;
    map['doctor_id'] = doctorId;
    map['updated_at'] = updatedAt;
    map['is_deleted'] = isDeleted;
    map['description'] = description;
    map['meeting_id_front'] = meetingIdFront;
    map['user_id'] = userId;
    map['status'] = status;
    map['to_datetime'] = toDatetime;
    map['is_emergency'] = isEmergency;
    map['created_at'] = createdAt;
    map['deleted_at'] = deletedAt;
    return map;
  }

}