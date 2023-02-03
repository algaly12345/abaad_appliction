class UserInfoModel {
  int id;
  String name;
  String phone;
  String email;
  String emailVerifiedAt;
  String refCode;
  String isActive;
  String userType;
  String isPhoneVerifiedAt;
  String cmFirebaseToken;
  String createdAt;
  String updatedAt;
  Userinfo userinfo;
  int estateCount;
  String image;
  Userinfo agent;

  UserInfoModel(
      {this.id,
        this.name,
        this.phone,
        this.email,
        this.emailVerifiedAt,
        this.refCode,
        this.isActive,
        this.userType,
        this.isPhoneVerifiedAt,
        this.cmFirebaseToken,
        this.createdAt,
        this.updatedAt,
        this.userinfo,
        this.estateCount,
        this.image,
        this.agent});

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    refCode = json['ref_code'];
    isActive = json['is_active'];
    userType = json['user_type'];
    isPhoneVerifiedAt = json['is_phone_verified_at'];
    cmFirebaseToken = json['cm_firebase_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
    userinfo = json['userinfo'] != null
        ? new Userinfo.fromJson(json['userinfo'])
        : null;
    estateCount = json['estate_count'];
    agent = json['agent'] != null ? new Userinfo.fromJson(json['agent']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['ref_code'] = this.refCode;
    data['is_active'] = this.isActive;
    data['user_type'] = this.userType;
    data['is_phone_verified_at'] = this.isPhoneVerifiedAt;
    data['cm_firebase_token'] = this.cmFirebaseToken;
    data['created_at'] = this.createdAt;
    data['image'] = this.image;
    data['updated_at'] = this.updatedAt;
    if (this.userinfo != null) {
      data['userinfo'] = this.userinfo.toJson();
    }
    data['estate_count'] = this.estateCount;
    if (this.agent != null) {
      data['agent'] = this.agent.toJson();
    }
    return data;
  }
}

class Userinfo {
  int id;
  String ideintity;
  String license;
  String image;
  String commercialRegisterionNo;
  int userId;
  Null createdAt;
  Null updatedAt;

  Userinfo(
      {this.id,
        this.ideintity,
        this.license,
        this.image,
        this.commercialRegisterionNo,
        this.userId,
        this.createdAt,
        this.updatedAt});

  Userinfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ideintity = json['ideintity'];
    license = json['license'];
    image = json['image'];
    commercialRegisterionNo = json['commercial_registerion_no'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ideintity'] = this.ideintity;
    data['license'] = this.license;
    data['image'] = this.image;
    data['commercial_registerion_no'] = this.commercialRegisterionNo;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
