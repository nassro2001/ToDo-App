import 'package:shared_preferences/shared_preferences.dart';

class simplePreferences {
  static SharedPreferences? preferences;
  static const keyToken = "token";

  static Future init() async {
    return preferences = await SharedPreferences.getInstance();
  }

  static Future setToken(String token) async {
    return await preferences?.setString(keyToken, token);
  }

  static Future getToken() async {
    return await preferences?.getString(keyToken);
  }
}
