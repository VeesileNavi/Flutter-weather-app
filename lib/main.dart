import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/themes.dart';
import 'package:weather_app/models/weather_screens.dart';
import 'package:weather_app/dataFormatMethods.dart';
import 'package:weather_app/screens/search_screen.dart';
import 'package:weather_app/screens/favourites_screen.dart';
import 'package:weather_app/screens/week_weather_screen.dart';
import 'package:weather_app/screens/about_screen.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/settings.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/models/themes.dart';

import 'models/themes.dart';


class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {


  String city = "Moscow";
  String lat = "55.6444",
      lon = "37.3957";
  double globalTemp;
  String tempFormat = "CELSIUS",
      windFormat = "MS",
      pressFormat = "MMHG";
  String APIKEY = "aaf144602a585abf71dee7fd5aad06ff";

  Color primaryColor;
  Color elementsColor;
  Color barButtonColor;
  Color lineContainerColor;
  Color buttonColor;
  List<BoxShadow> barButtonShadow;
  AssetImage backgroundImage;
  String iconPath;


  Themes theme = Themes();



  void checkTime() {
    if (DateTime
        .now()
        .hour >= 6 && DateTime
        .now()
        .hour <= 20) {
      setState(() {
        primaryColor = theme.primaryColorLight;
        elementsColor = theme.colorLight;
        barButtonColor = theme.barButtonColorLight;
        lineContainerColor = theme.buttonColorLight;
        barButtonShadow = theme.ButtonShadow;
        backgroundImage = theme.backgroundImageLight;
        buttonColor = theme.buttonColorLight;
        iconPath = "assets/icons/hourly/day/";
      });
    }
    else {
      setState(() {
        primaryColor = theme.primaryColorDark;
        elementsColor = theme.colorDark;
        barButtonColor = theme.barButtonColorDark;
        lineContainerColor = theme.colorDark;
        barButtonShadow = theme.ButtonShadow;
        backgroundImage = theme.backgroundImageDark;
        buttonColor = theme.colorDark;
        iconPath = "assets/icons/hourly/night/";
      });
    }
  }

