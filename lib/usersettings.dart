import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class UserSettings {
  static SharedPreferences? _preferences;

  static const _keyUID = 'urlString';
  static const _keySwitch = 'switchBool';

//initializer
  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  //uid setter
  static Future setUID(String uid) async =>
      await _preferences?.setString(_keyUID, uid);

  //user key getter (remove initial key once google login complete!)
  static String getUID() => _preferences?.getString(_keyUID) ?? '';

  //switch setter
  static Future setSwitch(bool sw) async =>
      await _preferences?.setBool(_keySwitch, sw);

  static bool getSwitch() => _preferences?.getBool(_keySwitch) ?? false;
}

//provides instances for Provider!
class UserProvider extends ChangeNotifier {
  String _uid = '';
  String get uid => _uid;

  bool _sw = false;
  bool get sw => _sw;

  //initializer
  UserProvider() {
    getUID();
    getSwitch();
  }

  getUID() async {
    _uid = UserSettings.getUID();
    notifyListeners();
  }

  set uid(String value) {
    _uid = value;
    UserSettings.setUID(value);
    notifyListeners();
  }

  getSwitch() async {
    _sw = UserSettings.getSwitch();
    notifyListeners();
  }

  set sw(bool value) {
    _sw = value;
    UserSettings.setSwitch(value);
    notifyListeners();
  }

}
