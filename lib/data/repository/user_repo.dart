import 'package:abaad/data/api/api_client.dart';
import 'package:abaad/data/model/response/userinfo_model.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:image_picker/image_picker.dart';

class UserRepo {
  final ApiClient apiClient;
  UserRepo({@required this.apiClient});

  Future<Response> getUserInfo() async {
    return await apiClient.getData(AppConstants.CUSTOMER_INFO_URI);
  }

  Future<Response> updateProfile(UserInfoModel userInfoModel, XFile data, String token) async {
    Map<String, String> _body = Map();
    _body.addAll(<String, String>{
      'name': userInfoModel.name, 'email': userInfoModel.email
    });
    return await apiClient.postMultipartData(AppConstants.UPDATE_PROFILE_URI, _body, [MultipartBody('image', data)]);
  }



}