import 'package:flutter/material.dart';

const primaryColor = Color(0xff9739C8);
final primaryColorTransparent = primaryColor.withOpacity(0.2);
const primaryWhite = Colors.white70;

final primaryThemeData = ThemeData(
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          elevation: MaterialStateProperty.all(1),
          backgroundColor: MaterialStateProperty.all(primaryColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          )))),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: primaryColor,
    elevation: 2,
  ),
  primaryColor: primaryColor,
  listTileTheme: const ListTileThemeData(
    textColor: primaryWhite,
    iconColor: primaryWhite,
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(color: Colors.grey[200]),
  drawerTheme: const DrawerThemeData(shadowColor: primaryColor),
  iconTheme: const IconThemeData(color: Colors.white),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryColor, unselectedItemColor: Colors.grey),
  cardTheme: const CardTheme(color: Colors.transparent),
  canvasColor: const Color(0xff11001C),
  fontFamily: 'Quicksand',
  appBarTheme: const AppBarTheme(color: primaryColor),
  hintColor: Colors.pinkAccent,
  indicatorColor: Colors.grey,
  dialogBackgroundColor: Colors.red,
  disabledColor: Colors.yellow,
  dividerColor: Colors.green,
  //highlightColor: Colors.greenAccent,
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
  hoverColor: Colors.blueGrey,
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
