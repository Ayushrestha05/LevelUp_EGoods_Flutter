import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:levelup_egoods/utilities/theme_data.dart';
import 'package:levelup_egoods/utilities/user_handler.dart';

class AppTheme extends ChangeNotifier {
  String _selectedTheme = '';
  ThemeData _selectedThemeData = light;

  get selectedTheme => _selectedTheme;
  get selectedThemeData => _selectedThemeData;
  AppTheme() {
    getSelectedTheme();
  }

  getSelectedTheme() async {
    _selectedTheme = await UserHandler().getThemeData() ?? 'light';
    if (_selectedTheme == 'dark') {
      _selectedThemeData = dark;
    } else {
      _selectedThemeData = light;
    }
  }

  setSelectedTheme(String theme) {
    UserHandler().setThemeData(theme);
    _selectedTheme = theme;
    if (_selectedTheme == 'dark') {
      _selectedThemeData = dark;
    } else {
      _selectedThemeData = light;
    }
    notifyListeners();
  }
}
