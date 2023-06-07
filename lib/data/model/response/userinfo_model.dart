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
  double walletBalance;
  int loyaltyPoint;

  String youtube;
  String snapchat;
  String instagram;
  String website;
  String tiktok;
  String twitter;

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
        this.agent,
        this.walletBalance,
        this.loyaltyPoint,
        this.youtube,
        this.snapchat,
        this.instagram,
        this.website,
        this.tiktok,
        this.twitter});

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
    walletBalance = json['wallet_balance'].toDouble();
    loyaltyPoint = json['loyalty_point'];

    youtube = json['youtube'];
    snapchat = json['snapchat'];
    instagram = json['instagram'];
    website = json['website'];
    tiktok = json['tiktok'];
    twitter = json['twitter'];
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
    data['wallet_balance'] = this.walletBalance;
    data['loyalty_point'] = this.loyaltyPoint;
    data['youtube'] = this.youtube;
    data['snapchat'] = this.snapchat;
    data['instagram'] = this.instagram;
    data['website'] = this.website;
    data['tiktok'] = this.tiktok;
    data['twitter'] = this.twitter;


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
  String identity;
  String advertiserNo;
  String membershipType;
  String identityType;
  String image;
  String commercialRegisterionNo;
  String     userId;
  String name;
  String phone;
  String createdAt;
  String  updatedAt;

  Userinfo(
      {this.id,
        this.name,
        this.phone,
        this.identity,
        this.image,
        this.commercialRegisterionNo,
        this.userId,
        this.advertiserNo,
        this.membershipType,
        this.identityType,
        this.createdAt,
        this.updatedAt});

  Userinfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name= json['name'];
    phone= json['phone'];
    identity = json['identity'];
    image = json['image'];
    commercialRegisterionNo = json['commercial_registerion_no'];
    userId = json['user_id'];
    advertiserNo = json['advertiser_no'];
    membershipType = json['membership_type'];
    identityType = json['identity_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['identity'] = this.identity;
    data['image'] = this.image;
    data['commercial_registerion_no'] = this.commercialRegisterionNo;
    data['user_id'] = this.userId;
    data['name']=this.name;
    data['phone']=this.phone;
    data['advertiser_no'] = this.advertiserNo;
    data['membership_type'] = this.membershipType;
    data['identity_type'] = this.identityType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
