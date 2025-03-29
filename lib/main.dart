import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:novaly/pageView.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  await dotenv.load(fileName: "lib/.env");
  runApp(
    ProviderScope(
      child: DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
          ColorScheme lightScheme =
              lightDynamic ??
              ColorScheme.fromSeed(seedColor: Color(0xFF27548A));
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
                home: pageViewController(),
              );
            },
          );
        },
      ),
    ),
  );
}
