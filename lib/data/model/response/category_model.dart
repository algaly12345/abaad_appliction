class CategoryModel {
  int id;
  String name;
  String slug;
  String position;
  String statusHome;
  String image;
  String createdAt;
  String updatedAt;

  CategoryModel(
      {this.id,
        this.name,
        this.slug,
        this.position,
        this.statusHome,
        this.image,
        this.createdAt,
        this.updatedAt});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
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
    data['slug'] = this.slug;
    data['position'] = this.position;
    data['status_home'] = this.statusHome;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}