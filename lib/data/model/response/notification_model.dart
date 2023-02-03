class NotificationModel {
  int id;
  String title;
  String description;
  String tergat;
  String type;
  String readAt;
  int status;
  int userId;
  String createdAt;
  String updatedAt;
  int zoneId;

  NotificationModel(
      {this.id,
        this.title,
        this.description,
        this.tergat,
        this.type,
        this.readAt,
        this.status,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.zoneId});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    tergat = json['tergat'];
    type = json['type'];
    readAt = json['read_at'];
    status = json['status'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    zoneId = json['zone_id'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['tergat'] = this.tergat;
    data['type'] = this.type;
    data['read_at'] = this.readAt;
    data['status'] = this.status;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['zone_id'] = this.zoneId;
    return data;
  }
}