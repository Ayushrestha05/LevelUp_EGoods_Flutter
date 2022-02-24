import 'package:flutter/material.dart';
import 'package:levelup_egoods/utilities/models/theme.dart';
import 'package:levelup_egoods/utilities/user_handler.dart';
import 'package:provider/provider.dart';

class SettingIndex extends StatelessWidget {
  const SettingIndex({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [ThemeSwitch()],
      ),
    ));
  }
}

class ThemeSwitch extends StatefulWidget {
  const ThemeSwitch({Key? key}) : super(key: key);

  @override
  _ThemeSwitchState createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch> {
  bool _isSwitched = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTheme();
  }

  void getTheme() async {
    if (await UserHandler().getThemeData() == 'light') {
      _isSwitched = false;
    } else {
      _isSwitched = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppTheme>(context);
    return Row(
      children: [
        Text('Dark Mode'),
        Spacer(),
        Switch(
            value: _isSwitched,
            onChanged: (value) {
              setState(() {
                _isSwitched = value;
                if (!_isSwitched) {
                  theme.setSelectedTheme('light');
                } else {
                  theme.setSelectedTheme('dark');
                }
              });
            }),
      ],
    );
  }
}
