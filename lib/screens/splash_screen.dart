import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mil/main.dart';
import 'package:mil/screens/landing_screen.dart';
import 'package:flutter_riverpod/src/provider.dart';
import 'package:mil/widgets/dashboard/dash_board.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySplashScreen extends StatefulWidget {
  @override
  MySplashScreenState createState() => MySplashScreenState();
}

class MySplashScreenState extends State<MySplashScreen> {
  bool alreadySaved = false;

  @override
  void initState() {
    super.initState();
    checkAutoLoginStatus();
  }

  @override
  Widget build(BuildContext context) => Container(
    color: Colors.white,
    child: Image.asset(
      context.read(flavorConfigProvider).state.itemSplash,
      fit: BoxFit.fill,
    ),
  );

  checkAutoLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userName")) {
      Timer(const Duration(seconds: 2),
              () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => LandingScreen())));
    } else {
      Timer(
        const Duration(seconds: 2),
            () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AppDashboard(
              loginType: prefs.getString('loginType').toString(),
            ),
          ),
        ),
      );
    }
  }
}
