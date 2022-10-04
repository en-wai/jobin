
import 'dart:convert';

import 'package:shopping_app/data/repos/user_repo.dart';
import 'package:shopping_app/models/product.dart';
import 'package:shopping_app/models/response_model.dart';
import 'package:get/get.dart';
import 'package:shopping_app/models/user_info_model.dart';
class UserController extends GetxController implements GetxService {
  final UserRepo userRepo;
  UserController({required this.userRepo});

  bool get isLoading => _isLoading;
  late UserInfoModel _userInfoModel;
  bool _isLoading = false;

  UserInfoModel get userInfoModel => _userInfoModel;

    Future<ResponseModel> getUserInfo() async {
      ResponseModel _responseModel;
      Response response = await userRepo.getUserInfo();
      if (response.statusCode == 200) {
        _userInfoModel = UserInfoModel.fromJson(response.body);

        _responseModel = ResponseModel(true, 'successful');
        _isLoading=true;
      } else {
        _responseModel = ResponseModel(false, response.statusText!);
      }
      update();
      return _responseModel;
    }


  /*Future<ResponseModel> updateUserInfo(UserInfoModel updateUserModel, String password) async {
    _isLoading = true;
    update();
    ResponseModel _responseModel;
    Response response = await userRepo.updateProfile(updateUserModel, password, _pickedFile);
    _isLoading = false;
    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.body);
      String message = map["message"];
      _userInfoModel = updateUserModel;
      _responseModel = ResponseModel(true, message);
    } else {
      _responseModel = ResponseModel(false, response.statusText);
      print('${response.statusCode} ${response.statusText}');
    }
    update();
    return _responseModel;
  }*/
/*
  Future<ResponseModel> updateUserInfo(UserInfoModel updateUserModel, String token) async {
    _isLoading = true;
    update();
    ResponseModel _responseModel;
    http.StreamedResponse response = await userRepo.updateProfile(updateUserModel, _pickedFile, token);
    _isLoading = false;
    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.stream.bytesToString());
      String message = map["message"];
      _userInfoModel = updateUserModel;
      _responseModel = ResponseModel(true, message);
      _pickedFile = null;
      getUserInfo();
      print(message);
    } else {
      _responseModel = ResponseModel(false, '${response.statusCode} ${response.reasonPhrase}');
      print('${response.statusCode} ${response.reasonPhrase}');
    }
    update();
    return _responseModel;
  }

  Future<ResponseModel> changePassword(UserInfoModel updatedUserModel) async {
    _isLoading = true;
    update();
    ResponseModel _responseModel;
    Response response = await userRepo.changePassword(updatedUserModel);
    _isLoading = false;
    if (response.statusCode == 200) {
      String message = response.body["message"];
      _responseModel = ResponseModel(true, message);
    } else {
      _responseModel = ResponseModel(false, response.statusText);
    }
    update();
    return _responseModel;
  }

  void pickImage() async {
    _pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    update();
  }

  void initData() {
    _pickedFile = null;
  }*/

}