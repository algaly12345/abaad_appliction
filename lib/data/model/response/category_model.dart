class CategoryModel {
  int id;
  String name;
  String nameAr;
  String slug;
  String   position;
  String statusHome;
  String image;
  String createdAt;
  String updatedAt;

  CategoryModel(
      {this.id,
        this.name,
        this.nameAr,
        this.slug,
        this.position,
        this.statusHome,
        this.image,
        this.createdAt,
        this.updatedAt});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameAr=json['name_ar'];
    slug = json['slug'];
    position = json['position'];
    statusHome = json['status_home'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['name_ar'] = this.nameAr;
    data['slug'] = this.slug;
    data['position'] = this.position;
    data['status_home'] = this.statusHome;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
class Variation {
  String name;
  String type;
  String min;
  String max;
  String required;
  List<VariationOption> variationValues;

  Variation({this.name, this.type, this.min, this.max, this.required, this.variationValues});

  Variation.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    min = json['min'].toString();
    max = json['max'].toString();
    required = json['required'];
    if (json['values'] != null) {
      variationValues = [];
      json['values'].forEach((v) {
        variationValues.add(new VariationOption.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['type'] = this.type;
    data['min'] = this.min;
    data['max'] = this.max;
    data['required'] = this.required;
    if (this.variationValues != null) {
      data['values'] = this.variationValues.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VariationOption {
  String level;
  String optionPrice;

  VariationOption({this.level, this.optionPrice});

  VariationOption.fromJson(Map<String, dynamic> json) {
    level = json['label'];
    optionPrice = json['optionPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.level;
    data['optionPrice'] = this.optionPrice;
    return data;
  }
}