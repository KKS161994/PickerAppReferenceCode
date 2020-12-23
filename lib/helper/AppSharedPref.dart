import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPref {
  static const String KEY_AUTH_KEY = "authKey";

  static const String KEY_HELP_SHOWED = "helpShowed";

  static const String KEY_IS_LOGIN = "isLogin";
  static const String KEY_STAFF_NAME = "staffName";
  static const String KEY_STAFF_EMAIL = "staffEmail";
  static const String KEY_STAFF_TOKEN = "staffToken";
  static const String KEY_STAFF_AVATAR = "staffAvatar";

  // API
  static setAuthKey(String authKey) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(KEY_AUTH_KEY, authKey);
  }

  static Future<String> getAuthKey() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(KEY_AUTH_KEY) == null ? "" : sp.getString(KEY_AUTH_KEY);
  }

  static setHelpShowed(bool isLogin) async {
    final sp = await SharedPreferences.getInstance();
    sp.setBool(KEY_HELP_SHOWED, isLogin);
  }

  static Future<bool> isHelpShowed() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(KEY_HELP_SHOWED) == null
        ? false
        : sp.getBool(KEY_HELP_SHOWED);
  }

  // Customer
  static setLogin(bool isLogin) async {
    final sp = await SharedPreferences.getInstance();
    sp.setBool(KEY_IS_LOGIN, isLogin);
  }

  static Future<bool> isLoggedIn() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(KEY_IS_LOGIN) == null ? false : sp.getBool(KEY_IS_LOGIN);
  }

  static setStaffName(String name) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(KEY_STAFF_NAME, name);
  }

  static Future<String> getStaffName() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(KEY_STAFF_NAME) == null
        ? ""
        : sp.getString(KEY_STAFF_NAME);
  }

  static setStaffEmail(String name) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(KEY_STAFF_EMAIL, name);
  }

  static Future<String> getStaffEmail() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(KEY_STAFF_EMAIL) == null
        ? ""
        : sp.getString(KEY_STAFF_EMAIL);
  }

  static setStaffToken(String token) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(KEY_STAFF_TOKEN, token);
  }

  static Future<String> getStaffToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(KEY_STAFF_TOKEN) == null
        ? ""
        : sp.getString(KEY_STAFF_TOKEN);
  }

  static setStaffAvatar(String avatar) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(KEY_STAFF_AVATAR, avatar);
  }

  static Future<String> getStaffAvatar() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(KEY_STAFF_AVATAR) == null
        ? ""
        : sp.getString(KEY_STAFF_AVATAR);
  }
}
