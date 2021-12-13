import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:weather_app/dataFormatMethods.dart';
import 'package:weather_app/models/themes.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_screens.dart';
import 'package:google_fonts/google_fonts.dart';

class WeekWeather extends StatefulWidget {
  String lat;
  String lon;
  String tempFormat, windFormat, pressFormat;

  WeekWeather({Key key, @required this.lat, @required this.lon, @required this.tempFormat, @required this.windFormat, @required this.pressFormat})
      : super(key: key);

  @override
  State<WeekWeather> createState() => _WeekWeatherState();
}

class _WeekWeatherState extends State<WeekWeather> {
  final globalKey = GlobalKey<ScaffoldState>();
  String APIKEY = "aaf144602a585abf71dee7fd5aad06ff";
  String lat;
  String lon;
  String tempFormat, windFormat, pressFormat;

  @override
  void initState() {
    lat = widget.lat;
    lon = widget.lon;
    tempFormat = widget.tempFormat;
    windFormat = widget.windFormat;
    pressFormat = widget.pressFormat;
  }

  Themes theme = Themes();
  Color primary;
  Color elements;
  void checkTime(){
    if(DateTime.now().hour>=6&&DateTime.now().hour<=20){
      setState(() {
        primary = theme.primaryColorLight;
        elements = theme.colorLight;
      });
    }
    else{
      setState(() {
        primary = theme.primaryColorDark;
        elements = theme.colorDark;
      });
    }
  }

  Future<List<Weather>> fetchWeatherFromJSONDaily(
      http.Client client, String lat, String lon) async {
    final response = await client.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=current,hourly,minutely,alerts&appid=$APIKEY'));
    var parsed =
    json.decode(response.body)['daily'].cast<Map<String, dynamic>>();
    return parsed.map<Weather>((json) => Weather.fromJSONdaily(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    checkTime();
    return Scaffold(
      body: Container(
        color: primary,
        alignment: Alignment.center,
        child: Column(children: [
          Padding(padding: EdgeInsets.symmetric(vertical: 20)),
          Text(
            "Прогноз на неделю",
            style: GoogleFonts.manrope(textStyle: TextStyle(
                color: elements, fontSize: 24, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 20)),
          Container(
            child: FutureBuilder<List<Weather>>(
              future: fetchWeatherFromJSONDaily(http.Client(), lat, lon),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Weather> data = snapshot.data;
                  return Swiper(
                    itemCount: 7,
                    itemHeight: 387,
                    itemWidth: 290,
                    layout: SwiperLayout.STACK,
                    loop: false,
                    itemBuilder: (BuildContext context, int index) {
                      return WeeklyWeather(
                          data[index].dateSeconds,
                          "assets/icons/weekly/${data[index].icon[0].iconCode}.png",
                          formatTemperature(data[index].temperature, tempFormat),
                          formatWind(data[index].breeze, windFormat),
                          data[index].humidity.toString(),
                          formatPressure(data[index].pressure, pressFormat));
                    },
                  );
                } else if (snapshot.hasError) {
                  log(snapshot.error.toString());
                }
                // By default show a loading spinner.
                return CircularProgressIndicator();
              },
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 40)),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Вернуться на главную",
              style: GoogleFonts.manrope(
                textStyle:
                TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: elements),),
            ),
            style: ElevatedButton.styleFrom(
                side: BorderSide(color: elements),
                primary: primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                )),
          ),
        ]),
      ),
    );
  }
}
