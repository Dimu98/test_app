import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = ChangeNotifierProvider(
  (ref) => themeNotifier,
);

ThemeNotifier? _themeNotifier;

ThemeNotifier get themeNotifier {
  _themeNotifier ??= ThemeNotifier();
  return _themeNotifier!;
}

class ThemeNotifier extends ChangeNotifier {
  String currentTheme = "system";

  ThemeMode get themeMode {
    if (currentTheme == "light") {
      return ThemeMode.dark;
    }
    if (currentTheme == "dark") {
      return ThemeMode.light;
    } else {
      return ThemeMode.system;
    }
  }

  changeTheme(bool change) async {
    late String theme;
    if (change == true) {
      theme = "light";
    } else {
      theme = "dark";
    }
    currentTheme = theme;
    notifyListeners();
  }
}
