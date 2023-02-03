class ServiceProvider {
  int id;
  String name;
  String phone;
  String email;
  String identityNumber;
  String identityType;
  int serviceTypeId;
  String image;
  String password;
  String address;
  int zoneId;
  String job;
  String authToken;
  String fcmToken;
  String status;
  String active;
  String createdAt;
  String updatedAt;

  ServiceProvider(
  {this.id,
  this.name,
  this.phone,
  this.email,
  this.identityNumber,
  this.identityType,
  this.serviceTypeId,
  this.image,
  this.password,
  this.address,
  this.zoneId,
  this.job,
  this.authToken,
  this.fcmToken,
  this.status,
  this.active,
  this.createdAt,
  this.updatedAt});

  ServiceProvider.fromJson(Map<String, dynamic> json) {
  id = json['id'];
  name = json['name'];
  phone = json['phone'];
  email = json['email'];
  identityNumber = json['identity_number'];
  identityType = json['identity_type'];
  serviceTypeId = json['service_type_id'];
  image = json['image'];
  password = json['password'];
  address = json['address'];
  zoneId = json['zone_id'];
  job = json['job'];
  authToken = json['auth_token'];
  fcmToken = json['fcm_token'];
  status = json['status'];
  active = json['active'];
  createdAt = json['created_at'];
  updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = this.id;
  data['name'] = this.name;
  data['phone'] = this.phone;
  data['email'] = this.email;
  data['identity_number'] = this.identityNumber;
  data['identity_type'] = this.identityType;
  data['service_type_id'] = this.serviceTypeId;
  data['image'] = this.image;
  data['password'] = this.password;
  data['address'] = this.address;
  data['zone_id'] = this.zoneId;
  data['job'] = this.job;
  data['auth_token'] = this.authToken;
  data['fcm_token'] = this.fcmToken;
  data['status'] = this.status;
  data['active'] = this.active;
  data['created_at'] = this.createdAt;
  data['updated_at'] = this.updatedAt;
  return data;
  }
}