import 'package:flutter/material.dart';

class FlavorConfig {
  late String appName;
  late String flavourName;
  late Map<AppEndName, String> appEndName;
  late String itemLocation;
  late String itemSplash;
  late ThemeData themeData;
}

enum AppEndName { items, details }
