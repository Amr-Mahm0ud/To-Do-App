import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices {
  final GetStorage _storage = GetStorage();
  final _key = 'isDarkMode';

  _saveTheme(bool isDarkMode) => _storage.write(_key, isDarkMode);
  bool _loadTheme() {
    return _storage.read<bool>(_key) ?? false;
  }

  ThemeMode get theme => _loadTheme() ? ThemeMode.dark : ThemeMode.light;

  switchTheme() {
    Get.changeThemeMode(_loadTheme() ? ThemeMode.light : ThemeMode.dark);
    _saveTheme(!_loadTheme());
  }
}