    void saveSettings(String _city, String _lat, String _lon,
        String _tempFormat, String _windFormat, String _pressFormat) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('City', _city);
      prefs.setString('Lat', _lat);
      prefs.setString('Lon', _lon);
      prefs.setString('TempFormat', _tempFormat);
      prefs.setString('WindFormat', _windFormat);
      prefs.setString('PressFormat', _pressFormat);
    }

    void getSettings() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        city = prefs.getString('City');
        lat = prefs.getString('Lat');
        lon = prefs.getString('Lon');
        tempFormat = prefs.getString('TempFormat');
        windFormat = prefs.getString('WindFormat');
        pressFormat = prefs.getString('PressFormat');
      });
    }

    @override
    void initState() {
      super.initState();
      getSettings();
    }

    final globalKey = GlobalKey<ScaffoldState>();

    var dateToday = DateFormat.MMMd('ru').format(DateTime.now());

    double textOpacity = 0;
    double negTextOpacity = 1;
    //this variable controls padding of container with dayweather cards
    double dayWeatherContainerPadding = 0;

    //this variable controls padding of grid with parameters cards
    double dayParametersGridPadding = 200;

    setCity(String _lat, String _lon, String _city) {
      setState(() {
        lat = _lat;
        lon = _lon;
        city = _city;
      });
    }

    setDataFormat(int _temp, int _wind, int _press) {
      setState(() {
        _temp == 0 ? tempFormat = "CELSIUS" : tempFormat = "FAHRENHEIT";
        _wind == 0 ? windFormat = "MS" : windFormat = "KMH";
        _press == 0 ? pressFormat = "MMHG" : pressFormat = "GPA";
      });
    }

    Future<List<Weather>> fetchWeatherFromJSONHourly(http.Client client,
        String lat, String lon) async {
      setState(() {
        globalTemp = globalTemp;
      });
      saveSettings(city, lat, lon, tempFormat, windFormat, pressFormat);
      final response = await client.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/onecall?lat=${lat}&lon=${lon}&exclude=current,minutely,alerts&appid=$APIKEY'));
      if (response.statusCode == 200) {
        var parsed =
        json.decode(response.body)["hourly"].cast<Map<String, dynamic>>();
        return parsed
            .map<Weather>((json) => Weather.fromJSONhourly(json))
            .toList();
      } else {
      }
    }


    @override
    Widget build(BuildContext context) {
      checkTime();
      return Scaffold(
        key: globalKey,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: TextButton(
            onPressed: () {},
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: textOpacity,
              child: Text(
                city==null?"Moscow":city,
                style: GoogleFonts.manrope(textStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),),
              ),
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                decoration: BoxDecoration(
                  boxShadow: barButtonShadow,
                  color: barButtonColor,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
              child: IconButton(
                onPressed: () {
                  globalKey.currentState.openDrawer();
                },
                icon: SvgPicture.asset(
                  'assets/images/menu.svg',
                  height: 20,
                  width: 20,
                ),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  boxShadow: barButtonShadow,
                  color: barButtonColor,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchScreen(setCity)));
                  },
                  icon: SvgPicture.asset(
                    'assets/images/plus.svg',
                    height: 40,
                    width: 40,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: FutureBuilder<List<Weather>>(
            future: fetchWeatherFromJSONHourly(http.Client(), lat, lon),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Weather> data = snapshot.data;
                //DAY PARAMETERS
                List<DayParams> dayParametersList = [
                  DayParams(
                      "assets/icons/params/thermometer.svg",
                      formatTemperature(
                          data[0].temperature, tempFormat)),
                  DayParams(
                      "assets/icons/params/humidity.svg",
                      data[0].humidity.toString() + " %"),
                  DayParams("assets/icons/params/breeze.svg",
                      formatWind(data[0].breeze, windFormat)),
                  DayParams(
                      "assets/icons/params/barometer.svg",
                      formatPressure(data[0].pressure, pressFormat)),
                ];

                List<DayWeather> dayWeatherList = [
                  DayWeather(data[0].dateSeconds,
                      "$iconPath${data[0].icon[0].iconCode}.png",
                      formatTemperature(data[0].temperature, tempFormat)),
                  DayWeather(data[5].dateSeconds,
                      "$iconPath${data[5].icon[0].iconCode}.png",
                      formatTemperature(data[5].temperature, tempFormat)),
                  DayWeather(data[11].dateSeconds,
                      "$iconPath${data[11].icon[0].iconCode}.png",
                      formatTemperature(data[11].temperature, tempFormat)),
                  DayWeather(data[17].dateSeconds,
                      "$iconPath${data[17].icon[0].iconCode}.png",
                      formatTemperature(data[17].temperature, tempFormat))
                ];
                globalTemp = data[0].temperature;

                return Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: backgroundImage,
                          fit: BoxFit.cover, // -> 02
                        ),
                      ),
                      child: ExpandableBottomSheet(
                        persistentHeader: Container(
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          height: 40,
                          child: Center(
                            child: Container(
                              height: 3,
                              width: 60,
                              color: buttonColor,
                            ),
                          ),
                        ),
                        onIsExtendedCallback: () {
                          setState(() {
                            textOpacity = 1;
                            negTextOpacity = 0;
                            dayWeatherContainerPadding = 30;
                            dayParametersGridPadding = 100;
                          });
                        },
                        onIsContractedCallback: () {
                          setState(() {
                            textOpacity = 0;
                            negTextOpacity = 1;
                            dayWeatherContainerPadding = 0;
                            dayParametersGridPadding = 200;
                          });
                        },
                        persistentContentHeight: 220,
                        expandableContent: Container(
                          height: 400,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          color: primaryColor,
                          child: Center(
                            child: Stack(
                              children: [
                                //Date container
                                Container(
                                  alignment: Alignment.center,
                                  height: 20,
                                  child: AnimatedOpacity(
                                      duration: Duration(milliseconds: 300),
                                      opacity: textOpacity,
                                      curve: Curves.fastOutSlowIn,
                                      child: Text(
                                        dateToday,
                                        style: TextStyle(
                                          color: elementsColor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )),
                                ),

                                //dayweather cards container
                                AnimatedPadding(
                                    padding:
                                    EdgeInsets.only(
                                        top: dayWeatherContainerPadding),
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5),
                                          child: Container(
                                            height: 130,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20.0),
                                                  child: ListView.separated(
                                                    scrollDirection: Axis
                                                        .horizontal,
                                                    shrinkWrap: true,
                                                    itemCount: 4,
                                                    itemBuilder: (context,
                                                        index) {
                                                      return dayWeatherList[index];
                                                    },
                                                    separatorBuilder:
                                                        (BuildContext context,
                                                        int index) {
                                                      return const SizedBox(
                                                        width: 30,
                                                      );
                                                    },
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(padding: EdgeInsets.symmetric(
                                            vertical: 10)),


                                        //Button
                                        AnimatedOpacity(
                                          opacity: negTextOpacity,
                                          duration: Duration(milliseconds: 100),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: primaryColor,
                                              side: BorderSide(
                                                  width: 2.0,
                                                  color:
                                              buttonColor),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .all(
                                                      Radius.circular(10))),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          WeekWeather(
                                                            lat: '$lat',
                                                            lon: '$lon',
                                                            tempFormat: '$tempFormat',
                                                            windFormat: '$windFormat',
                                                            pressFormat: '$pressFormat',
                                                          )));
                                            },
                                            child: Text("Прогноз на неделю",
                                                style: GoogleFonts.manrope(
                                                    textStyle:
                                                    TextStyle(
                                                        color:
                                                        buttonColor,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight
                                                            .w500))),),
                                        ),
                                      ],
                                    )),


                                //day parameters container
                                AnimatedOpacity(
                                  opacity: textOpacity,
                                  duration: Duration(milliseconds: 300),
                                  child: AnimatedPadding(
                                    padding:
                                    EdgeInsets.only(
                                        top: dayParametersGridPadding),
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10,),
                                        child: Container(
                                          height: 300,
                                          child: GridView.count(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10,
                                            childAspectRatio: 2,
                                            children: List.generate(4, (index) {
                                              return dayParametersList[index];
                                            }),
                                          ),
                                        )
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedPositioned(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.fastOutSlowIn,
                            top: textOpacity == 1 ? 90 : 50,
                            child: Container(
                              height: 140,
                              child: Column(
                                children: [
                                  Text(
                                    formatTemperature(globalTemp, tempFormat),
                                    style: GoogleFonts.manrope(textStyle:
                                    TextStyle(
                                        color: Colors.white,
                                        fontSize: 80,
                                        fontWeight: FontWeight.w600),),
                                  ),
                                  AnimatedOpacity(
                                    duration: Duration(milliseconds: 300),
                                    opacity: negTextOpacity,
                                    child: Center(
                                      child: Text(
                                        dateToday,
                                        style: GoogleFonts.manrope(textStyle:
                                        TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              else if (snapshot.hasError) {
                log("MAINSCREEN ERROR");
                log(snapshot.error.toString());
              }
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            }
        ),
        drawer: SizedBox(
          width: MediaQuery
              .of(context)
              .size
              .width * 0.6,
          child: Drawer(
            child: Container(
              color: primaryColor,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    margin: EdgeInsets.all(20.0),
                    height: 100,
                    child: DrawerHeader(
                      child: Text(
                        "Weather app",
                        style:
                        GoogleFonts.manrope(textStyle: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.w900,color: elementsColor),),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Column(children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SettingsScreen(setDataFormat)));
                        },
                        child: Row(
                          children: [
                            Icon(Icons.settings_outlined,
                                size: 20, color: elementsColor),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5)),
                            Text(
                              "Настройки",
                              style: GoogleFonts.manrope(textStyle: TextStyle(
                                  fontSize: 18, color: elementsColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 25)),
                      GestureDetector(
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite_border,
                              color: elementsColor,
                              size: 20,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5)),
                            Text(
                              "Избранные",
                              style: GoogleFonts.manrope(textStyle: TextStyle(
                                  fontSize: 18, color: elementsColor),),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FavouriteScreen(setCity)
                              )
                          );
                        },
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 25)),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => AboutScreen()));
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              color: elementsColor,
                              size: 20,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5)),
                            Text(
                              "О приложении",
                              style: GoogleFonts.manrope(textStyle: TextStyle(
                                  fontSize: 18, color: elementsColor),),
                            ),
                          ],
                        ),
                      )
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  void main() {
    initializeDateFormatting('ru', null);
    runApp(MaterialApp(
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
    ));
  }
