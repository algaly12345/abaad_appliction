import 'package:abaad/data/model/response/estate_model.dart';

class Wishlist {
  int id;
  int userId;
  int estateId;
  String createdAt;
  String updatedAt;
  Estate estate;

  Wishlist(
      {this.id,
        this.userId,
        this.estateId,
        this.createdAt,
        this.updatedAt,
        this.estate});

  Wishlist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    estateId = json['estate_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    estate =
    json['estate'] != null ? new Estate.fromJson(json['estate']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['estate_id'] = this.estateId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.estate != null) {
      data['estate'] = this.estate.toJson();
    }
    return data;
  }
}
