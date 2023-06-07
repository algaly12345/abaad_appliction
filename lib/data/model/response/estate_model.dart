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
  String title ;
  List<Property>  property;
  String space;
  int categoryId;
  String   price;
  String ownershipType;

  int view;
  String status;
  String districts;
  List<NetworkType>  networkType;
  int height;
  int width;
  List<ServiceOffers> serviceOffers;
  String qr;
  List<String> images;
  List<String> planned;
  String arPath;
  String latitude;
  String longitude;
  int zoneId;
  String type_add;
  int territoryId;
  String  ageEstate;
  String shortDescription;
  String longDescription;
  int floors;
  String near;
  String priceNegotiation;

  String createdAt;
  String updatedAt;
  int adNumber;
  int advertiserNo;
  String nationalAddress;
  int userId;
  int estate_id;
  String city;
  String category;
  List<OtherAdvantages> otherAdvantages;
  List<Interface> interface;
  String streetSpace;
  String buildSpace;
  String documentNumber;



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
  this.type_add,
  this.territoryId,
  this.ageEstate,
  this.shortDescription,
    this.longDescription,
  this.floors,
  this.near,
    this.priceNegotiation,
    this.adNumber,
    this.advertiserNo,
    this.nationalAddress,
    this.userId,
  this.createdAt,
  this.updatedAt,
  this.estate_id,
    this.city,
    this.title,
    this.category,
    this.otherAdvantages,
    this.interface,
    this.streetSpace,
    this.buildSpace,
    this.documentNumber
  });

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

    view = json['view'];
    status = json['status'];
    districts = json['districts'];
    height = json['height'];
    estate_id=json['estate_id'];
    width = json['width'];
    if (json['service_offers'] != null) {
      serviceOffers = <ServiceOffers>[];
      json['service_offers'].forEach((v) {
        serviceOffers.add(new ServiceOffers.fromJson(v));
      });
    }
    qr = json['qr'];
    images = json['images'] != null ? json['images'].cast<String>() : [];
    planned = json['planned'] != null ? json['planned'].cast<String>() : [];
    arPath = json['ar_path'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    zoneId = json['zone_id'];
    type_add = json['type_add'];
    territoryId = json['territory_id'];
    ageEstate = json['age_estate'];
    shortDescription = json['short_description'];
    longDescription=json['long_description'];
    floors = json['floors'];
    near = json['near'];
    priceNegotiation=json['price_negotiation'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    advertiserNo = json['advertiser_no'];
    adNumber = json['ad_number'];
    nationalAddress=json['national_address'];
    city=json["city"];
    title=json["title"];
    category=json["category"];

    userId=json['user_id'];
    if (json['network_type'] != null) {
      networkType = <NetworkType>[];
      json['network_type'].forEach((v) {
        networkType.add(NetworkType.fromJson(v));
      });

    }

    if (json['other_advantages'] != null) {
      otherAdvantages = <OtherAdvantages>[];
      json['other_advantages'].forEach((v) {
        otherAdvantages.add(new OtherAdvantages.fromJson(v));
      });
    }

    if (json['interface'] != null) {
      interface = <Interface>[];
      json['interface'].forEach((v) {
        interface.add(new Interface.fromJson(v));
      });
    }
    streetSpace=json["street_space"];
    buildSpace=json["build_space"];
    documentNumber=json["document_number"];


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
    data["city"]=this.city;

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
    data['type_add'] = this.type_add;
    data['territory_id'] = this.territoryId;
    data['age_estate'] = this.ageEstate;
    data['short_description'] = this.shortDescription;
    data['floors'] = this.floors;
    data['near'] = this.near;
    data['created_at'] = this.createdAt;
    data['advertiser_no'] = this.advertiserNo;
    data['ad_number'] = this.adNumber;
    data['updated_at'] = this.updatedAt;
    data['national_address']=this.nationalAddress;
    data['user_id']=this.userId;
    data['estate_id']=this.estate_id;
    data['title']=this.title;
    data['category']=this.category;
    data["build_space"]=this.buildSpace;
    data["document_number"]=this.documentNumber;

    if (this.networkType != null) {
      data['network_type'] = this.networkType.map((v) => v.toJson()).toList();
    }


    if (this.otherAdvantages != null) {
      data['other_advantages'] =
          this.otherAdvantages.map((v) => v.toJson()).toList();
    }

    if (this.interface != null) {
      data['interface'] = this.interface.map((v) => v.toJson()).toList();
    }
    data["street_space"]=this.streetSpace;
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
  String  id;
  String title;
  String expiryDate;
  String  servicePrice;
  String description;
  String  discount;
  String sendedAt;
  String serviceTypeId;
  String offerType;
  String createdAt;
  String updatedAt;
  String image;
  String phoneProvider;
  String  category_id;
  String  offer_id;

  ServiceOffers(
      {this.id,
        this.title,
        this.expiryDate,
        this.servicePrice,
        this.description,
        this.discount,
        this.sendedAt,
        this.serviceTypeId,
        this.offerType,
        this.createdAt,
        this.updatedAt,
      this.image,


        this.phoneProvider,
      this.category_id,
      this.offer_id});

  ServiceOffers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    expiryDate = json['expiry_date'];
    servicePrice = json['service_price'];
    description = json['description'];
    discount = json['discount'];
    sendedAt = json['sended_at'];
    serviceTypeId = json['service_type_id'];
    offerType = json['offer_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
    phoneProvider  =json['phone_provider']  ;
    offer_id =json['offer_id']  ;
    category_id =json['category_id']  ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['expiry_date'] = this.expiryDate;
    data['service_price'] = this.servicePrice;
    data['description'] = this.description;
    data['discount'] = this.discount;
    data['sended_at'] = this.sendedAt;
    data['service_type_id'] = this.serviceTypeId;
    data['offer_type'] = this.offerType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['phone_provider']=this.phoneProvider;
    data['image'] = this.image;
    data['offer_id']=this.offer_id;
    data['category_id'] = this.category_id;

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

class NetworkType {
  String name;
  String image;

  NetworkType({this.name, this.image});

  NetworkType.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }


}


class OtherAdvantages {
  String name;


  OtherAdvantages({this.name});

  OtherAdvantages.fromJson(Map<String, dynamic> json) {
    name = json['name'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }


}

class Interface {
  String name;


  Interface({this.name});

  Interface.fromJson(Map<String, dynamic> json) {
    name = json['name'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }


}