import 'package:flutter/material.dart';

class City{
  String name;
  String country;
  String lon;
  String lat;


  @override
  bool operator == (other) {
    return (other is City)
        && other.name == name
        && other.country == country
        && other.lon == lon
        && other.lat == lat;
  }

  @override
  String toString() {
    return 'City{name: $name, country: $country, lon: $lon, lat: $lat}';
  }

  City(this.name, this.country, this.lon, this.lat);

  Map<String, dynamic> toJSON(){
    return{
      'name' : name,
      'country' : country,
      'lon' : lon,
      'lat' : lat
    };
  }

 static Map<String, dynamic> toMap(City city) => {
    'name' : city.name,
    'country' : city.country,
    'lon' : city.lon,
    'lat' : city.lat
  };

  factory City.fromJSON(Map<String, dynamic> parsedJson){
    return City(
      parsedJson["name"],
      parsedJson["countryName"],
      parsedJson["lng"],
      parsedJson["lat"],
    );
  }

  factory City.fromJSONCustom(Map<String, dynamic> parsedJson){
    return City(
      parsedJson["name"],
      parsedJson["country"],
      parsedJson["lon"],
      parsedJson["lat"],
    );
  }
}