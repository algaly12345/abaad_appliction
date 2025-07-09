class EstateBody {
  String id ;
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
  String feature;
  String property_type;
  String estate_type;
  String  authorization_number;
  String propertyFace;
  String deedNumber;
  String categoryName;
  String totalPrice;
  String advertisementType;
  String postalCode;
  String planNumber;
  String northLimit;
  String eastLimit;
  String westLimit;
  String southLimit;

   String licenseNumber;
   String advertiserNumber;
   String idType;



  EstateBody(
      {
        this.id,
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
        this.documentNumber,
        this.feature,
        this.property_type,
        this.estate_type,
        this.authorization_number,

        this.propertyFace,
        this.deedNumber,
        this.categoryName,
        this.totalPrice,
        this.advertisementType,
        this.postalCode,
        this.planNumber,
        this.northLimit,
        this.eastLimit,
        this.westLimit,
        this.southLimit,
        this.licenseNumber,
        this.advertiserNumber,
        this.idType

      });

  EstateBody.fromJson(Map<String, dynamic> json) {
    id = json['id'];

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
    feature= json['feature'];
    property_type= json['property_type'];
    estate_type=json['estate_type'];
    authorization_number=json["authorization_number"];


    propertyFace = json['property_face'];
    deedNumber = json['deed_number'];
    categoryName = json['category_name'];
    totalPrice = json['total_price'];
    advertisementType = json['advertisement_type'];
    postalCode = json['postal_code'];
    planNumber = json['plan_number'];
    northLimit = json['north_limit'];
    eastLimit = json['east_limit'];
    westLimit = json['west_limit'];
    southLimit = json['south_limit'];

    licenseNumber = json['license_number'];
    advertiserNumber = json['advertiser_number'];
    idType = json['idType'];




  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
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
    data['feature']=this.feature;
    data['property_type']=this.property_type;
    data['estate_type']=this.estate_type;
    data["authorization_number"]=this.authorization_number;

    data['property_face'] = this.propertyFace;
    data['deed_number'] = this.deedNumber;
    data['category_name'] = this.categoryName;
    data['total_price'] = this.totalPrice;
    data['advertisement_type'] = this.advertisementType;
    data['postal_code'] = this.postalCode;
    data['plan_number'] = this.planNumber;
    data['north_limit'] = this.northLimit;
    data['east_limit'] = this.eastLimit;
    data['west_limit'] = this.westLimit;
    data['south_limit'] = this.southLimit;



    data['license_number'] = this.licenseNumber;
    data['advertiser_number'] = this.advertiserNumber;
    data['idType'] = this.idType;

    return data;
  }
}
