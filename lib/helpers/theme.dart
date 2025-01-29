import 'package:flutter/material.dart';
import 'package:test_app/helpers/size.dart';

_ThemeApp? _appTheme;

_ThemeApp get theme {
  _appTheme ??= _ThemeApp();
  return _appTheme!;
}

void updateTheme() {
  _appTheme = _ThemeApp();
}

class _ThemeApp {
  Color tr = Colors.transparent;
  Color black = const Color(0xff000000);
  Color white = const Color(0xffFFFFFF);
  Color green = const Color(0xff27AE60);
  Color red = const Color(0xffEB5757);
  Color blue = const Color(0xff006FE5);
  Color yellow = const Color(0xffFFA500);
 

  TextStyle textStyle = TextStyle(
      color: Color(0xff000000),
      overflow: TextOverflow.ellipsis,
      fontSize: 15.o,
      decoration: TextDecoration.none,
      fontWeight: FontWeight.w400,
      fontFamily: "Golos");

  ThemeData light = ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Color(0xffF1F3F7),
      primaryColor: Color(0xff1A1A1A),
      // cardColor: Color(0xffFFFFFF),
      // focusColor: Color(0xff1A1A1A),
      useMaterial3: true);
  ThemeData dark = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Color(0xff1A1A1A),
      primaryColor: Color(0xffFFFFFF),
      // cardColor: Color(0xff333333),
      // focusColor: Color(0xff4D4D4D),
      useMaterial3: true
      );
}
