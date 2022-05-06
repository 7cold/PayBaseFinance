import 'package:flutter/material.dart';
import 'package:layouts/paybase/const/colors.dart';

class ThemesPB {
  static final light = ThemeData.light().copyWith(
    textSelectionTheme: TextSelectionThemeData(
        selectionColor: Color(corPri).withAlpha(150),
        cursorColor: Color(corPri)),
    backgroundColor: Colors.white,
    checkboxTheme:
        CheckboxThemeData(fillColor: MaterialStateProperty.all(Color(corPri))),
  );

  static final dark = ThemeData.dark().copyWith(
    textSelectionTheme: TextSelectionThemeData(
        selectionColor: Color(corPri).withAlpha(150),
        cursorColor: Color(corPri)),
    backgroundColor: Color(corBackDark),
    checkboxTheme:
        CheckboxThemeData(fillColor: MaterialStateProperty.all(Color(corPri))),
  );
}
