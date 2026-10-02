import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs{
  static  SharedPreferences? userSharedprefs;

  static Future<void> Init () async{
    userSharedprefs = await SharedPreferences.getInstance();
  }
}