class Weather{
  int dateSeconds;
  List<IconCode> icon;
  double temperature;
  double breeze;
  int humidity;
  int pressure;


  Weather(this.dateSeconds, this.icon, this.temperature, this.breeze, this.humidity, this.pressure);

  // factory Weather.fromJSON(Map<String, dynamic> parsedJson){
  //   return Weather(
  //       parsedJson["weather"]["description"],
  //       parsedJson["main"]["temp"],
  //       parsedJson["wind"]["speed"],
  //       parsedJson["main"]["humidity"],
  //       parsedJson["main"]["pressure"],
  //   );
  // }

  factory Weather.fromJSONhourly(Map<String, dynamic> parsedJson){
    return Weather(
      parsedJson["dt"].toInt(),
      parseIcon(parsedJson),
      parsedJson["temp"].toDouble(),
      parsedJson["wind_speed"].toDouble(),
      parsedJson["humidity"].toInt(),
      parsedJson["pressure"].toInt(),
    );
  }

  factory Weather.fromJSONdaily(Map<String, dynamic> parsedJson){
    return Weather(
      parsedJson["dt"],
      parseIcon(parsedJson),
      parsedJson["temp"]["day"],
      parsedJson["wind_speed"],
      parsedJson["humidity"],
      parsedJson["pressure"],
    );
  }

  static List<IconCode> parseIcon(iconJson){
    var list = iconJson['weather'] as List;
    List<IconCode> icon = list.map((data) => IconCode.fromJSON(data)).toList();
    return icon;
  }
  static List<Temp> parseTemp(tempJson){
    var list = tempJson['temp'] as List;
    List<Temp> temp = list.map((data) => Temp.fromJSON(data)).toList();
    return temp;
  }
}


class IconCode{
  String iconCode;

  IconCode({this.iconCode});

 factory IconCode.fromJSON(Map<String, dynamic> parsedJson){
    return IconCode(iconCode: parsedJson["icon"]);
  }
}

class Temp{
  double temp;

  Temp({this.temp});

  factory Temp.fromJSON(Map<String, dynamic> parsedJson){
    return Temp(temp: parsedJson["day"]);
  }
}



