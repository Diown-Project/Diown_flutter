import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);
  static String id = 'MapPage';
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  StreamSubscription? _locationSubscription;
  Location _locationTracker = Location();
  Marker? marker;
  Circle? circle;
  GoogleMapController? mapController;
  String? searchaddr;

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("images/car_icon.png");
    print('image');
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(
        newLocalData.latitude as double, newLocalData.longitude as double);
    setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading as double,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: CircleId("car"),
          radius: newLocalData.accuracy as double,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription!.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged.listen((newLocalData) {
        if (mapController != null) {
          print('hello');
          mapController!.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  bearing: 192.8334901395799,
                  target: LatLng(newLocalData.latitude as double,
                      newLocalData.longitude as double),
                  tilt: 0,
                  zoom: 18.00)));
          updateMarkerAndCircle(newLocalData, imageData);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                markers: marker != null
                    ? {
                        Marker(
                            markerId: const MarkerId('_ku'),
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueCyan),
                            position: const LatLng(
                                13.697630703230097, 100.34083452967317),
                            infoWindow:
                                const InfoWindow(title: 'บ้านกูไอแม่เย็ด'),
                            onTap: () {
                              Future.delayed(const Duration(seconds: 0), () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            color: Colors.transparent,
                                            height: 220,
                                            child: ListView(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ListTile(
                                                      title: const Text(
                                                        'Diary',
                                                        style: TextStyle(
                                                            fontSize: 25),
                                                      ),
                                                      trailing: IconButton(
                                                        icon: const Icon(Icons
                                                            .highlight_remove_rounded),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      )),
                                                ),
                                                const Divider(
                                                  thickness: 0.8,
                                                ),
                                                ListTile(
                                                  leading: const Icon(
                                                    Icons.book,
                                                    color: Color.fromRGBO(
                                                        148, 92, 254, 1),
                                                  ),
                                                  title: const Text(
                                                      'Write your diary.'),
                                                  trailing: const Icon(Icons
                                                      .navigate_next_rounded),
                                                  onTap: () async {},
                                                ),
                                                ListTile(
                                                  leading: const Icon(
                                                    Icons.pin_drop,
                                                    color: Color.fromRGBO(
                                                        148, 92, 254, 1),
                                                  ),
                                                  title: const Text(
                                                      'Write your diary for putdown.'),
                                                  trailing: const Icon(Icons
                                                      .navigate_next_rounded),
                                                  onTap: () {},
                                                )
                                              ],
                                            )),
                                      );
                                    });
                              });
                            }),
                        marker!
                      }
                    : {
                        Marker(
                            markerId: const MarkerId('_ku'),
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueCyan),
                            position: const LatLng(
                                13.697630703230097, 100.34083452967317),
                            infoWindow:
                                const InfoWindow(title: 'บ้านกูไอแม่เย็ด'),
                            onTap: () {
                              Future.delayed(const Duration(seconds: 0), () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            color: Colors.transparent,
                                            height: 220,
                                            child: ListView(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ListTile(
                                                      title: const Text(
                                                        'Diary',
                                                        style: TextStyle(
                                                            fontSize: 25),
                                                      ),
                                                      trailing: IconButton(
                                                        icon: const Icon(Icons
                                                            .highlight_remove_rounded),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      )),
                                                ),
                                                const Divider(
                                                  thickness: 0.8,
                                                ),
                                                ListTile(
                                                  leading: const Icon(
                                                    Icons.book,
                                                    color: Color.fromRGBO(
                                                        148, 92, 254, 1),
                                                  ),
                                                  title: const Text(
                                                      'Write your diary.'),
                                                  trailing: const Icon(Icons
                                                      .navigate_next_rounded),
                                                  onTap: () async {},
                                                ),
                                                ListTile(
                                                  leading: const Icon(
                                                    Icons.pin_drop,
                                                    color: Color.fromRGBO(
                                                        148, 92, 254, 1),
                                                  ),
                                                  title: const Text(
                                                      'Write your diary for putdown.'),
                                                  trailing: const Icon(Icons
                                                      .navigate_next_rounded),
                                                  onTap: () {},
                                                )
                                              ],
                                            )),
                                      );
                                    });
                              });
                            })
                      },
                circles: Set.of((circle != null) ? [circle!] : []),
                mapType: MapType.terrain,
                initialCameraPosition: CameraPosition(
                    target: LatLng(13.697630703230097, 100.34083452967317),
                    zoom: 20),
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
              ),
              Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        if (_locationSubscription != null) {
                          _locationSubscription!.cancel();
                        }
                      },
                      child: const Text('data')),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Color(0xfff1f3f4),
                        hintText: 'yourname@example.com',
                        hintStyle: TextStyle(
                            color: Color(0xffc5d2e1),
                            fontWeight: FontWeight.w200),
                        focusedBorder:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                        enabledBorder:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                        // prefixIcon: Icon(
                        //   Icons.email_outlined,
                        // ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.location_searching),
              onPressed: () {
                getCurrentLocation();
              }),
        ),
      ),
    );
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }
}
