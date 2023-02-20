import 'package:abaad/data/api/api_checker.dart';
import 'package:abaad/data/model/response/banner_model.dart';
import 'package:abaad/data/model/response/land_service.dart';
import 'package:abaad/data/repository/banner_repo.dart';
import 'package:abaad/data/repository/zone_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ZoneController extends GetxController implements GetxService {
  final ZoneRepo zoneRepo;
  ZoneController({@required this.zoneRepo});
  LandModel _estateModel;
  List<Features> _estateList;

  LandModel get estateModel => _estateModel;
  List<Features> get estateList => _estateList;


  Future<void> getLandList() async {


    Response response = await zoneRepo.getLandService();
   // print("land response ...............${_estateModel.features}");
    if (response.statusCode == 200) {
    {
      print("land response ............${response.body}");
        _estateModel = LandModel.fromJson(response.body);


        _estateModel.fields = LandModel.fromJson(response.body).fields;
        _estateModel.features = LandModel.fromJson(response.body).features;
        _estateModel.features.addAll(LandModel.fromJson(response.body).features);

      }
      update();
    } else {
      ApiChecker.checkApi(response);


    }
  }
}
