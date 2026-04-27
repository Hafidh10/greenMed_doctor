import 'package:flutter/material.dart';

import 'constantThemes/appBarTheme.dart';
import 'constantThemes/bottomSheetTheme.dart';
import 'constantThemes/checkBoxTheme.dart';
import 'constantThemes/elevatedButtonTheme.dart';
import 'constantThemes/textFormFieldTheme.dart';
import 'constantThemes/textTheme.dart';

class SkiiveTheme {
  SkiiveTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: SkiiveTextTheme.lightTextTheme,
    elevatedButtonTheme: SkiiveElevatedButtonTheme.lightElevatedButtonTheme,
    appBarTheme: SkiiveAppBarTheme.lightAppBarTheme,
    bottomSheetTheme: SkiiveBottomSheetTheme.lightBottomSheetTheme,
    inputDecorationTheme: SkiiveTextFormFieldTheme.lightInputDecorationTheme,
    checkboxTheme: SkiiveCheckBoxTheme.lightCheckBoxTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    textTheme: SkiiveTextTheme.darkTextTheme,
    elevatedButtonTheme: SkiiveElevatedButtonTheme.darkElevatedButtonTheme,
    appBarTheme: SkiiveAppBarTheme.darkAppBarTheme,
    bottomSheetTheme: SkiiveBottomSheetTheme.darkBottomSheetTheme,
    inputDecorationTheme: SkiiveTextFormFieldTheme.darkInputDecorationTheme,
    checkboxTheme: SkiiveCheckBoxTheme.darkCheckBoxTheme,
  );
}
