import 'package:flutter/material.dart';
import 'package:mil/app_config/flavor_config.dart';

import '../main.dart';

void main() {
  mainCommonBase(
    FlavorConfig()
      ..appName = "Sri Siddi Vinayaka"
      ..flavourName = 'SSV'
      ..appEndName = {
        AppEndName.items: "random.api.dev/items",
        AppEndName.details: "random.api.dev/item"
      }
      ..itemLocation = "assets/images/ssv_splash.png"
      ..itemSplash = "assets/images/ssv_splash.png"
      ..themeData = ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        appBarTheme: ThemeData.light().appBarTheme.copyWith(
              backgroundColor: Colors.blue,
            ),
      ),
  );
}
