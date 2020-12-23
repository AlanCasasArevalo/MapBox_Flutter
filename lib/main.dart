import 'package:flutter/material.dart';
import 'package:mapbox_maps/src/fullscreenmap.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FullScreenMap(),
    );
  }
}
