import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TestPage extends StatefulWidget {
  TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  GoogleMapController? mapController;
  String? searchaddr;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
              target: LatLng(13.697630703230097, 100.34083452967317), zoom: 20),
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
          },
        ),
      ],
    ));
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }
}
