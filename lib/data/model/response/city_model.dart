class CityModel {
  int cityId;
  int regionId;
  String nameAr;
  String nameEn;

  CityModel({this.cityId, this.regionId, this.nameAr, this.nameEn});

  CityModel.fromJson(Map<String, dynamic> json) {
    cityId = json['city_id'];
    regionId = json['region_id'];
    nameAr = json['name_ar'];
    nameEn = json['name_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city_id'] = this.cityId;
    data['region_id'] = this.regionId;
    data['name_ar'] = this.nameAr;
    data['name_en'] = this.nameEn;
    return data;
  }
}