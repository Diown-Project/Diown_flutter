import 'dart:async';
import 'dart:typed_data';
import 'package:diown/pages/allmap/ownerpin.dart';
import 'package:diown/pages/mainpage/direction/direction_repository.dart';
import 'package:diown/pages/mainpage/searchmap/location_service.dart';
import 'package:diown/pages/putdowndiary/writeputdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:page_transition/page_transition.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);
  static String id = 'MapPage';
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  StreamSubscription? _locationSubscription;
  TextEditingController _searchController = TextEditingController();
  Location _locationTracker = Location();
  bool create = false;
  Marker? marker;
  Circle? circle;
  String? input;
  bool focus = false;
  GoogleMapController? mapController;
  Completer<GoogleMapController> _controller = Completer();
  String? searchaddr;
  var initlaglng;

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("images/car_icon.png");
    return byteData.buffer.asUint8List();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
    setState(() {
      focus = true;
    });
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(
        newLocalData.latitude as double, newLocalData.longitude as double);
    setState(() {
      initlaglng = LatLng(
          newLocalData.latitude as double, newLocalData.longitude as double);
    });
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
      setState(() {
        focus = !focus;
      });
      updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription!.cancel();
      }
      _locationSubscription =
          _locationTracker.onLocationChanged.listen((newLocalData) {
        if (focus == true) {
          if (mapController != null) {
            mapController!.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                    bearing: 192.8334901395799,
                    target: LatLng(newLocalData.latitude as double,
                        newLocalData.longitude as double),
                    tilt: 0,
                    zoom: 18.00)));
            updateMarkerAndCircle(newLocalData, imageData);
          }
        } else {
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
          appBar: AppBar(
            foregroundColor: Colors.black,
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'Put down your memory',
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: const OwnerPin(),
                              type: PageTransitionType.rightToLeft));
                      // print(initlaglng);
                      // await DirectionsRepository().getDirections(
                      //     origin: initlaglng,
                      //     destination:
                      //         LatLng(13.697630703230097, 100.34083452967317));
                    },
                    icon: const Icon(
                      Icons.pin_drop_sharp,
                      color: Colors.black,
                    )),
              )
            ],
          ),
          body: initlaglng != null
              ? Stack(
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
                                  infoWindow: const InfoWindow(
                                      title: 'บ้านกูไอแม่เย็ด'),
                                  onTap: () {
                                    var lag = 13.697630703230097;
                                    var lng = 100.34083452967317;
                                    var pin = 'บ้านกูไอแม่เย็ด';
                                    Future.delayed(const Duration(seconds: 0),
                                        () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return makeDismissible(
                                              child: DraggableScrollableSheet(
                                                initialChildSize: 1,
                                                builder: (_, controller) =>
                                                    Scaffold(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  appBar: AppBar(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    elevation: 0,
                                                    foregroundColor:
                                                        Colors.black,
                                                    centerTitle: true,
                                                    title: Text('ชื่อ pin'),
                                                  ),
                                                  body: SingleChildScrollView(
                                                    child: Container(
                                                        color:
                                                            Colors.transparent,
                                                        child: Column(
                                                          children: [
                                                            ListTile(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    PageTransition(
                                                                        child:
                                                                            WritePutdownDiary(
                                                                          lag:
                                                                              lag,
                                                                          lng:
                                                                              lng,
                                                                          pin:
                                                                              pin,
                                                                        ),
                                                                        type: PageTransitionType
                                                                            .rightToLeft));
                                                              },
                                                              leading:
                                                                  const Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            8.0),
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 30,
                                                                  backgroundImage:
                                                                      NetworkImage(
                                                                          'https://storage.googleapis.com/noseason/nonja'),
                                                                ),
                                                              ),
                                                              title: const Text(
                                                                'Put down your diary.',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18),
                                                              ),
                                                              trailing:
                                                                  const Icon(Icons
                                                                      .navigate_next_rounded),
                                                            ),
                                                            const Divider(
                                                              thickness: 0.8,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      20.0,
                                                                      10.0,
                                                                      20.0,
                                                                      0),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                      'My diary: '),
                                                                  Spacer(),
                                                                  TextButton(
                                                                      onPressed:
                                                                          () {},
                                                                      child:
                                                                          Text(
                                                                        'view more',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      )),
                                                                ],
                                                              ),
                                                            ),
                                                            ListTile(
                                                              leading:
                                                                  CircleAvatar(
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                        'https://storage.googleapis.com/noseason/nonja'),
                                                              ),
                                                              title: const Text(
                                                                  'The weather was really good.'),
                                                              subtitle: const Text(
                                                                  '@noseason - 😀 Happy'),
                                                              trailing:
                                                                  const Icon(
                                                                      Icons
                                                                          .lock),
                                                              onTap:
                                                                  () async {},
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      20.0,
                                                                      10.0,
                                                                      20.0,
                                                                      0),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                      'For following: '),
                                                                  Spacer(),
                                                                  TextButton(
                                                                      onPressed:
                                                                          () {},
                                                                      child:
                                                                          Text(
                                                                        'view more',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      )),
                                                                ],
                                                              ),
                                                            ),
                                                            ListTile(
                                                              leading:
                                                                  CircleAvatar(
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                        'https://storage.googleapis.com/noseason/nonja'),
                                                              ),
                                                              title: const Text(
                                                                  'The weather was really good.'),
                                                              subtitle: const Text(
                                                                  '@noseason - 😀 Happy'),
                                                              trailing:
                                                                  const Icon(Icons
                                                                      .public_rounded),
                                                              onTap:
                                                                  () async {},
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      20.0,
                                                                      10.0,
                                                                      20.0,
                                                                      0),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                      'General: '),
                                                                  Spacer(),
                                                                  TextButton(
                                                                      onPressed:
                                                                          () {},
                                                                      child:
                                                                          Text(
                                                                        'view more',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      )),
                                                                ],
                                                              ),
                                                            ),
                                                            ListTile(
                                                              leading:
                                                                  CircleAvatar(
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                        'https://storage.googleapis.com/noseason/nonja'),
                                                              ),
                                                              title: const Text(
                                                                  'The weather was really good.'),
                                                              subtitle: const Text(
                                                                  '@noseason - 😀 Happy'),
                                                              trailing:
                                                                  const Icon(Icons
                                                                      .people),
                                                              onTap:
                                                                  () async {},
                                                            ),
                                                          ],
                                                        )),
                                                  ),
                                                ),
                                              ),
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
                                  infoWindow: const InfoWindow(
                                      title: 'บ้านกูไอแม่เย็ด'),
                                  onTap: () {
                                    Future.delayed(const Duration(seconds: 0),
                                        () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                  color: Colors.transparent,
                                                  height: 220,
                                                  child: ListView(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: ListTile(
                                                            title: const Text(
                                                              'Diary',
                                                              style: TextStyle(
                                                                  fontSize: 25),
                                                            ),
                                                            trailing:
                                                                IconButton(
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
                      initialCameraPosition:
                          CameraPosition(target: initlaglng, zoom: 12),
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                      },
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {
                                input = value;
                              });
                            },
                            onEditingComplete: () async {
                              var place = await LocationService()
                                  .getPlace(_searchController.text);
                              if (place.isNotEmpty) {
                                _goToPlace(place);
                              }
                            },
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.search),
                                color: Colors.purple,
                              ),
                              filled: true,
                              fillColor: const Color(0xfff1f3f4),
                              hintText: 'search Location',
                              hintStyle: const TextStyle(
                                  color: Color(0xffc5d2e1),
                                  fontWeight: FontWeight.w200),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide.none),
                              enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          floatingActionButton: FloatingActionButton(
              heroTag: 'asd',
              child: Icon(Icons.location_searching),
              onPressed: () {
                getCurrentLocation();
              }),
        ),
      ),
    );
  }

  Future<void> _goToPlace(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];
    mapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 13)));
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  Widget makeDismissible({required Widget child}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(
            onTap: FocusScope.of(context).unfocus, child: child),
      );
}
