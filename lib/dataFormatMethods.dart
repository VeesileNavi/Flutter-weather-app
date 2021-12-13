// ignore_for_file: file_names
import 'package:intl/intl.dart';

String formatTemperature(double temp, String format) {
  double temperature = temp;
  String result;
  if (format == "CELSIUS") {
    temperature -= 273.15;
    result = temperature.toStringAsFixed(0) + " °c";
  } else if (format == "FAHRENHEIT") {
    temperature = 1.8 * (temperature - 273.15) + 32;
    result = temperature.toStringAsFixed(0) + " °f";
  }
  return result;
}

String formatWind(double breeze, String format) {
  double wind = breeze;
  String result;
  if (format == "MS") {
    result = wind.toStringAsFixed(0) + " м/c";
  } else if (format == "KMH") {
    wind /=1000;
    result = wind.toStringAsFixed(3) + " км/ч";
  }
  return result;
}

String formatPressure(int pressure, String format) {
  double press = pressure.toDouble();
  String result;
  if (format == "GPA") {
    press*=1.33;
    result = press.toStringAsFixed(0) + " ГПа";
  } else if (format == "MMHG") {
    result = press.toStringAsFixed(0) + " мм.рт.cт";
  }
  return result;
}

String convertSecondsToMMMd(int seconds){
  var date = DateTime.fromMillisecondsSinceEpoch(seconds*1000);
  var formattedDate = DateFormat.MMMMd().format(date);
  return formattedDate.toString();
}

String convertSecondsToHm(int seconds){
  var date = DateTime.fromMillisecondsSinceEpoch(seconds*1000);
  var formattedDate = DateFormat.Hm().format(date);
  return formattedDate.toString();
}