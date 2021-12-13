import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/themes.dart';
class SettingsScreen extends StatefulWidget {

  Function callback;
  SettingsScreen(this.callback);

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  final globalKey = GlobalKey<ScaffoldState>();

  int isTempSwitched = 0;
  int isWindSwitched = 0;
  int isPressureSwitched = 0;

  Color primaryColor;
  Color elementsColor;
  Color switcherColor;
  List<BoxShadow> shadows;

  @override
  void initState() {
    super.initState();
    getTemperature();
    getWind();
    getPressure();
  }

  Themes theme = Themes();

  void checkTime(){
    if(DateTime.now().hour>=6&&DateTime.now().hour<=20){
      setState(() {
        primaryColor = theme.primaryColorLight;
        elementsColor = theme.colorLight;
        switcherColor = theme.switcherColorLight;
        shadows = theme.settingsShadowLight;
      });
    }
    else{
      setState(() {
        primaryColor = theme.primaryColorDark;
        elementsColor = theme.colorDark;
        switcherColor = theme.switcherColorDark;
        shadows = theme.settingsShadowDark;
      });
    }
  }


  saveSettings(int _isTempSwitched, int _isWindSwitched,
      int _isPressureSwitched) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('Temp', _isTempSwitched);
    prefs.setInt('Wind', _isWindSwitched);
    prefs.setInt('Press', _isPressureSwitched);
  }

  void getTemperature() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isTempSwitched = (prefs.getInt('Temp')??0);
    });
  }

  void getWind() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isWindSwitched = (prefs.getInt('Wind')??0);
    });
  }

  void getPressure() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isPressureSwitched = (prefs.getInt('Press')??0);
    });
  }


  @override
  Widget build(BuildContext context) {
    checkTime();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          shadowColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                saveSettings(isTempSwitched, isWindSwitched, isPressureSwitched);
                widget.callback(isTempSwitched, isWindSwitched, isPressureSwitched);
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios),
              color: elementsColor),
          title: Text(
            "Настройки",
            style: GoogleFonts.manrope(textStyle:
            TextStyle(
                fontWeight: FontWeight.w600, color: elementsColor, fontSize: 20),)
          ),
        ),
        body: Container(
          color: primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, left: 20),
                child: Text("Единицы измерения",
                  style: GoogleFonts.manrope(
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: elementsColor),)
                ),
              ),

              Padding(
                padding: EdgeInsets.all(12),
                child: Container(
                  height: 152,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: primaryColor,
                      boxShadow: shadows
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Температура",
                              style: GoogleFonts.manrope(textStyle: TextStyle(
                                  color: elementsColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),),
                            ),
                            ToggleSwitch(
                              totalSwitches: 2,
                              minWidth: 60,
                              minHeight: 25,
                              initialLabelIndex: isTempSwitched,
                              cornerRadius: 30,
                              labels: ["°C", "°F"],
                              activeFgColor: Colors.white,
                              inactiveFgColor: Colors.black,
                              inactiveBgColor: Colors.white,
                              activeBgColor: [switcherColor],
                              fontSize: 12,
                              onToggle: (index) {
                                isTempSwitched = index;
                              },
                            )
                          ],
                        ),
                        Divider(color: elementsColor,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Сила ветра",
                              style: GoogleFonts.manrope(textStyle: TextStyle(
                                  color: elementsColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),),
                            ),
                            ToggleSwitch(
                              totalSwitches: 2,
                              minWidth: 60,
                              minHeight: 25,
                              initialLabelIndex: isWindSwitched,
                              cornerRadius: 30,
                              labels: ["м/c", "км/ч"],
                              activeFgColor: Colors.white,
                              inactiveFgColor: Colors.black,
                              inactiveBgColor: Colors.white,
                              activeBgColor: [switcherColor],
                              fontSize: 12,
                              onToggle: (index) {
                                isWindSwitched = index;
                              },
                            )
                          ],
                        ),
                        Divider(color: Color.fromRGBO(194, 194, 194, 1),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Давление",
                              style: GoogleFonts.manrope(textStyle: TextStyle(
                                  color: elementsColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),),
                            ),
                            ToggleSwitch(
                              totalSwitches: 2,
                              minWidth: 60,
                              minHeight: 25,
                              initialLabelIndex: isPressureSwitched,
                              cornerRadius: 30,
                              labels: ["мм.рт.ст", "гпс"],
                              activeFgColor: Colors.white,
                              inactiveFgColor: Colors.black,
                              inactiveBgColor: Colors.white,
                              activeBgColor: [switcherColor],
                              fontSize: 12,
                              onToggle: (index) {
                                isPressureSwitched = index;
                              },
                            )
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
