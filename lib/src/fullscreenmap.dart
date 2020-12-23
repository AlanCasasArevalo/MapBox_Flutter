import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';

class FullScreenMap extends StatefulWidget {
  @override
  _FullScreenMapState createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  MapboxMapController mapController;
  final centerMap = LatLng(40.092912, -4.051379);
  final navigation = 'mapbox://styles/alancasas/ckj0deli70z5219mqfenyghf8';
  final monochrome = 'mapbox://styles/alancasas/ckj0dbyqw8jl619ozab3308gg';
  final streets = 'mapbox://styles/alancasas/ckj0dxim88k3a19mhjskm1023';
  double tiltTo = 0;

  String selectedStyle = 'mapbox://styles/alancasas/ckj0dxim88k3a19mhjskm1023';

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _onStyleLoaded();
  }

  void _onStyleLoaded() {
    addImageFromAsset('assetImage', 'assets/custom-icon.png');
    addImageFromUrl('networkImage', 'https://via.placeholder.com/50');
  }

  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage(name, list);
  }

  Future<void> addImageFromUrl(String name, String url) async {
    var response = await http.get(url);
    return mapController.addImage(name, response.bodyBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildMapboxMap(),
      floatingActionButton: _buildFloatingButtons(),
    );
  }

  Column _buildFloatingButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          child: Icon(Icons.sentiment_satisfied_alt),
          onPressed: (){
            mapController.addSymbol(
              SymbolOptions(
                geometry: centerMap,
                textField: 'Chozas de Canales',
                iconImage: 'networkImage',
                textOffset: Offset(0, 2)
              )
            );
          },
        ),
        // FloatingActionButton(
        //   child: Icon(Icons.sentiment_satisfied_alt),
        //   onPressed: (){
        //     mapController.addSymbol(
        //       SymbolOptions(
        //         geometry: centerMap,
        //         textField: 'Chozas de Canales',
        //         iconImage: 'castle-15',
        //         textOffset: Offset(0, 2)
        //       )
        //     );
        //   },
        // ),
        FloatingActionButton(
          child: Icon(Icons.threed_rotation),
          onPressed: (){
            mapController.animateCamera(
              CameraUpdate.tiltTo(tiltTo+=20)
            );
          },
        ),
        FloatingActionButton(
          child: Icon(Icons.settings_backup_restore),
          onPressed: (){
            mapController.animateCamera(
              CameraUpdate.tiltTo(tiltTo = 0)
            );
          },
        ),
        FloatingActionButton(
          child: Icon(Icons.zoom_in),
          onPressed: (){
            mapController.animateCamera(
              CameraUpdate.zoomIn()
            );
          },
        ),
        SizedBox(height: 5,),
        FloatingActionButton(
          child: Icon(Icons.zoom_out),
          onPressed: (){
            mapController.animateCamera(
                CameraUpdate.zoomOut()
            );
          },
        ),
        SizedBox(height: 5,),
        FloatingActionButton(
          child: Icon(Icons.add_to_home_screen),
            onPressed: () {
              selectedStyle == streets ? selectedStyle = navigation : selectedStyle = streets;
              setState(() {});
            }
        ),
      ],
    );
  }

  MapboxMap _buildMapboxMap() {
    return MapboxMap(
      styleString: selectedStyle,
      accessToken: 'YOUR_API_KEY',
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
          target: centerMap,
              zoom: 7.0,
      ),
      onStyleLoadedCallback: onStyleLoadedCallback,
    );
  }
  void onStyleLoadedCallback() {}
}
