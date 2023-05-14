class EstateBody {
  String address;
  String   property;
  String space;
  String categoryId;
  String price;
  String ownershipType;
  String districts;
  String networkType;
  String serviceOffers;
  String arPath;
  String latitude;
  String longitude;
  String  zoneId;
  String type_add;
  String territoryId;
  String ageEstate;
  String shortDescription;
  String longDescription;
  String floors;
  String near;
  String priceNegotiation;
  String nationalAddress;
  String facilities;
  String user_id;
  String adNumber;
  String advertiserNo;
  String city;
  String otherAdvantages;
  String interface;
  String streetSpace;
  String buildSpace;
  String documentNumber;


  EstateBody(
      {
        this.address,
        this.property,
        this.space,
        this.categoryId,
        this.price,
        this.ownershipType,
        this.districts,
        this.networkType,
        this.serviceOffers,
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
        this.nationalAddress,
        this.facilities,
        this.user_id,
        this.adNumber,
        this.advertiserNo,
        this.city,
        this.otherAdvantages,
        this.interface,
        this.streetSpace,
        this.buildSpace,
        this.documentNumber
        });

  EstateBody.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    property = json['property'];

    space = json['space'];
    categoryId = json['category_id'];
    price = json['price'];
    ownershipType = json['ownership_type'];
    districts = json['districts'];
    networkType = json['network_type'];
    serviceOffers = json['service_offers'];


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
    nationalAddress=json['national_address'];
    user_id=json['user_id'];
    facilities=json['facilities'];
    advertiserNo = json['advertiser_no'];
    adNumber = json['ad_number'];
    city=json["city"];
    otherAdvantages=json["other_advantages"];
    streetSpace=json["street_space"];
    interface=json["interface"];
    buildSpace=json["build_space"];
    documentNumber=json["document_number"];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;

    data['property'] = this.property;
    data['space'] = this.space;
    data['category_id'] = this.categoryId;
    data['price'] = this.price;
    data['price_negotiation'] = this.priceNegotiation;
    data['ownership_type'] = this.ownershipType;
    data['districts'] = this.districts;
    data['network_type'] = this.networkType;
    data['service_offers'] = this.serviceOffers;

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
    data['long_description']=this.longDescription;
    data['national_address']=this.nationalAddress;
    data['facilities']=this.facilities;
    data['user_id']=this.user_id;
    data['advertiser_no'] = this.advertiserNo;
    data['ad_number'] = this.adNumber;
    data['city']=this.city;
    data["other_advantages"]=this.otherAdvantages;
    data["interface"]=this.interface;
    data["street_space"]=this.streetSpace;
    data["build_space"]=this.buildSpace;
    data["document_number"]=this.documentNumber;
    return data;
  }
}
