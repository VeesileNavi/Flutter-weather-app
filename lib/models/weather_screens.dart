import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather_app/models/themes.dart';
import '../dataFormatMethods.dart';
import 'package:google_fonts/google_fonts.dart';

class WeeklyWeather extends StatelessWidget{

int dateSeconds;
String icon, breeze, humidity, pressure, temperature;

WeeklyWeather(this.dateSeconds, this.icon, this.temperature, this.breeze,
      this.humidity, this.pressure);

Themes theme = Themes();
LinearGradient gradient;
Color primary;
Color elements;

void checkTime(){
  if(DateTime.now().hour>=6&&DateTime.now().hour<=20){
      primary = theme.primaryColorLight;
      elements = theme.colorLight;
      gradient = theme.gradientWeekLight;

  }
  else{
      primary = theme.primaryColorDark;
      elements = theme.colorDark;
      gradient = theme.gradientWeekDark;

  }
}



  @override
  Widget build(BuildContext context) {
  checkTime();
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: gradient,
      ),

      child: Column(
        children: [
          Container(
            child: Align(alignment: Alignment.topLeft, child: Text(convertSecondsToMMMd(dateSeconds), style: GoogleFonts.manrope(textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: elements),)))),
          Padding(padding: EdgeInsets.symmetric(vertical: 7)),
          Row(
            children: [
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              Image.asset(this.icon, height: 100, width: 100,),
            ],
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          Row(
            children: [
              SvgPicture.asset('assets/icons/params/thermometer.svg', height: 24, width: 24, color: elements,),
              Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
              Text(this.temperature, style: GoogleFonts.manrope(textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: elements),)),
            ],
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Row(
            children: [
              SvgPicture.asset('assets/icons/params/breeze.svg', height: 24, width: 24,color: elements,),
              Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
              Text(this.breeze, style: GoogleFonts.manrope(textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: elements),)),
            ],
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Row(
            children: [
              SvgPicture.asset('assets/icons/params/humidity.svg', height: 24, width: 24,color: elements,),
              Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
              Text(this.humidity+" %", style: GoogleFonts.manrope(textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: elements),)),
            ],
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Row(
            children: [
              SvgPicture.asset('assets/icons/params/barometer.svg', height: 24, width: 24,color: elements,),
              Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
              Text(this.pressure, style: GoogleFonts.manrope(textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: elements),)),
            ],
          ),
        ],
      ),
    );
  }
}


class DayWeather extends StatelessWidget{
  int dateSeconds;
  String icon;
  String temperature;

  Color primaryColor;
  Color elementsColor;
  List<Shadow> shadows;

  Themes theme = Themes();

  void checkTime(){
    if(DateTime.now().hour>=6&&DateTime.now().hour<=20){
        primaryColor = theme.primaryColorLight;
        elementsColor = theme.colorLight;
        shadows = theme.dayCardsShadowLight;
    }
    else{
        primaryColor = theme.primaryColorDark;
        elementsColor = theme.colorDark;
        shadows = theme.dayCardsShadowDark;
    }
  }

  DayWeather(this.dateSeconds, this.icon, this.temperature);

  @override
  Widget build(BuildContext context) {
    checkTime();
    return SizedBox(
      height: 120,
      width: 65,
      child: Container(
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: shadows,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Column(
                    children: [
                      Text(convertSecondsToHm(dateSeconds), style: GoogleFonts.manrope(textStyle: TextStyle(color: elementsColor, fontWeight: FontWeight.w400, fontSize: 17),)),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                        child: Image(image: AssetImage(icon)),
                      ),
                      Text(temperature, style: GoogleFonts.manrope(textStyle: TextStyle(color:elementsColor, fontWeight: FontWeight.w400, fontSize: 17)))
                    ],
                  ),
                ),
              ),

      ),
    );
  }

}

class DayParams extends StatelessWidget{
   final String icon;
   final String parameter;


  const DayParams(this.icon, this.parameter);
  @override
  Widget build(BuildContext context) {
    Themes theme = Themes();

    Color primaryColor;
    Color elementsColor;
    List<BoxShadow> shadows;
    void checkTime() {
      if (DateTime
          .now()
          .hour >= 6 && DateTime
          .now()
          .hour <= 20) {
        primaryColor = theme.primaryColorLight;
        elementsColor = theme.colorLight;
        shadows = theme.dayCardsShadowLight;
      }
      else {
          primaryColor = theme.primaryColorDark;
          elementsColor = theme.colorDark;
          shadows = theme.dayCardsShadowDark;
      }
    }
    checkTime();
    return SizedBox(
      height: 65,
      width: 120,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
                color: primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow:shadows,
            ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(icon, height: 24, width: 12,),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                  Text(parameter, style: GoogleFonts.manrope(textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: elementsColor)),)
                ],
              ),
        ),
      ),
    );
  }

}