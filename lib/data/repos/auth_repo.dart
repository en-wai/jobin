import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/data/api/api_client.dart';
import 'package:shopping_app/models/signup_body.dart';
import 'package:shopping_app/uitls/app_constants.dart';
class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.apiClient,
    required this.sharedPreferences});

  Future<Response> registration(SignUpBody signUpBody) async {
    return await apiClient.postData(
        AppConstants.REGISTER_URI, signUpBody.toJson());
  }
  Future<Response> login(String phone, String password ) async {
    return await apiClient.postData(
        AppConstants.LOGIN_URI, {"phone": phone, "password": password});
  }
  String getUserToken() {
    return sharedPreferences.getString(AppConstants.TOKEN) ?? "none";
  }
  // for  user token
  Future<bool> saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token);
    return await sharedPreferences.setString(AppConstants.TOKEN, token);
  }

  Future<Response> updateToken() async {
   late String _deviceToken;
    if (GetPlatform.isIOS) {
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
        alert: true, announcement: false, badge: true, carPlay: false,
        criticalAlert: false, provisional: false, sound: true,
      );
      if(settings.authorizationStatus == AuthorizationStatus.authorized) {
        _deviceToken = await _saveDeviceToken();
      }
    }else {
      _deviceToken = await _saveDeviceToken();
    }
    if(!GetPlatform.isWeb) {
      FirebaseMessaging.instance.subscribeToTopic(AppConstants.TOPIC);
    }
    return await apiClient.postData(AppConstants.TOKEN_URI, {"_method": "put", "cm_firebase_token": _deviceToken});
  }

  Future<String> _saveDeviceToken() async {
    String _deviceToken = '';
    if(!GetPlatform.isWeb) {
      if(GetPlatform.isIOS) {
        _deviceToken = (await FirebaseMessaging.instance.getAPNSToken())!;
      }else {
        _deviceToken = (await FirebaseMessaging.instance.getToken())!;
      }
    }
    if (_deviceToken != null) {
      print('--------Device Token---------- '+_deviceToken);
    }
    return _deviceToken;
  }
  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.TOKEN);
  }
  String getUserNumber() {
    return sharedPreferences.getString(AppConstants.USER_NUMBER) ?? "";
  }

  String getUserCountryCode() {
    return sharedPreferences.getString(AppConstants.USER_COUNTRY_CODE) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.USER_PASSWORD) ?? "";
  }
  bool clearSharedData() {

    sharedPreferences.remove(AppConstants.TOKEN);
    //sharedPreferences.setStringList(AppConstants.CART_LIST, []);
    sharedPreferences.remove(AppConstants.USER_ADDRESS);
    apiClient.token = '';
    apiClient.updateHeader('');
    return true;
  }
  // for  Remember Email
  Future<void> saveUserNumberAndPassword(String number, String password) async {
    try {
      await sharedPreferences.setString(AppConstants.USER_PASSWORD, password);
      await sharedPreferences.setString(AppConstants.USER_NUMBER, number);

    } catch (e) {
      throw e;
    }
  }
}
