import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/models/themes.dart';

class AboutScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => AboutScreenState();
  }

class AboutScreenState extends State<AboutScreen> {
  Themes theme = Themes();
  Color primary;
  Color elements;
  List<BoxShadow> shadow;
  Color greyColor;
  void checkTime(){
    if(DateTime.now().hour>=6&&DateTime.now().hour<=20){
      setState(() {
        primary = theme.primaryColorLight;
        elements = theme.colorLight;
        shadow = theme.aboutShadowLight;
        greyColor = Color.fromRGBO(74, 74, 74, 1);
      });
    }
    else{
      setState(() {
        primary = theme.primaryColorDark;
        elements = theme.colorDark;
        shadow = theme.aboutShadowDark;
        greyColor = Color.fromRGBO(227, 227, 227, 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    checkTime();
    return Scaffold(
    appBar: AppBar(
      backgroundColor: primary,
    shadowColor: Colors.transparent,
    title: Text("О разработчике", style: GoogleFonts.manrope(textStyle: TextStyle(color: elements, fontSize: 20, fontWeight: FontWeight.w600)),),
      leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios) ,color: elements,),
    ),
      body: Container(
        color: primary,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 100),
                child: Container(
                  height: 60,
                  width: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: primary,
                    boxShadow: shadow,
                  ),
                  child: Center(
                    child: Text("Weather app", style: GoogleFonts.manrope(textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: elements)),)
                  ),
                ),
              ),
              
              Expanded(
                flex: 1,
                child: Container(
                  height: 350,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                    color: primary,
                    boxShadow: shadow,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Column(
                      children: [
                        Text("by DebilTechnologies", style: GoogleFonts.manrope(textStyle: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: elements)),),
                        Text("Версия 1.0", style: GoogleFonts.manrope(textStyle: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: greyColor)),),
                        Text("от 30 октября 2021", style: GoogleFonts.manrope(textStyle: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: greyColor)),),
                        Padding(
                          padding: const EdgeInsets.only(top: 350),
                          child: Text("2021", style: GoogleFonts.manrope(textStyle: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: elements)),),
                        )

                      ],
                    ),
                  )
                ),
              )
            ],
          ),
        ),
      ),

    );

  }
}
