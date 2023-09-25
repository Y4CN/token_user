import 'package:shared_preferences/shared_preferences.dart';

class ShareManager {
  static Future<void> SetStringLst(String token) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    List<String> items = await getStringLst();
    items.add(token);

    _pref.setStringList("tokensLst", items);
  }

  static Future<List<String>> getStringLst() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref.getStringList("tokensLst") ?? [];
  }

  static Future<void> SetSingleString(String token) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    _pref.setString("singleToken", token);
  }

  static Future<String> getSingleString() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    return _pref.getString("singleToken") ?? "";
  }
}
