import 'package:flutter/material.dart';

const primaryColor = Color(0xff40075e);
final primaryColorTransparent = primaryColor.withOpacity(0.6);
const primaryWhite = Colors.white;
const primaryBackgroundColor = Color(0xff11001C);
const primaryGrey = Color(0xff2D2A30);
const secondaryColor = Color(0xff1DD9DA);

final primaryThemeData = ThemeData(
  brightness: Brightness.dark,
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          elevation: MaterialStateProperty.all(0.1),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          )))),
  primaryColor: primaryColor,
  listTileTheme: const ListTileThemeData(
    textColor: primaryWhite,
    iconColor: primaryWhite,
  ),
  badgeTheme: const BadgeThemeData(
      textColor: primaryBackgroundColor, backgroundColor: secondaryColor),
  sliderTheme: const SliderThemeData(
      activeTrackColor: secondaryColor,
      inactiveTrackColor: primaryWhite,
      thumbColor: secondaryColor,
      activeTickMarkColor: Colors.transparent,
      inactiveTickMarkColor: Colors.transparent),
  progressIndicatorTheme: ProgressIndicatorThemeData(
      color: primaryWhite, linearTrackColor: primaryWhite.withOpacity(0.8)),
  drawerTheme: const DrawerThemeData(shadowColor: primaryColor),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 0.1,
      selectedItemColor: secondaryColor,
      unselectedItemColor: primaryWhite),
  cardTheme: const CardTheme(color: Colors.transparent, elevation: 0),
  canvasColor: primaryBackgroundColor,
  fontFamily: 'Quicksand',
  appBarTheme: const AppBarTheme(color: primaryColor),
  hintColor: Colors.pinkAccent,
  indicatorColor: secondaryColor,
  dialogTheme: const DialogTheme(elevation: 0.1),
  dividerColor: primaryWhite,
  checkboxTheme: CheckboxThemeData(
    checkColor: MaterialStateProperty.all(primaryWhite),
    fillColor: MaterialStateProperty.all(secondaryColor),
  ),
  focusColor: Colors.redAccent,
  hoverColor: Colors.orange,
  shadowColor: primaryWhite,
  splashColor: primaryColor,
  dialogBackgroundColor: primaryBackgroundColor,
  textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(secondaryColor))),
);

var primaryGradient = LinearGradient(
  end: Alignment.topLeft,
  begin: Alignment.bottomRight,
  colors: [
    primaryBackgroundColor.withOpacity(0.1),
    primaryColor,
    primaryBackgroundColor.withOpacity(0.1),
  ],
);

var secondaryGradient = const LinearGradient(
  end: Alignment.topLeft,
  begin: Alignment.bottomRight,
  colors: [secondaryColor],
);
