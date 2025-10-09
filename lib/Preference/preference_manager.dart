import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences _sharedPrefs;
  String keyIsFCMToken = 'fcm_token';

  factory SharedPrefs() => SharedPrefs._internal();

  SharedPrefs._internal();

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  //Store FCM Token
  String get getFCMToken => _sharedPrefs.getString(keyIsFCMToken) ?? '';

  setFCMToken(value) {
    //save the data into sharedPreferences of mobile number as String
    _sharedPrefs.setString(keyIsFCMToken, value);
  }
}
