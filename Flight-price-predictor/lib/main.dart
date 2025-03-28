import 'package:flutter/material.dart';
import 'landing_page.dart';
import 'prediction_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(),
        '/predict': (context) => PredictionPage(),
      },
    );
  }
}
