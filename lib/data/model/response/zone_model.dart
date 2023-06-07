import 'package:google_maps_flutter/google_maps_flutter.dart';

class ZoneModel {
  int id;
  String name;
  Coordinates coordinates;
  String  status;
  String latitude;
  String longitude;
  String createdAt;
  int  territory_id;
  String    estate_count;
  String updatedAt;


  ZoneModel({this.id, this.name, this.coordinates, this.status, this.createdAt, this.updatedAt ,this.latitude,
    this.longitude});

  ZoneModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    coordinates = json['coordinates'] != null ? new Coordinates.fromJson(json['coordinates']) : null;
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    territory_id = json['territory_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    estate_count = json['estate_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.coordinates != null) {
      data['coordinates'] = this.coordinates.toJson();
    }
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['territory_id'] = this.territory_id;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['estate_count'] = this.estate_count;

    return data;
  }
}

class Coordinates {
  String type;
  List<LatLng> coordinates;

  Coordinates({this.type, this.coordinates});

  Coordinates.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['coordinates'] != null) {
      coordinates = <LatLng>[];
      json['coordinates'][0].forEach((v) {
        coordinates.add(LatLng(double.parse(v[0].toString()), double.parse(v[1].toString())));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.coordinates != null) {
      data['coordinates'] = this.coordinates.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
