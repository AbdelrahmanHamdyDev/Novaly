import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:novaly/View/signScreen.dart';
import 'package:novaly/firebase_options.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  await dotenv.load(fileName: "lib/.env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightScheme =
            lightDynamic ?? ColorScheme.fromSeed(seedColor: Color(0xFF27548A));
        ColorScheme darkScheme =
            darkDynamic ??
            ColorScheme.fromSeed(
              seedColor: Color(0xFF4F1C51),
              brightness: Brightness.dark,
            );

        return ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, child) {
            return MaterialApp(
              theme: ThemeData(colorScheme: lightScheme),
              darkTheme: ThemeData(colorScheme: darkScheme),
              themeMode: ThemeMode.system,
              home: signScreen(type: "i"),
            );
          },
        );
      },
    ),
  );
}
