class LandModel {
  bool exceededTransferLimit;
  List<Features> features;
  List<Fields> fields;
  String geometryType;
  SpatialReference spatialReference;
  String objectIdFieldName;
  bool hasZ;
  bool hasM;

  LandModel (
      {this.exceededTransferLimit,
        this.features,
        this.fields,
        this.geometryType,
        this.spatialReference,
        this.objectIdFieldName,
        this.hasZ,
        this.hasM});

  LandModel .fromJson(Map<String, dynamic> json) {
    exceededTransferLimit = json['exceededTransferLimit'];
    if (json['features'] != null) {
      features = <Features>[];
      json['features'].forEach((v) {
        features.add(new Features.fromJson(v));
      });
    }
    if (json['fields'] != null) {
      fields = <Fields>[];
      json['fields'].forEach((v) {
        fields.add(new Fields.fromJson(v));
      });
    }
    geometryType = json['geometryType'];
    spatialReference = json['spatialReference'] != null
        ? new SpatialReference.fromJson(json['spatialReference'])
        : null;
    objectIdFieldName = json['objectIdFieldName'];
    hasZ = json['hasZ'];
    hasM = json['hasM'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['exceededTransferLimit'] = this.exceededTransferLimit;
    if (this.features != null) {
      data['features'] = this.features.map((v) => v.toJson()).toList();
    }
    if (this.fields != null) {
      data['fields'] = this.fields.map((v) => v.toJson()).toList();
    }
    data['geometryType'] = this.geometryType;
    if (this.spatialReference != null) {
      data['spatialReference'] = this.spatialReference.toJson();
    }
    data['objectIdFieldName'] = this.objectIdFieldName;
    data['hasZ'] = this.hasZ;
    data['hasM'] = this.hasM;
    return data;
  }
}

class Features {
  Attributes attributes;
  Geometry geometry;

  Features({this.attributes, this.geometry});

  Features.fromJson(Map<String, dynamic> json) {
    attributes = json['attributes'] != null
        ? new Attributes.fromJson(json['attributes'])
        : null;
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.attributes != null) {
      data['attributes'] = this.attributes.toJson();
    }
    if (this.geometry != null) {
      data['geometry'] = this.geometry.toJson();
    }
    return data;
  }
}

class Attributes {
  String systemId;

  Attributes({this.systemId});

  Attributes.fromJson(Map<String, dynamic> json) {
    systemId = json['system_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['system_id'] = this.systemId;
    return data;
  }
}

class Geometry {
  double x;
  double y;

  Geometry({this.x, this.y});

  Geometry.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['x'] = this.x;
    data['y'] = this.y;
    return data;
  }
}

class Fields {
  String name;
  String type;
  String alias;
  int length;
  Null defaultValue;
  String modelName;
  bool visible;

  Fields(
      {this.name,
        this.type,
        this.alias,
        this.length,
        this.defaultValue,
        this.modelName,
        this.visible});

  Fields.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    alias = json['alias'];
    length = json['length'];
    defaultValue = json['defaultValue'];
    modelName = json['modelName'];
    visible = json['visible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['type'] = this.type;
    data['alias'] = this.alias;
    data['length'] = this.length;
    data['defaultValue'] = this.defaultValue;
    data['modelName'] = this.modelName;
    data['visible'] = this.visible;
    return data;
  }
}

class SpatialReference {
  int wkid;
  int latestWkid;

  SpatialReference({this.wkid, this.latestWkid});

  SpatialReference.fromJson(Map<String, dynamic> json) {
    wkid = json['wkid'];
    latestWkid = json['latestWkid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wkid'] = this.wkid;
    data['latestWkid'] = this.latestWkid;
    return data;
  }
}