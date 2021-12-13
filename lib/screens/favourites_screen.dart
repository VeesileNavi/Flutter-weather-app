import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:weather_app/models/city_model.dart';
import 'package:weather_app/models/themes.dart';

class FavouriteScreen extends StatefulWidget{

  Function callback;
  FavouriteScreen(this.callback);

  @override
  State<FavouriteScreen> createState() => FavouriteScreenState();
}


class FavouriteScreenState extends State<FavouriteScreen>{

  List<City> favourites = [];



  @override
  void initState(){
    super.initState();
    loadFavourites();
  }

  Themes theme = Themes();

  List<BoxShadow> shadow;
  Color deleteButton;
  Color primary;
  Color elements;

  void checkTime(){
    if(DateTime.now().hour>=6&&DateTime.now().hour<=20){
      setState(() {
        primary = theme.primaryColorLight;
        elements = theme.colorLight;
        deleteButton = theme.deleteButtonLight;
        shadow = theme.favouritesShadowLight;
      });
    }
    else{
      setState(() {
        primary = theme.primaryColorDark;
        elements = theme.colorDark;
        deleteButton = theme.deleteButtonDark;
        shadow = theme.favouritesShadowDark;
      });
    }
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
      appBar: AppBar(
        backgroundColor: primary,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: elements,),
          onPressed: (){
            saveFavourites(favourites);
            Navigator.pop(context);
        },
        ),
        title: Text("Избранное", style: GoogleFonts.manrope(textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: elements)),),
      ),
      body: Container(
        color: primary,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            itemCount: favourites.length,
            itemBuilder: (BuildContext context, int index){
              if(favourites.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    height: 50,
                      decoration:
                      BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          boxShadow: shadow,
                      ),
                      child: GestureDetector(
                        onTap: (){
                          saveFavourites(favourites);
                          widget.callback(favourites[index].lat, favourites[index].lon, favourites[index].name,);
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  "${favourites[index].name}, ${favourites[index].country}",
                                  style: GoogleFonts.manrope(
                                      textStyle:  TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: elements)
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 50,
                              decoration:  BoxDecoration(
                                  color: deleteButton,
                                  borderRadius: BorderRadius.all(Radius.circular(15)),

                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    favourites.remove(favourites[index]);
                                  });
                                },
                                child: Icon(
                                  Icons.clear,
                                  color: elements,

                                ),
                              ),
                            )
                          ],
                        ),
                      )
                  ),
                );
              }
              else{
                return Center(
                  child: Text("There is nothing here"),
                );
              }
      },
        ),
      ),
    );

  }

}