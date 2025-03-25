import 'package:flutter/material.dart';
import 'package:novaly/View/HomeScreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: "lib/.env");
  runApp(MaterialApp(home: homescreen()));
}
