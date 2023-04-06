import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_config/flavor_config.dart';
import 'package:mil/routes/route.dart' as routes;

import 'firebase_options.dart';

// ignore: prefer_typing_uninitialized_variables
var flavorConfigProvider;

// Assigning Flavors from main method
void mainCommonBase(FlavorConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
/*
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  flavorConfigProvider = StateProvider((ref) => config);

  runApp(ProviderScope(child: MyApp()));*/
  flavorConfigProvider = StateProvider((ref) => config);
  runApp(ProviderScope(child: MyApp()));

  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    // FirebaseCrashlytics.instance.crash();

    // runApp(MyApp());
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: context.read(flavorConfigProvider).state.appName,
      theme: context.read(flavorConfigProvider).state.themeData,
      onGenerateRoute: routes.controller,
      initialRoute: routes.splashScreen,
      debugShowCheckedModeBanner: false,
    );
  }
}
