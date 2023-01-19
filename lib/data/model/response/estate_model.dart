class EstateModel {
  int totalSize;
  String limit;
  int offset;
  List<Estate> estates;

  EstateModel({this.totalSize, this.limit, this.offset, this.estates});

  EstateModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'].toString();
    offset = (json['offset'] != null && json['offset'].toString().trim().isNotEmpty) ? int.parse(json['offset'].toString()) : null;
    if (json['estate'] != null) {
      estates = [];
      json['estate'].forEach((v) {
        estates.add(new Estate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_size'] = this.totalSize;
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    if (this.estates != null) {
      data['estate'] = this.estates.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Estate {
  int id;
  String address;
  String property;
  String space;
  int categoryId;
  int price;
  String ownershipType;
  String plannedNumber;
  int view;
  String status;
  String districts;
  String networkType;
  int height;
  int width;
  String serviceOffers;
  String qr;
  List<EstateImages> images;
  String arPath;
  String latitude;
  String longitude;
  int zoneId;
  bool forRent;
  bool forSell;
  String territoryId;
  String ageEstate;
  String description;
  String floors;
  String near;
  String createdAt;
  String updatedAt;

  Estate(
  {this.id,
  this.address,
  this.property,
  this.space,
  this.categoryId,
  this.price,
  this.ownershipType,
  this.plannedNumber,
  this.view,
  this.status,
  this.districts,
  this.networkType,
  this.height,
  this.width,
  this.serviceOffers,
  this.qr,
  this.images,
  this.arPath,
  this.latitude,
  this.longitude,
  this.zoneId,
  this.forRent,
  this.forSell,
  this.territoryId,
  this.ageEstate,
  this.description,
  this.floors,
  this.near,
  this.createdAt,
  this.updatedAt});

  Estate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    property = json['property'];
    space = json['space'];
    categoryId = json['category_id'];
    price = json['price'];
    ownershipType = json['ownership_type'];
    plannedNumber = json['planned_number'];
    view = json['view'];
    status = json['status'];
    districts = json['districts'];
    networkType = json['network_type'];
    height = json['height'];
    width = json['width'];
    serviceOffers = json['service_offers'];
    qr = json['qr'];
    if (json['images'] != null) {
      images = <EstateImages>[];
      json['images'].forEach((v) {
        images.add(new EstateImages.fromJson(v));
      });
    }
    arPath = json['ar_path'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    zoneId = json['zone_id'];
    forRent = json['for_rent'];
    forSell = json['for_sell'];
    territoryId = json['territory_id'];
    ageEstate = json['age_estate'];
    description = json['description'];
    floors = json['floors'];
    near = json['near'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address'] = this.address;
    data['property'] = this.property;
    data['space'] = this.space;
    data['category_id'] = this.categoryId;
    data['price'] = this.price;
    data['ownership_type'] = this.ownershipType;
    data['planned_number'] = this.plannedNumber;
    data['view'] = this.view;
    data['status'] = this.status;
    data['districts'] = this.districts;
    data['network_type'] = this.networkType;
    data['height'] = this.height;
    data['width'] = this.width;
    data['service_offers'] = this.serviceOffers;
    data['qr'] = this.qr;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    data['ar_path'] = this.arPath;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['zone_id'] = this.zoneId;
    data['for_rent'] = this.forRent;
    data['for_sell'] = this.forSell;
    data['territory_id'] = this.territoryId;
    data['age_estate'] = this.ageEstate;
    data['description'] = this.description;
    data['floors'] = this.floors;
    data['near'] = this.near;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}


class EstateImages {
  int id;
  String image;
  String estateId;
  Null createdAt;
  Null updatedAt;

  EstateImages({this.id, this.image, this.estateId, this.createdAt, this.updatedAt});

  EstateImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    estateId = json['estate_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['estate_id'] = this.estateId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}