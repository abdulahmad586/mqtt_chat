import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class Settings {
  Settings(this.box);

  Box box;

  static Future<Settings> init() async {
    var box = await Hive.openBox("settings");
    return Settings(box);
  }

  bool get isLoggedIn => box.get("isLoggedIn", defaultValue: false);
  set isLoggedIn(bool value) {
    box.put("isLoggedIn", value);
  }

  bool get isFirstTime => box.get("isFirstTime", defaultValue: true);
  set isFirstTime(bool value) {
    box.put("isFirstTime", value);
  }

  String get token => box.get("token", defaultValue: '');
  set token(String value) {
    box.put("token", value);
  }

  String get username => box.get("username", defaultValue: '');
  set username(String value) {
    box.put("username", value);
  }

  String get password => box.get("password", defaultValue: '');
  set password(String value) {
    box.put("password", value);
  }

  String get host => box.get("host", defaultValue: '');
  set host(String value) {
    box.put("host", value);
  }

  int get port => box.get("port", defaultValue: 9001);
  set port(int value) {
    box.put("port", value);
  }
}
