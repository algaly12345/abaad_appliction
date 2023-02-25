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
  String forRent;
  String forSell;
  String territoryId;
  String ageEstate;
  String shortDescription;
  String longDescription;
  String floors;
  String near;
  String priceNegotiation;
  String nationalAddress;
  String user_id;

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
        this.forRent,
        this.forSell,
        this.territoryId,
        this.ageEstate,
        this.shortDescription,
        this.longDescription,
        this.floors,
        this.near,
        this.priceNegotiation,
        this.nationalAddress,
        this.user_id
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
    forRent = json['for_rent'];
    forSell = json['for_sell'];
    territoryId = json['territory_id'];
    ageEstate = json['age_estate'];
    shortDescription = json['short_description'];
    longDescription=json['long_description'];
    floors = json['floors'];
    near = json['near'];
    priceNegotiation=json['price_negotiation'];
    nationalAddress=json['national_address'];
    user_id=json['user_id'];

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
    data['for_rent'] = this.forRent;
    data['for_sell'] = this.forSell;
    data['territory_id'] = this.territoryId;
    data['age_estate'] = this.ageEstate;
    data['short_description'] = this.shortDescription;
    data['floors'] = this.floors;
    data['near'] = this.near;
    data['long_description']=this.longDescription;
    data['national_address']=this.nationalAddress;
    data['user_id']=this.user_id;
    return data;
  }
}
