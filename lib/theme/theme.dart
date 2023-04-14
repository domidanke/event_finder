import 'package:flutter/material.dart';

const primaryColor = Color(0xff40075e);
final primaryColorTransparent = primaryColor.withOpacity(0.6);
const primaryWhite = Colors.white;

final primaryThemeData = ThemeData(
  brightness: Brightness.dark,
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          elevation: MaterialStateProperty.all(0.1),
          backgroundColor: MaterialStateProperty.all(primaryColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          )))),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      elevation: 0.1,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)))),
  primaryColor: primaryColor,
  listTileTheme: const ListTileThemeData(
    textColor: primaryWhite,
    iconColor: primaryWhite,
  ),
  sliderTheme: const SliderThemeData(
      activeTrackColor: Colors.teal,
      inactiveTrackColor: primaryWhite,
      thumbColor: Colors.teal,
      activeTickMarkColor: Colors.transparent,
      inactiveTickMarkColor: Colors.transparent),
  progressIndicatorTheme: ProgressIndicatorThemeData(
      color: primaryColor, linearTrackColor: primaryWhite.withOpacity(0.8)),
  drawerTheme: const DrawerThemeData(shadowColor: primaryColor),
  iconTheme: const IconThemeData(color: Colors.white),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    elevation: 0.1,
  ),
  cardTheme: const CardTheme(color: Colors.transparent, elevation: 0.1),
  canvasColor: const Color(0xff11001C),
  fontFamily: 'Quicksand',
  appBarTheme: const AppBarTheme(color: primaryColor),
  hintColor: Colors.pinkAccent,
  indicatorColor: Colors.yellow,
  dialogTheme: const DialogTheme(elevation: 0.1),
  dividerColor: primaryWhite,
  checkboxTheme: CheckboxThemeData(
    checkColor: MaterialStateProperty.all(primaryWhite),
    fillColor: MaterialStateProperty.all(Colors.teal),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(color: Colors.white),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 0),
    ),
  ),
  focusColor: Colors.redAccent,
  hoverColor: Colors.orange,
  shadowColor: primaryWhite,
  splashColor: primaryColor,
  textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
  textButtonTheme: TextButtonThemeData(
      style:
          ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.teal))),
);

const primaryGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment(0.8, 1),
  colors: <Color>[
    //Color(0xffa24ccd),
    //Color(0xff9739c8),
    //Color(0xff8013bd),
    //Color(0xff8b26c3),
    Color(0xff7400b8),
    Color(0xff3a015c),
    Color(0xff32004f),
    Color(0xff11001C),
    Color(0xff190028),
    Color(0xff220135),
  ],
  tileMode: TileMode.mirror,
);
