import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:products_watcher/main_screen/view/main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Watcher',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        cursorColor: Colors.orange,
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.grey[900],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainScreen(),
    );
  }
}
