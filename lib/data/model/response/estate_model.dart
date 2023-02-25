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
  List<Property>  property;
  String space;
  int categoryId;
  double price;
  String ownershipType;
  String planned;
  int view;
  String status;
  String districts;
  String networkType;
  int height;
  int width;
  List<ServiceOffers> serviceOffers;
  String qr;
  List<String> images;
  String arPath;
  String latitude;
  String longitude;
  int zoneId;
  int forRent;
  int forSell;
  int territoryId;
  int ageEstate;
  String shortDescription;
  String longDescription;
  int floors;
  String near;
  String priceNegotiation;
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
  this.planned,
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
  this.shortDescription,
    this.longDescription,
  this.floors,
  this.near,
    this.priceNegotiation,
  this.createdAt,
  this.updatedAt});

  Estate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    if (json['property'] != null) {
      property = <Property>[];
      json['property'].forEach((v) {
        property.add(new Property.fromJson(v));
      });
    }
    space = json['space'];
    categoryId = json['category_id'];
    price = json['price'];
    ownershipType = json['ownership_type'];
    planned = json['planned'];
    view = json['view'];
    status = json['status'];
    districts = json['districts'];
    networkType = json['network_type'];
    height = json['height'];
    width = json['width'];
    if (json['service_offers'] != null) {
      serviceOffers = <ServiceOffers>[];
      json['service_offers'].forEach((v) {
        serviceOffers.add(new ServiceOffers.fromJson(v));
      });
    }
    qr = json['qr'];
    images = json['images'] != null ? json['images'].cast<String>() : [];
    arPath = json['ar_path'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    zoneId = json['zone_id'];
    forRent = json['for_rent'];
    forSell = json['for_sell'];
    territoryId = json['territory_id'];
    ageEstate = json['age_estate'];
    shortDescription = json['short_description'];
    longDescription=json['long_description'];
    floors = json['floors'];
    near = json['near'];
    priceNegotiation=json['price_negotiation'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address'] = this.address;
    if (this.property != null) {
      data['property'] = this.property.map((v) => v.toJson()).toList();
    }
    data['space'] = this.space;
    data['category_id'] = this.categoryId;
    data['price'] = this.price;
    data['price_negotiation'] = this.priceNegotiation;
    data['ownership_type'] = this.ownershipType;
    data['planned'] = this.planned;
    data['view'] = this.view;
    data['status'] = this.status;
    data['districts'] = this.districts;
    data['network_type'] = this.networkType;
    data['height'] = this.height;
    data['width'] = this.width;
    if (this.serviceOffers != null) {
      data['service_offers'] =
          this.serviceOffers.map((v) => v.toJson()).toList();
    }
    data['qr'] = this.qr;
    data['images'] = this.images;
    data['ar_path'] = this.arPath;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['zone_id'] = this.zoneId;
    data['for_rent'] = this.forRent;
    data['for_sell'] = this.forSell;
    data['territory_id'] = this.territoryId;
    data['age_estate'] = this.ageEstate;
    data['short_description'] = this.shortDescription;
    data['floors'] = this.floors;
    data['near'] = this.near;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['long_description']=this.longDescription;
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


class ServiceOffers {
  String offerId;
  String offerName;
  String imageCover;
  String servicePrice;
  String discount;
  String discountOrPrice;

  ServiceOffers({this.offerId, this.offerName,this.imageCover,this.servicePrice,this.discount,this.discountOrPrice});

  ServiceOffers.fromJson(Map<String, dynamic> json) {
    offerId = json['offer_id'];
    offerName = json['offer_name'];
    imageCover=json['image_cover'];
    servicePrice=json['service_price'];
    discount=json['discount'];
    discountOrPrice=json["discount_or_price"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offer_id'] = this.offerId;
    data['offer_name'] = this.offerName;
    data['image_cover']= this.imageCover;
    data['service_price']=this.servicePrice;
    data['discount']=this.discount;
    data["discount_or_price"]=this.discountOrPrice;
    return data;
  }



}


class Property {
  String id;
  String name;
  String number;
  String category_id;

  Property({this.id, this.name, this.number,this.category_id});

  Property.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    number = json['number'];
    category_id = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['number'] = this.number;
    data['category_id'] = this.category_id;
    return data;
  }
}