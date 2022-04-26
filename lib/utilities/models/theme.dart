import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:levelup_egoods/utilities/user_handler.dart';

class AppTheme extends ChangeNotifier {
  String _selectedTheme = 'light';

  get selectedTheme => _selectedTheme;
  AppTheme() {
    getSelectedTheme();
  }

  getSelectedTheme() async {
    _selectedTheme = await UserHandler().getThemeData() ?? 'light';
    notifyListeners();
  }

  setSelectedTheme(String theme) {
    UserHandler().setThemeData(theme);
    _selectedTheme = theme;
    notifyListeners();
  }
}
