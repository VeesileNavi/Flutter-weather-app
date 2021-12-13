import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class Themes{
  AssetImage backgroundImageLight = AssetImage('assets/images/backgroundLight.png');
  AssetImage backgroundImageDark = AssetImage('assets/images/backgroundDark.png');
  Color primaryColorLight = Color.fromRGBO(226, 235, 255, 1);
  Color primaryColorDark = Color.fromRGBO(13, 23, 43, 1);
  Color colorLight = Colors.black;
  Color colorDark = Colors.white;
  Color parametersColor = Color.fromRGBO(90, 90, 90, 1);
  Color buttonColorLight = Color.fromRGBO(3, 140, 254, 1);
  Color buttonColorDark = Color.fromRGBO(13, 23, 43, 1);
  Color switcherColorLight = Color.fromRGBO(75, 95, 136, 1);
  Color switcherColorDark = Color.fromRGBO(14, 24, 44, 1);
  LinearGradient gradientWeekDark = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color.fromRGBO(34, 59, 112, 1), Color.fromRGBO(15, 31, 64, 1)]);

  LinearGradient gradientWeekLight = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color.fromRGBO(205, 218, 245, 1), Color.fromRGBO(156, 188, 255, 1)]);

  Color deleteButtonLight = Color.fromRGBO(200, 218, 255, 1);
  Color deleteButtonDark = Color.fromRGBO(21, 42, 83, 1);

  List<BoxShadow> settingsShadowLight = [
    BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.1),
    blurRadius: 10,
    offset: Offset(0, 4),
  ),
    BoxShadow(
      color: Color.fromRGBO(255, 255, 255, 0.25),
      blurRadius: 4,
      offset: Offset(0, -4),
    )
  ];

  List<BoxShadow> settingsShadowDark = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.15),
      blurRadius: 6,
      offset: Offset(4, 4),
    ),
    BoxShadow(
      color: Color.fromRGBO(255, 255, 255, 0.06),
      blurRadius: 40,
      offset: Offset(-2, -3),
    )
  ];

  List<BoxShadow> dayCardsShadowLight = [
    BoxShadow(
      color: Color.fromRGBO(58, 58, 58, 0.1),
      blurRadius: 20,
      offset: Offset(0, 7),
    ),
    BoxShadow(
      color: Color.fromRGBO(58, 58, 58, 0.1),
      blurRadius: 9,
      offset: Offset(0, -5),
    ),
  ];

  List<BoxShadow> dayCardsShadowDark = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.15),
      blurRadius: 6,
      offset: Offset(4, 4),
    ),
    BoxShadow(
      color: Color.fromRGBO(255, 255, 255, 0.05),
      blurRadius: 3,
      offset: Offset(-2, -3),
    ),
  ];

  List<BoxShadow> favouritesShadowLight = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.05),
      blurRadius: 4,
      spreadRadius: 1,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.05),
      blurRadius: 4,
      spreadRadius: 1,
      offset: Offset(0, -4),
    )
  ];

  List<BoxShadow> favouritesShadowDark = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.13),
      blurRadius: 30,
      spreadRadius: 1,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color.fromRGBO(255, 255, 255, 0.07),
      blurRadius: 27,
      spreadRadius: 1,
      offset: Offset(0, -4),
    )
  ];

  List<BoxShadow> ButtonShadow = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.2),
      blurRadius: 3,
      spreadRadius: 1,
      offset: Offset(1, 2),
    ),
    BoxShadow(
      color: Color.fromRGBO(255, 255, 255, 0.15),
      blurRadius: 3,
      spreadRadius: 1,
      offset: Offset(-1, -2),
    )
  ];
  
  Color barButtonColorLight = Color.fromRGBO(2, 86, 255, 1);
  Color barButtonColorDark = Color.fromRGBO(10, 23, 67, 1);

  List<BoxShadow> aboutShadowLight = [
  BoxShadow(
  color: Color.fromRGBO(0, 0, 0, 0.05),
  spreadRadius: 1,
  blurRadius: 10,
  offset: Offset(0, 4),
  ),
  BoxShadow(
  color: Color.fromRGBO(255, 255, 255, 0.05),
  spreadRadius: 1,
  blurRadius: 10,
  offset: Offset(0, 4),
  )
  ];

  List<BoxShadow> aboutShadowDark = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.07),
      spreadRadius: 1,
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color.fromRGBO(255, 255, 255, 0.15),
      spreadRadius: 1,
      blurRadius: 10,
      offset: Offset(0, 4),
    )
  ];




  Themes();
}