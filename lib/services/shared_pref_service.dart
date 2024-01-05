
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref{
  SharedPref._();
  late SharedPreferences sharedPreferences;
  static SharedPref instance= SharedPref._();
  Future<void> setup()async{
    sharedPreferences= await SharedPreferences.getInstance();
  }
}



enum CacheManager{
  token;
  String get read => SharedPref.instance.sharedPreferences.getString(name)??"";

  Future<bool>write(String value)=>
      SharedPref.instance.sharedPreferences.setString(name, value);
}

enum CacheManager2{
  signOut;
  String get read => SharedPref.instance.sharedPreferences.getString(name)??"";
  Future<bool>write(String value)=>
      SharedPref.instance.sharedPreferences.setString(name, value);
}