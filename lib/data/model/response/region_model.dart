class RegionModel {
  int regionId;
  int capitalCityId;
  String code;
  String nameAr;
  String nameEn;
  int population;
  String latitude;
  String longitude;

  RegionModel(
      {this.regionId,
        this.capitalCityId,
        this.code,
        this.nameAr,
        this.nameEn,
        this.population,this.latitude,
        this.longitude});

  RegionModel.fromJson(Map<String, dynamic> json) {
    regionId = json['region_id'];
    capitalCityId = json['capital_city_id'];
    code = json['code'];
    nameAr = json['name_ar'];
    nameEn = json['name_en'];
    population = json['population'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['region_id'] = this.regionId;
    data['capital_city_id'] = this.capitalCityId;
    data['code'] = this.code;
    data['name_ar'] = this.nameAr;
    data['name_en'] = this.nameEn;
    data['population'] = this.population;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}