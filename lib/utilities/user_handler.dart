import 'package:shared_preferences/shared_preferences.dart';

class UserHandler {
  void saveLogin(String userName, String userEmail, String userToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', userName);
    await prefs.setString('user_email', userEmail);
    await prefs.setString('user_token', userToken);
  }

  Future<String?> getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token');
  }

  void loggedOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('user_token');
  }

  Future<String?> getThemeData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedTheme');
  }

  void setThemeData(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedTheme', theme);
  }
}
