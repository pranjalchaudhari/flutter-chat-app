import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{
  static String isUserLoggedInKey = "IS_USER_LOGGED_IN";
  static String userNameKey = "USER_NAME_KEY";
  static String userEmailKey = "USER_EMAIL_KEY";

  //Save Data
  static Future<bool> saveUserLoggedInKey(bool isUserLoggedIn) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(isUserLoggedInKey, isUserLoggedIn);
  }
  static Future<bool> saveUserNameKey(String userName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userNameKey, userName);
  }
  static Future<bool> saveUserEmailKey(String userEmail) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userEmailKey, userEmail);
  }
  //Get Data

  static Future<bool> getUserLoogedInKey() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getBool(isUserLoggedInKey);
  }
  static Future<String> getUserNameKey() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(userNameKey);
  }
  static Future<String> getUserEmailKey() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(userEmailKey);
  }


}