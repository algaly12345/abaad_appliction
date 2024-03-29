class ConfigModel {
  String businessName;
  String logo;
  String address;
  String phone;
  String email;
  BaseUrls baseUrls;


  String country;
  DefaultLocation defaultLocation;
  String appUrlAndroid;
  String appUrlIos;
//  String appUrlAndroid;
  bool customerVerification;

  double marketingCommission;
  int agentRegistration;
  String aboutUs;
  String aboutUsAr;
  String privacyPolicy;
  String privacyPolicyAr;
  String termsConditions;
  String termsConditionsAr;
  int appMinimumVersionAndroid;
  int appMinimumVersionIos;
  bool demo;
  bool maintenanceMode;
  bool phoneVerification;
  int freeTrialPeriodStatus;
  int freeTrialPeriodDay;
  BusinessPlan businessPlan;
  double adminCommission;
  String currencySymbolDirection;
  int loyaltyPointExchangeRate;
  int minimumPointToTransfer;
  String currencySymbol;
  int digitAfterDecimalPoint;
  String termsAndConditions;
  String featureAr;
  String feature;



  ConfigModel(
      {this.businessName,
        this.logo,
        this.address,
        this.phone,
        this.email,
        this.baseUrls,
        this.privacyPolicy,
        this.aboutUs,
        this.country,
        this.defaultLocation,
        this.appUrlAndroid,
        this.appUrlIos,
        this.customerVerification,
        this.appMinimumVersionAndroid,
        this.appMinimumVersionIos,
        this.termsConditions,
        this.marketingCommission,
        this.demo,
        this.maintenanceMode,
        this.agentRegistration,
        this.phoneVerification,
        this.freeTrialPeriodStatus,
        this.freeTrialPeriodDay,
        this.businessPlan,
        this.adminCommission,
        this.currencySymbolDirection,
        this.loyaltyPointExchangeRate,
        this.minimumPointToTransfer,
        this.currencySymbol,
        this.digitAfterDecimalPoint,
        this.termsAndConditions,
        this.termsConditionsAr,
this.aboutUsAr,
      this.feature,
      this.featureAr,
      this.privacyPolicyAr
      });

  ConfigModel.fromJson(Map<String, dynamic> json) {
    businessName = json['business_name'];
    logo = json['logo'];
    address = json['address'];
    phone = json['phone'];
    email = json['email'];
    baseUrls = json['base_urls'] != null ? BaseUrls.fromJson(json['base_urls']) : null;
    privacyPolicy = json['privacy_policy'];
    aboutUs = json['about_us'];
    country = json['country'];
    defaultLocation = json['default_location'] != null ? DefaultLocation.fromJson(json['default_location']) : null;
     appUrlAndroid = json['app_url_android'];
    appUrlIos = json['app_url_ios'];
    customerVerification = json['customer_verification'];
    demo = json['demo'];
    maintenanceMode = json['maintenance_mode'];
    agentRegistration = json['agent_registration'];
    customerVerification = json['customer_verification'];
    termsConditions =json["terms_conditions"];
    appMinimumVersionAndroid = json['app_minimum_version_android'];
    appMinimumVersionIos = json['app_minimum_version_ios'];

    phoneVerification = json['phone_verification'];
    marketingCommission =json['marketing_commission'];

    freeTrialPeriodStatus = json['free_trial_period_status'];
    freeTrialPeriodDay = json['free_trial_period_data'];
    businessPlan = json['business_plan'] != null ? BusinessPlan.fromJson(json['business_plan']) : null;
    adminCommission = json['admin_commission'].toDouble();
    currencySymbolDirection = json['currency_symbol_direction'];
    loyaltyPointExchangeRate = json['loyalty_point_exchange_rate'];
    minimumPointToTransfer = json['minimum_point_to_transfer'];
    currencySymbol = json['currency_symbol'];
    digitAfterDecimalPoint = json['digit_after_decimal_point'];
    termsAndConditions = json['terms_and_conditions'];
    termsConditionsAr = json['terms_condition_ar'];
    termsAndConditions = json['terms_and_conditions'];
    aboutUsAr = json['about_us_ar'];
    feature= json['feature'];
    featureAr= json['feature_ar'];
    privacyPolicyAr= json['privacy_policy_ar'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_name'] = this.businessName;
    data['logo'] = this.logo;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['email'] = this.email;
    if (this.baseUrls != null) {
      data['base_urls'] = this.baseUrls.toJson();
    }
    data['terms_conditions'] = this.termsConditions;
    data['privacy_policy'] = this.privacyPolicy;
    data['about_us'] = this.aboutUs;
    data['country'] = this.country;
    if (this.defaultLocation != null) {
      data['default_location'] = this.defaultLocation.toJson();
    }
     data['app_url_android'] = this.appUrlAndroid;
    data['app_url_ios'] = this.appUrlIos;
    data['customer_verification'] = this.customerVerification;
    data['demo'] = this.demo;
    data['maintenance_mode'] = this.maintenanceMode;
    data['customer_verification'] = this.customerVerification;
    data['app_minimum_version_android'] = this.appMinimumVersionAndroid;
    data['app_minimum_version_ios'] = this.appMinimumVersionIos;

    data['agent_registration'] = this.agentRegistration;
    data['phone_verification'] = this.phoneVerification;
    data['marketing_commission'] = this.marketingCommission;
    data['currency_symbol_direction'] = this.currencySymbolDirection;
    data['loyalty_point_exchange_rate'] = this.loyaltyPointExchangeRate;
    data['minimum_point_to_transfer'] = this.minimumPointToTransfer;
    data['currency_symbol'] = this.currencySymbol;
    data['digit_after_decimal_point'] = this.digitAfterDecimalPoint;
    data['terms_and_conditions']=this.termsAndConditions;
    data['terms_condition_ar']=this.termsConditionsAr;
    data['about_us_ar']=this.aboutUsAr;
    data['feature']=this.feature;
    data['feature_ar']=this.featureAr;
    data['privacy_policy_ar']=this.privacyPolicyAr;



    return data;
  }
}

class BaseUrls {
  String estateImageUrl;
  String categoryImageUrl;
  String customerImageUrl;
  String reviewImageUrl;
  String chatImageUrl;
  String agentImageUrl;
  String activitiesImageUrl;
  String notificationImageUrl;
  String planed;
  String provider;
  String banners;

  BaseUrls(
      {  this.estateImageUrl,
        this.categoryImageUrl,
        this.customerImageUrl,
        this.reviewImageUrl,
        this.agentImageUrl,
        this.notificationImageUrl,
        this.banners,
        this.provider,
        this.chatImageUrl,
        this.planed
      });

  BaseUrls.fromJson(Map<String, dynamic> json) {
    estateImageUrl = json['estate_image_url'];
    customerImageUrl = json['category_image_url'];
    customerImageUrl = json['customer_image_url'];
    categoryImageUrl = json['category_image_url'];
    agentImageUrl = json['agent_image_url'];
    activitiesImageUrl = json['activities_image_url'];
    notificationImageUrl = json['notification_image_url'];
    banners= json["banners"];
    provider= json["provider_image_url"];
    chatImageUrl = json['chat_image_url'];
    planed = json['planed'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['estate_image_url'] = this.estateImageUrl;
    data['category_image_url'] = this.categoryImageUrl;
    data['customer_image_url'] = this.customerImageUrl;
    data['review_image_url'] = this.reviewImageUrl;
    data['agent_image_url'] = this.agentImageUrl;
    data['activities_image_url'] = this.activitiesImageUrl;
    data['notification_image_url'] = this.notificationImageUrl;
    data['banners'] = this.banners;
    data['provider_image_url'] = this.provider;
    data['chat_image_url'] = this.chatImageUrl;
    data['planed'] = this.planed;

    return data;
  }
}

class DefaultLocation {
  String lat;
  String lng;

  DefaultLocation({this.lat, this.lng});

  DefaultLocation.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class SocialLogin {
  String loginMedium;
  bool status;

  SocialLogin({this.loginMedium, this.status});

  SocialLogin.fromJson(Map<String, dynamic> json) {
    loginMedium = json['login_medium'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login_medium'] = this.loginMedium;
    data['status'] = this.status;
    return data;
  }
}


class BusinessPlan {
  int commission;
  int subscription;

  BusinessPlan({this.commission, this.subscription});

  BusinessPlan.fromJson(Map<String, dynamic> json) {
    commission = json['commission'];
    subscription = json['subscription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commission'] = this.commission;
    data['subscription'] = this.subscription;
    return data;
  }
}