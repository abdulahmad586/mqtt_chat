import 'package:hive/hive.dart';
import 'package:chat/models/user.model.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

class HiveDBMan {
  HiveDBMan();

  static Future<bool> initHive() async {
    var directory = await pathProvider.getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    var settings = await Hive.openBox("settings");
    var auth = await Hive.openBox("auth");
    if (settings.get('firstTime', defaultValue: true)) {
      settings.put('firstTime', false);
//      createDatabase();
    }
    return true;
  }

  Future<User?> userData() async {
    var auth = await Hive.openBox("auth");
    var map = auth.get('user', defaultValue: null);
    if (map == null) return null;
    map = Map<String, dynamic>.from(map);
    return User.parseUser(map);
  }

  void saveUserData(User? user) async {
    var auth = await Hive.openBox("auth");
    if (user == null) {
      auth.delete("user");
    } else {
      auth.put("user", user.toMap());
    }
  }

  void saveKey(String? key) async {
    var auth = await Hive.openBox("auth");
    if (key == null) {
      auth.delete(key);
    } else {
      auth.put("key", key);
    }
  }

  Future<String> key() async {
    var auth = await Hive.openBox("auth");
    return auth.get("key", defaultValue: "");
  }
}
