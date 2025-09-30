class TaskModel {
  TaskModel({
      this.status, 
      this.data, 
      this.message,});

  TaskModel.fromJson(dynamic json) {
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
      this.subTask, 
      this.userid, 
      this.dueDate, 
      this.status, 
      this.createdAt, 
      this.deletedAt, 
      this.id, 
      this.taskCategory, 
      this.taskTitle, 
      this.priorityLevel, 
      this.arrangeType, 
      this.updatedAt, 
      this.percentage_completed,
      this.isDeleted});

  Data.fromJson(dynamic json) {
    if (json['sub_task'] != null) {
      subTask = [];
      json['sub_task'].forEach((v) {
        subTask?.add(SubTask.fromJson(v));
      });
    }
    userid = json['userid'];
    dueDate = json['due_date'];
    status = json['status'];
    createdAt = json['created_at'];
    deletedAt = json['deleted_at'];
    id = json['id'];
    taskCategory = json['task_category'];
    taskTitle = json['task_title'];
    priorityLevel = json['priority_level'];
    arrangeType = json['arrange_type'];
    updatedAt = json['updated_at'];
    isDeleted = json['is_deleted'];
    percentage_completed = json['percentage_completed'];
  }
  List<SubTask>? subTask;
  int? userid;
  String? dueDate;
  dynamic status;
  String? createdAt;
  dynamic deletedAt;
  int? id;
  String? taskCategory;
  String? taskTitle;
  String? priorityLevel;
  int? arrangeType;
  String? updatedAt;
  bool? isDeleted;
  double? percentage_completed;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (subTask != null) {
      map['sub_task'] = subTask?.map((v) => v.toJson()).toList();
    }
    map['userid'] = userid;
    map['due_date'] = dueDate;
    map['status'] = status;
    map['created_at'] = createdAt;
    map['deleted_at'] = deletedAt;
    map['id'] = id;
    map['task_category'] = taskCategory;
    map['task_title'] = taskTitle;
    map['priority_level'] = priorityLevel;
    map['arrange_type'] = arrangeType;
    map['updated_at'] = updatedAt;
    map['is_deleted'] = isDeleted;
    return map;
  }

}

class SubTask {
  SubTask({
      this.taskid, 
      this.focuseTime, 
      this.duration, 
      this.breakTime, 
      this.endDuration, 
      this.updatedAt, 
      this.isDeleted, 
      this.id, 
      this.taskName, 
      this.rounds, 
      this.status, 
      this.createdAt, 
      this.deletedAt,});

  SubTask.fromJson(dynamic json) {
    taskid = json['taskid'];
    focuseTime = json['focuse_time'];
    duration = json['duration'];
    breakTime = json['break_time'];
    endDuration = json['end_duration'];
    updatedAt = json['updated_at'];
    isDeleted = json['is_deleted'];
    id = json['id'];
    taskName = json['task_name'];
    rounds = json['rounds'];
    status = json['status'];
    createdAt = json['created_at'];
    deletedAt = json['deleted_at'];
  }
  int? taskid;
  dynamic focuseTime;
  dynamic duration;
  dynamic breakTime;
  dynamic endDuration;
  String? updatedAt;
  bool? isDeleted;
  int? id;
  String? taskName;
  dynamic rounds;
  int? status;
  String? createdAt;
  dynamic deletedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['taskid'] = taskid;
    map['focuse_time'] = focuseTime;
    map['duration'] = duration;
    map['break_time'] = breakTime;
    map['end_duration'] = endDuration;
    map['updated_at'] = updatedAt;
    map['is_deleted'] = isDeleted;
    map['id'] = id;
    map['task_name'] = taskName;
    map['rounds'] = rounds;
    map['status'] = status;
    map['created_at'] = createdAt;
    map['deleted_at'] = deletedAt;
    return map;
  }

}