import 'package:abaad/data/model/response/basic_campaign_model.dart';
import 'package:abaad/data/model/response/service_provider.dart';


class BannerModel {
  List<BasicCampaignModel> campaigns;
  List<Banner> banners;

  BannerModel({this.campaigns, this.banners});

  BannerModel.fromJson(Map<String, dynamic> json) {
    if (json['campaigns'] != null) {
      campaigns = [];
      json['campaigns'].forEach((v) {
        campaigns.add(BasicCampaignModel.fromJson(v));
      });
    }
    if (json['banners'] != null) {
      banners = [];
      json['banners'].forEach((v) {
        banners.add(Banner.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.campaigns != null) {
      data['campaigns'] = this.campaigns.map((v) => v.toJson()).toList();
    }
    if (this.banners != null) {
      data['banners'] = this.banners.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Banner {
  int id;
  String title;
  String type;
  String image;
  ServiceProvider restaurant;

  Banner(
      {this.id, this.title, this.type, this.image, this.restaurant});

  Banner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    image = json['image'];
    restaurant = json['providers'] != null ? ServiceProvider.fromJson(json['providers']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['type'] = this.type;
    data['image'] = this.image;
    if (this.restaurant != null) {
      data['providers'] = this.restaurant.toJson();
    }
    return data;
  }
}
