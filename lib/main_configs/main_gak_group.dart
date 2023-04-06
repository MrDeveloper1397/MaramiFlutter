import 'package:flutter/material.dart';
import 'package:mil/app_config/flavor_config.dart';

import '../main.dart';

void main() {
  mainCommonBase(
    FlavorConfig()
      ..appName = "GAK Group"
      ..appEndName = {
        AppEndName.items: "random.api.dev/items",
        AppEndName.details: "random.api.dev/item"
      }
      ..itemSplash = "assets/images/tc_splash.png"
      ..itemLocation = "assets/app_icon/tc_launch_icon.png"
      ..themeData = ThemeData.light().copyWith(
        primaryColor: Colors.red,
        appBarTheme: ThemeData.light().appBarTheme.copyWith(
              backgroundColor: Colors.red,
            ),
      ),
  );
}
