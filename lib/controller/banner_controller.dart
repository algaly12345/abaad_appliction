import 'package:abaad/data/api/api_checker.dart';
import 'package:abaad/data/model/response/banner_model.dart';
import 'package:abaad/data/repository/banner_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BannerController extends GetxController implements GetxService {
  final BannerRepo bannerRepo;
  BannerController({@required this.bannerRepo});

  List<String> _bannerImageList;
  List<dynamic> _bannerDataList;
  int _currentIndex = 0;

  List<String> get bannerImageList => _bannerImageList;
  List<dynamic> get bannerDataList => _bannerDataList;
  int get currentIndex => _currentIndex;

  Future<void> getBannerList(bool reload,int zoneId) async {
    if(_bannerImageList == null || reload) {
      Response response = await bannerRepo.getBannerList(zoneId);
      if (response.statusCode == 200) {
        _bannerImageList = [];
        _bannerDataList = [];
        BannerModel _bannerModel = BannerModel.fromJson(response.body);
        _bannerModel.campaigns.forEach((campaign) {
          _bannerImageList.add(campaign.image);
          _bannerDataList.add(campaign);
        });
        print("-------------------------bnners${response.body}");
        _bannerModel.banners.forEach((banner) {
          _bannerImageList.add(banner.image);

        });
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

  void setCurrentIndex(int index, bool notify) {
    _currentIndex = index;
    if(notify) {
      update();
    }
  }
}
