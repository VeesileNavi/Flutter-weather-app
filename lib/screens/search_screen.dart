import 'dart:convert';
import 'dart:developer';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/models/city_model.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/themes.dart';

class SearchScreen extends StatefulWidget {
  Function callback;

  SearchScreen(this.callback);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final globalKey = GlobalKey<ScaffoldState>();

  var _controller = TextEditingController();

  String textInput;
  String lat;
  String lon;

  List<City> favourites = [];

  Themes theme = Themes();

  Color primary;
  Color elementsColor;

  void checkTime() {
    if (DateTime
        .now()
        .hour >= 6 && DateTime
        .now()
        .hour <= 20) {
      primary = theme.primaryColorLight;
      elementsColor = theme.colorLight;
    }
    else {
      primary = theme.primaryColorDark;
      elementsColor = theme.colorDark;
    }
  }

  @override
  void initState(){
    super.initState();
    loadFavourites();
  }


  Future<List<City>> fetchCities(http.Client client, String text) async {
    final response = await client.get(Uri.parse(
        'http://api.geonames.org/searchJSON?name_startsWith=$text&maxRows=20&orderby=relevance&username=eblan'));
    var parsed =
    json.decode(response.body)['geonames'].cast<Map<String, dynamic>>();
    return parsed.map<City>((json) => City.fromJSON(json)).toList();
  }

  void saveFavourites(List<City> favourites) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encoded = encode(favourites);
    prefs.setString('Favourites', encoded);
  }

  void loadFavourites() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favourites = decode(prefs.getString('Favourites')??[]);
    });
    log(favourites.toString());
  }

  String encode(List<City> cities) => json.encode(
    cities.map<Map<String, dynamic>>((cities) => City.toMap(cities)).toList(),
  );

  static List<City> decode(String cities) =>
      (json.decode(cities) as List<dynamic>).map<City>((city) => City.fromJSONCustom(city)).toList();



  @override
  Widget build(BuildContext context) {
    checkTime();
    return Scaffold(
      key: globalKey,
        appBar: AppBar(
          backgroundColor: primary,
          elevation: 0,
          title: TextField(
            style: GoogleFonts.manrope(textStyle: TextStyle(color: elementsColor, fontSize: 15, fontWeight: FontWeight.w600)),
            controller: _controller,
            onChanged: (text) {
              setState(() {
                textInput = text;
              });
            },
            decoration: InputDecoration(hintText: "Введите название города...", hintStyle: GoogleFonts.manrope(textStyle: TextStyle(color: elementsColor, fontSize: 15, fontWeight: FontWeight.w600))),
          ),
          leading: IconButton(
            onPressed: () {
              saveFavourites(favourites);
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
            color: elementsColor,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  _controller.clear();
                },
                icon: Icon(Icons.cancel),
                color: elementsColor),
          ],
        ),
        body: Container(
          color: primary,
          child: Center(
            child: FutureBuilder<List<City>>(
              future: fetchCities(http.Client(), textInput),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<City> data = snapshot.data;
                  if(data.isNotEmpty){
                  return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        color: elementsColor,
                        height: 0,
                      ),
                        itemCount: 20,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 50,
                            color: Colors.transparent,
                            child:
                                Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                          onTap: () {
                                            widget.callback(data[index].lat, data[index].lon,
                                                data[index].name);
                                            saveFavourites(favourites);
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            child: Text(data[index].name +
                                                ", " +
                                                data[index].country,
                                            style: GoogleFonts.manrope(textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: elementsColor)),),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        color: elementsColor,
                                        onPressed: (){
                                          if(favourites.contains(data[index])){
                                            setState(() {
                                              favourites.removeWhere((City)=>City.name==data[index].name&&City.country==data[index].country&&City.lat==data[index].lat&&City.lon==data[index].lon);
                                            });
                                          }
                                          else{
                                            setState(() {
                                              favourites.add(data[index]);
                                            });

                                          }

                                      },
                                        icon: Icon(favourites.contains(data[index])?Icons.star_rounded:Icons.star_border_rounded,),iconSize: 40,
                                      ),
                                    ],
                                  ),
                                ),

                          );
                        }),
                  );
                  }
                  else{
                    return CircularProgressIndicator();
                  }

                } else if (snapshot.hasError) {
                  log(snapshot.error.toString());
                }
                // By default show a loading spinner.
                return CircularProgressIndicator();
              },
            ),
          ),
        ));
  }
}