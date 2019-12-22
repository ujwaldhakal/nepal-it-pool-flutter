
import 'package:flutter/material.dart';
import 'package:it_pool_app/homepage.dart';





void main() {
  runApp(new MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {



    return MaterialApp(
      title: 'Welcome to Flutter fucking app ok',
      home: new HomePage()
    );

  }
}

