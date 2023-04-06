import 'package:flutter/material.dart';
import 'package:mil/app_config/flavor_config.dart';
import '../main.dart';

void main() {
  mainCommonBase(FlavorConfig()
    ..appName = "Pragati Green Living"
    ..flavourName = 'pragati'
    ..appEndName = {
      AppEndName.items: "random.api.dev/items",
      AppEndName.details: "random.api.dev/item"
    }
    ..itemSplash = "assets/images/pragati_splash.png"
    ..itemLocation = "assets/app_icon/pragati_launch_icon.png"
    ..themeData = ThemeData(
      primaryColor: Color(0xff0c9341),
      fontFamily: 'Georgia',
      textTheme: TextTheme(
        //For App Bar
        overline: const TextStyle(
          color: Colors.white,
          fontFamily: 'Raleway',
          fontSize: 20.0,
          // fontWeight: FontWeight.bold,
          height: 2,
        ),

        headline1: const TextStyle(
          color: Color(0xff0c9341),
          fontFamily: 'Roboto-Light',
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          height: 2,
        ),

        //Need to use for Sub Headings
        headline2: const TextStyle(
          color: Colors.black,
          fontFamily: 'Roboto-Light',
          fontSize: 16.0,
          letterSpacing: 1,
          // fontWeight: FontWeight.w800,
          height: 1.5,
        ),

        // Using for Profile Card Page 2
        headline3: const TextStyle(
          color: Colors.black,
          fontFamily: 'Roboto-Light',
          fontSize: 16.0,
          // fontWeight: FontWeight.w500,
          height: 1.5,
        ),

        // For Drop Down
        headline4: const TextStyle(
          color: Colors.black,
          fontFamily: 'Roboto-Light',
          fontSize: 14.0,
          // fontWeight: FontWeight.w800,
          height: 1.5,
        ),

        // For List Items
        headline5: const TextStyle(
          color: Colors.black87,
          fontFamily: 'Roboto-Light',
          fontSize: 16.0,
          // fontWeight: FontWeight.w700,
          height: 1.5,
        ),
        button: const TextStyle(
          color: Colors.white,
          fontFamily: 'Roboto-Light',
          fontSize: 14.0,
          // fontWeight: FontWeight.w800,
          height: 1.5,
        ),
        bodyText1: TextStyle(
            fontSize: 16.0,
            height: 1.5,
            letterSpacing: 1.0,
            fontFamily: 'Roboto-Light',
            // fontWeight: FontWeight.w700,
            color: Colors.blue),
        bodyText2: TextStyle(
            fontSize: 16.0,
            height: 1.5,
            letterSpacing: 1.0,
            fontFamily: 'Roboto-Light',
            // fontWeight: FontWeight.w700,
            color: Color(0xff0c9341)),
        headline6: TextStyle(
          color: Colors.white,
          fontFamily: 'Roboto-Light',
          fontSize: 14.0,
          // fontWeight: FontWeight.w800,
          height: 1.5,
        ),
      ),
      appBarTheme: ThemeData.light().appBarTheme.copyWith(
            backgroundColor: Color(0xff0c9341),
          ),
    ));
}
