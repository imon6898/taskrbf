import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import Get package
import 'view/home_page.dart'; // Import your home page widget

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // Wrap your app with GetMaterialApp
      debugShowCheckedModeBanner: false,
      title: 'Your App Title',
      theme: ThemeData(
        // Your theme data
      ),
      home: HomePage(), // Set your home page as the initial route
    );
  }
}
