class JournalModel {
  JournalModel({
      this.status, 
      this.data, 
      this.message,});

  JournalModel.fromJson(dynamic json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }
  bool? status;
  Data? data;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['message'] = message;
    return map;
  }

}

class Data {
  Data({
      this.items, 
      this.total, 
      this.page, 
      this.size, 
      this.pages,});

  Data.fromJson(dynamic json) {
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(Items.fromJson(v));
      });
    }
    total = json['total'];
    page = json['page'];
    size = json['size'];
    pages = json['pages'];
  }
  List<Items>? items;
  int? total;
  int? page;
  int? size;
  int? pages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (items != null) {
      map['items'] = items?.map((v) => v.toJson()).toList();
    }
    map['total'] = total;
    map['page'] = page;
    map['size'] = size;
    map['pages'] = pages;
    return map;
  }

}

class Items {
  Items({
      this.id, 
      this.userid, 
      this.title, 
      this.journalNote, 
      this.journalDate, 
      this.isDeleted, 
      this.createdAt, 
      this.updatedAt, 
      this.deletedAt,});

  Items.fromJson(dynamic json) {
    id = json['id'];
    userid = json['userid'];
    title = json['title'];
    journalNote = json['journal_note'];
    journalDate = json['journal_date'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }
  int? id;
  int? userid;
  String? title;
  String? journalNote;
  String? journalDate;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userid'] = userid;
    map['title'] = title;
    map['journal_note'] = journalNote;
    map['journal_date'] = journalDate;
    map['is_deleted'] = isDeleted;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['deleted_at'] = deletedAt;
    return map;
  }

}