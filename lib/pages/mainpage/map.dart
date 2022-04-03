import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:diown/pages/allmap/ownerpin.dart';
import 'package:diown/pages/mainpage/direction/direction_repository.dart';
import 'package:diown/pages/mainpage/searchmap/location_service.dart';
import 'package:diown/pages/putdowndiary/diarydetailputdown.dart';
import 'package:diown/pages/putdowndiary/listdiaryputdown.dart';
import 'package:diown/pages/putdowndiary/writeputdown.dart';
import 'package:diown/pages/screens/visitorprofile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
  bool click = true;
  Marker? marker;
  Circle? circle;
  String? input;
  var putdownDiary,
      ownPutdown,
      followingPutdown,
      generalPutdown,
      user,
      newlocation,
      allpin,
      allPinShow,
      allEvent,
      allEventShow;
  bool focus = false;
  GoogleMapController? mapController;
  Completer<GoogleMapController> _controller = Completer();
  String? searchaddr;
  var initlaglng;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final panelController = PanelController();

  allPin() async {
    allEvent = await findAllEventPin();
    allEventShow = allEvent!.map<Marker>((e) {
      return Marker(
          markerId: MarkerId('${e['marker_id']}'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          position: LatLng(e['lag'], e['lng']),
          infoWindow: InfoWindow(title: '${e['marker_id']}'),
          onTap: () {
            var lag = e['lag'];
            var lng = e['lng'];
            var pin = e['marker_id'];
            var pin_id = e['_id'];
            print(pin_id);
            Future.delayed(const Duration(seconds: 0), () async {
              var dis = distance(newlocation.latitude as double, lag,
                  newlocation.longitude as double, lng);
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return makeDismissible(
                      child: DraggableScrollableSheet(
                        initialChildSize: 1,
                        builder: (_, controller) => Scaffold(
                          backgroundColor: Colors.transparent,
                          appBar: AppBar(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            foregroundColor: Colors.black,
                            centerTitle: true,
                            title: Text(pin),
                          ),
                          body: FutureBuilder(
                            future: forDiarypinFunc(pin_id),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return SingleChildScrollView(
                                  child: Container(
                                      color: Colors.transparent,
                                      child: Column(
                                        children: [
                                          ListTile(
                                            onTap: () {
                                              // if (dis > 0.050) {
                                              //   AwesomeDialog(
                                              //           context: context,
                                              //           dialogType:
                                              //               DialogType.WARNING,
                                              //           desc:
                                              //               'Distance is to long.\nYou must to go closely on pin.\n Go closely on pin less than 50 meters.',
                                              //           btnOk: ElevatedButton(
                                              //               onPressed: () {
                                              //                 Navigator.pop(
                                              //                     context);
                                              //               },
                                              //               child: const Text(
                                              //                   'ok')))
                                              //       .show();
                                              // } else {
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      child: WritePutdownDiary(
                                                        deal: 'event',
                                                        pin: pin_id,
                                                        pin_name: pin,
                                                      ),
                                                      type: PageTransitionType
                                                          .rightToLeft));
                                              // }
                                            },
                                            leading: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: CircleAvatar(
                                                radius: 30,
                                                backgroundImage: NetworkImage(
                                                    'https://storage.googleapis.com/noseason/${user['profile_image']}'),
                                              ),
                                            ),
                                            title: const Text(
                                              'Put down your diary.',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            subtitle: Text(
                                                'distance: ${dis.toStringAsFixed(3)} km.'),
                                            trailing: const Icon(
                                                Icons.navigate_next_rounded),
                                          ),
                                          const Divider(
                                            thickness: 0.8,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20.0, 10.0, 20.0, 0),
                                            child: Row(
                                              children: [
                                                const Text('My diary: '),
                                                const Spacer(),
                                                TextButton(
                                                    onPressed: () async {
                                                      var c =
                                                          await Navigator.push(
                                                              context,
                                                              PageTransition(
                                                                  child:
                                                                      ListDiaryPutdown(
                                                                    diary: 2,
                                                                    pin: pin_id,
                                                                  ),
                                                                  type: PageTransitionType
                                                                      .rightToLeft));

                                                      setState(() {
                                                        print('asd');
                                                      });
                                                    },
                                                    child: Text(
                                                      'view more',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children: putdownDiary[2].length <=
                                                    2
                                                ? putdownDiary[2]
                                                    .map<Widget>(
                                                      (e) => ListTile(
                                                        leading: CircleAvatar(
                                                          backgroundImage:
                                                              NetworkImage(
                                                                  'https://storage.googleapis.com/noseason/${e['user_detail'][0]['profile_image']}'),
                                                        ),
                                                        title: e['topic'] !=
                                                                null
                                                            ? Text(e['topic'])
                                                            : Text(
                                                                '${e['mood_emoji']} ${e['mood_detail']}'),
                                                        subtitle: Text(
                                                            '@${e['user_detail'][0]['username']} - ${e['mood_emoji']} ${e['mood_detail']}'),
                                                        trailing: e['status'] ==
                                                                'Public'
                                                            ? Icon(Icons.public)
                                                            : e['status'] ==
                                                                    'Follower'
                                                                ? Icon(Icons
                                                                    .people)
                                                                : Icon(
                                                                    Icons.lock),
                                                        onTap: () async {
                                                          Navigator.push(
                                                                  context,
                                                                  PageTransition(
                                                                      child: DiaryDetailPutdown(
                                                                          id: e[
                                                                              '_id']),
                                                                      type: PageTransitionType
                                                                          .rightToLeft))
                                                              .then((_) {
                                                            setState(() {});
                                                          });
                                                        },
                                                      ),
                                                    )
                                                    .toList()
                                                : ownPutdown
                                                    .map<Widget>(
                                                      (e) => ListTile(
                                                        leading: CircleAvatar(
                                                          backgroundImage:
                                                              NetworkImage(
                                                                  'https://storage.googleapis.com/noseason/${e['user_detail'][0]['profile_image']}'),
                                                        ),
                                                        title: e['topic'] !=
                                                                null
                                                            ? Text(e['topic'])
                                                            : Text(
                                                                '${e['mood_emoji']} ${e['mood_detail']}'),
                                                        subtitle: Text(
                                                            '@${e['user_detail'][0]['username']} - ${e['mood_emoji']} ${e['mood_detail']}'),
                                                        trailing: e['status'] ==
                                                                'Public'
                                                            ? Icon(Icons.public)
                                                            : e['status'] ==
                                                                    'Follower'
                                                                ? Icon(Icons
                                                                    .people)
                                                                : Icon(
                                                                    Icons.lock),
                                                        onTap: () async {
                                                          Navigator.push(
                                                                  context,
                                                                  PageTransition(
                                                                      child: DiaryDetailPutdown(
                                                                          id: e[
                                                                              '_id']),
                                                                      type: PageTransitionType
                                                                          .rightToLeft))
                                                              .then((_) {
                                                            setState(() {});
                                                          });
                                                        },
                                                      ),
                                                    )
                                                    .toList(),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20.0, 10.0, 20.0, 0),
                                            child: Row(
                                              children: [
                                                Text('For following: '),
                                                Spacer(),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                              context,
                                                              PageTransition(
                                                                  child:
                                                                      ListDiaryPutdown(
                                                                    diary: 1,
                                                                    pin: pin_id,
                                                                  ),
                                                                  type: PageTransitionType
                                                                      .rightToLeft))
                                                          .then((_) {
                                                        setState(() {});
                                                      });
                                                    },
                                                    child: Text(
                                                      'view more',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children:
                                                putdownDiary[1].length <= 2
                                                    ? putdownDiary[1]
                                                        .map<Widget>(
                                                          (e) => ListTile(
                                                            leading:
                                                                CircleAvatar(
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      'https://storage.googleapis.com/noseason/${e['user_detail'][0]['profile_image']}'),
                                                            ),
                                                            title: e['topic'] !=
                                                                    null
                                                                ? Text(
                                                                    e['topic'])
                                                                : Text(
                                                                    '${e['mood_emoji']} ${e['mood_detail']}'),
                                                            subtitle: Text(
                                                                '@${e['user_detail'][0]['username']} - ${e['mood_emoji']} ${e['mood_detail']}'),
                                                            trailing: e['status'] ==
                                                                    'Public'
                                                                ? Icon(Icons
                                                                    .public)
                                                                : e['status'] ==
                                                                        'Follower'
                                                                    ? Icon(Icons
                                                                        .people)
                                                                    : Icon(Icons
                                                                        .lock),
                                                            onTap: () async {
                                                              if (e['status'] ==
                                                                  'Follower') {
                                                                var check = await findFollow(
                                                                    e['user_detail']
                                                                            [0][
                                                                        '_id']);
                                                                if (check[
                                                                        'message'] ==
                                                                    'true') {
                                                                  Navigator.push(
                                                                          context,
                                                                          PageTransition(
                                                                              child: DiaryDetailPutdown(id: e['_id']),
                                                                              type: PageTransitionType.rightToLeft))
                                                                      .then((_) {
                                                                    setState(
                                                                        () {});
                                                                  });
                                                                } else if (check[
                                                                        'message'] ==
                                                                    'false') {
                                                                  Navigator.push(
                                                                      context,
                                                                      PageTransition(
                                                                          child: VisitorProfile(
                                                                            user_id:
                                                                                e['user_id'],
                                                                          ),
                                                                          type: PageTransitionType.rightToLeft));
                                                                } else {}
                                                              } else {
                                                                Navigator.push(
                                                                        context,
                                                                        PageTransition(
                                                                            child:
                                                                                DiaryDetailPutdown(id: e['_id']),
                                                                            type: PageTransitionType.rightToLeft))
                                                                    .then((_) {
                                                                  setState(
                                                                      () {});
                                                                });
                                                              }
                                                            },
                                                          ),
                                                        )
                                                        .toList()
                                                    : followingPutdown
                                                        .map<Widget>(
                                                          (e) => ListTile(
                                                            leading:
                                                                CircleAvatar(
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      'https://storage.googleapis.com/noseason/${e['user_detail'][0]['profile_image']}'),
                                                            ),
                                                            title: e['topic'] !=
                                                                    null
                                                                ? Text(
                                                                    e['topic'])
                                                                : Text(
                                                                    '${e['mood_emoji']} ${e['mood_detail']}'),
                                                            subtitle: Text(
                                                                '@${e['user_detail'][0]['username']} - ${e['mood_emoji']} ${e['mood_detail']}'),
                                                            trailing: e['status'] ==
                                                                    'Public'
                                                                ? Icon(Icons
                                                                    .public)
                                                                : e['status'] ==
                                                                        'Follower'
                                                                    ? Icon(Icons
                                                                        .people)
                                                                    : Icon(Icons
                                                                        .lock),
                                                            onTap: () async {
                                                              if (e['status'] ==
                                                                  'Follower') {
                                                                print('heeloo');
                                                                var check = await findFollow(
                                                                    e['user_detail']
                                                                            [0][
                                                                        '_id']);
                                                                if (check[
                                                                        'message'] ==
                                                                    'true') {
                                                                  Navigator.push(
                                                                          context,
                                                                          PageTransition(
                                                                              child: DiaryDetailPutdown(id: e['_id']),
                                                                              type: PageTransitionType.rightToLeft))
                                                                      .then((_) {
                                                                    setState(
                                                                        () {});
                                                                  });
                                                                } else if (check[
                                                                        'message'] ==
                                                                    'false') {
                                                                  Navigator.push(
                                                                      context,
                                                                      PageTransition(
                                                                          child:
                                                                              VisitorProfile(user_id: e['user_id']),
                                                                          type: PageTransitionType.rightToLeft));
                                                                } else {}
                                                              } else {
                                                                Navigator.push(
                                                                        context,
                                                                        PageTransition(
                                                                            child:
                                                                                DiaryDetailPutdown(id: e['_id']),
                                                                            type: PageTransitionType.rightToLeft))
                                                                    .then((_) {
                                                                  setState(
                                                                      () {});
                                                                });
                                                              }
                                                            },
                                                          ),
                                                        )
                                                        .toList(),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20.0, 10.0, 20.0, 0),
                                            child: Row(
                                              children: [
                                                Text('General: '),
                                                Spacer(),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                              context,
                                                              PageTransition(
                                                                  child:
                                                                      ListDiaryPutdown(
                                                                    diary: 0,
                                                                    pin: pin_id,
                                                                  ),
                                                                  type: PageTransitionType
                                                                      .rightToLeft))
                                                          .then((_) {
                                                        setState(() {});
                                                      });
                                                    },
                                                    child: Text(
                                                      'view more',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children:
                                                putdownDiary[0].length <= 2
                                                    ? putdownDiary[0]
                                                        .map<Widget>(
                                                          (e) => ListTile(
                                                            leading:
                                                                CircleAvatar(
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      'https://storage.googleapis.com/noseason/${e['user_detail'][0]['profile_image']}'),
                                                            ),
                                                            title: e['topic'] !=
                                                                    null
                                                                ? Text(
                                                                    e['topic'])
                                                                : Text(
                                                                    '${e['mood_emoji']} ${e['mood_detail']}'),
                                                            subtitle: Text(
                                                                '@${e['user_detail'][0]['username']} - ${e['mood_emoji']} ${e['mood_detail']}'),
                                                            trailing: e['status'] ==
                                                                    'Public'
                                                                ? Icon(Icons
                                                                    .public)
                                                                : e['status'] ==
                                                                        'Follower'
                                                                    ? Icon(Icons
                                                                        .people)
                                                                    : Icon(Icons
                                                                        .lock),
                                                            onTap: () async {
                                                              if (e['status'] ==
                                                                  'Follower') {
                                                                print('heeloo');
                                                                var check = await findFollow(
                                                                    e['user_detail']
                                                                            [0][
                                                                        '_id']);
                                                                if (check[
                                                                        'message'] ==
                                                                    'true') {
                                                                  Navigator.push(
                                                                          context,
                                                                          PageTransition(
                                                                              child: DiaryDetailPutdown(id: e['_id']),
                                                                              type: PageTransitionType.rightToLeft))
                                                                      .then((_) {
                                                                    setState(
                                                                        () {});
                                                                  });
                                                                } else if (check[
                                                                        'message'] ==
                                                                    'false') {
                                                                  Navigator.push(
                                                                      context,
                                                                      PageTransition(
                                                                          child:
                                                                              VisitorProfile(user_id: e['user_id']),
                                                                          type: PageTransitionType.rightToLeft));
                                                                } else {}
                                                              } else {
                                                                Navigator.push(
                                                                        context,
                                                                        PageTransition(
                                                                            child:
                                                                                DiaryDetailPutdown(id: e['_id']),
                                                                            type: PageTransitionType.rightToLeft))
                                                                    .then((_) {
                                                                  setState(
                                                                      () {});
                                                                });
                                                              }
                                                            },
                                                          ),
                                                        )
                                                        .toList()
                                                    : generalPutdown
                                                        .map<Widget>(
                                                          (e) => ListTile(
                                                            leading:
                                                                CircleAvatar(
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      'https://storage.googleapis.com/noseason/${e['user_detail'][0]['profile_image']}'),
                                                            ),
                                                            title: e['topic'] !=
                                                                    null
                                                                ? Text(
                                                                    e['topic'])
                                                                : Text(
                                                                    '${e['mood_emoji']} ${e['mood_detail']}'),
                                                            subtitle: Text(
                                                                '@${e['user_detail'][0]['username']} - ${e['mood_emoji']} ${e['mood_detail']}'),
                                                            trailing: e['status'] ==
                                                                    'Public'
                                                                ? Icon(Icons
                                                                    .public)
                                                                : e['status'] ==
                                                                        'Follower'
                                                                    ? Icon(Icons
                                                                        .people)
                                                                    : Icon(Icons
                                                                        .lock),
                                                            onTap: () async {
                                                              if (e['status'] ==
                                                                  'Follower') {
                                                                print('heeloo');
                                                                var check = await findFollow(
                                                                    e['user_detail']
                                                                            [0][
                                                                        '_id']);
                                                                if (check[
                                                                        'message'] ==
                                                                    'true') {
                                                                  Navigator.push(
                                                                          context,
                                                                          PageTransition(
                                                                              child: DiaryDetailPutdown(id: e['_id']),
                                                                              type: PageTransitionType.rightToLeft))
                                                                      .then((_) {
                                                                    setState(
                                                                        () {});
                                                                  });
                                                                } else if (check[
                                                                        'message'] ==
                                                                    'false') {
                                                                  Navigator.push(
                                                                      context,
                                                                      PageTransition(
                                                                          child:
                                                                              VisitorProfile(user_id: e['user_id']),
                                                                          type: PageTransitionType.rightToLeft));
                                                                } else {}
                                                              } else {
                                                                Navigator.push(
                                                                        context,
                                                                        PageTransition(
                                                                            child:
                                                                                DiaryDetailPutdown(id: e['_id']),
                                                                            type: PageTransitionType.rightToLeft))
                                                                    .then((_) {
                                                                  setState(
                                                                      () {});
                                                                });
                                                              }
                                                            },
                                                          ),
                                                        )
                                                        .toList(),
                                          ),
                                        ],
                                      )),
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  });
            });
          });
    }).toList();

    allpin = await findAllPin();
    allPinShow = allpin!.map<Marker>((e) {
      return Marker(
          markerId: MarkerId('${e['marker_id']}'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
          position: LatLng(e['lag'], e['lng']),
          infoWindow: InfoWindow(title: '${e['marker_id']}'),
          onTap: () {
            var lag = e['lag'];
            var lng = e['lng'];
            var pin = e['marker_id'];
            var pin_id = e['_id'];
            print(pin_id);
            Future.delayed(const Duration(seconds: 0), () async {
              var dis = distance(newlocation.latitude as double, lag,
                  newlocation.longitude as double, lng);
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return makeDismissible(
                      child: DraggableScrollableSheet(
                        initialChildSize: 1,
                        builder: (_, controller) => Scaffold(
                          backgroundColor: Colors.transparent,
                          appBar: AppBar(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            foregroundColor: Colors.black,
                            centerTitle: true,
                            title: Text(pin),
                          ),
                          body: FutureBuilder(
                            future: forDiarypinFunc(pin_id),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return SingleChildScrollView(
                                  child: Container(
                                      color: Colors.transparent,
                                      child: Column(
                                        children: [
                                          ListTile(
                                            onTap: () {
                                              if (dis > 0.050) {
                                                AwesomeDialog(
                                                        context: context,
                                                        dialogType:
                                                            DialogType.WARNING,
                                                        desc:
                                                            'Distance is to long.\nYou must to go closely on pin.\n Go closely on pin less than 50 meters.',
                                                        btnOk: ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                'ok')))
                                                    .show();
                                              } else {
                                                Navigator.push(
                                                    context,
                                                    PageTransition(
                                                        child:
                                                            WritePutdownDiary(
                                                          deal: 'general',
                                                          pin: pin_id,
                                                          pin_name: pin,
                                                        ),
                                                        type: PageTransitionType
                                                            .rightToLeft));
                                              }
                                            },
                                            leading: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: CircleAvatar(
                                                radius: 30,
                                                backgroundImage: NetworkImage(
                                                    'https://storage.googleapis.com/noseason/${user['profile_image']}'),
                                              ),
                                            ),
                                            title: const Text(
                                              'Put down your diary.',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            subtitle: Text(
                                                'distance: ${dis.toStringAsFixed(3)} km.'),
                                            trailing: const Icon(
                                                Icons.navigate_next_rounded),
                                          ),
                                          const Divider(
                                            thickness: 0.8,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20.0, 10.0, 20.0, 0),
                                            child: Row(
                                              children: [
                                                const Text('My diary: '),
                                                const Spacer(),
                                                TextButton(
                                                    onPressed: () async {
                                                      var c =
                                                          await Navigator.push(
                                                              context,
                                                              PageTransition(
                                                                  child:
                                                                      ListDiaryPutdown(
                                                                    diary: 2,
                                                                    pin: pin_id,
                                                                  ),
                                                                  type: PageTransitionType
                                                                      .rightToLeft));

                                                      setState(() {
                                                        print('asd');
                                                      });
                                                    },
                                                    child: Text(
                                                      'view more',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children: putdownDiary[2].length <=
                                                    2
                                                ? putdownDiary[2]
                                                    .map<Widget>(
                                                      (e) => ListTile(
                                                        leading: CircleAvatar(
                                                          backgroundImage:
                                                              NetworkImage(
                                                                  'https://storage.googleapis.com/noseason/${e['user_detail'][0]['profile_image']}'),
                                                        ),
                                                        title: e['topic'] !=
                                                                null
                                                            ? Text(e['topic'])
                                                            : Text(
                                                                '${e['mood_emoji']} ${e['mood_detail']}'),
                                                        subtitle: Text(
                                                            '@${e['user_detail'][0]['username']} - ${e['mood_emoji']} ${e['mood_detail']}'),
                                                        trailing: e['status'] ==
                                                                'Public'
                                                            ? Icon(Icons.public)
                                                            : e['status'] ==
                                                                    'Follower'
                                                                ? Icon(Icons
                                                                    .people)
                                                                : Icon(
                                                                    Icons.lock),
                                                        onTap: () async {
                                                          Navigator.push(
                                                                  context,
                                                                  PageTransition(
                                                                      child: DiaryDetailPutdown(
                                                                          id: e[
                                                                              '_id']),
                                                                      type: PageTransitionType
                                                                          .rightToLeft))
                                                              .then((_) {
                                                            setState(() {});
                                                          });
                                                        },
                                                      ),
                                                    )
                                                    .toList()
                                                : ownPutdown
                                                    .map<Widget>(
                                                      (e) => ListTile(
                                                        leading: CircleAvatar(
                                                          backgroundImage:
                                                              NetworkImage(
                                                                  'https://storage.googleapis.com/noseason/${e['user_detail'][0]['profile_image']}'),
                                                        ),
                                                        title: e['topic'] !=
                                                                null
                                                            ? Text(e['topic'])
                                                            : Text(
                                                                '${e['mood_emoji']} ${e['mood_detail']}'),
                                                        subtitle: Text(
                                                            '@${e['user_detail'][0]['username']} - ${e['mood_emoji']} ${e['mood_detail']}'),
                                                        trailing: e['status'] ==
                                                                'Public'
                                                            ? Icon(Icons.public)
                                                            : e['status'] ==
                                                                    'Follower'
                                                                ? Icon(Icons
                                                                    .people)
                                                                : Icon(
                                                                    Icons.lock),
                                                        onTap: () async {
                                                          Navigator.push(
                                                                  context,
                                                                  PageTransition(
                                                                      child: DiaryDetailPutdown(
                                                                          id: e[
                                                                              '_id']),
                                                                      type: PageTransitionType
                                                                          .rightToLeft))
                                                              .then((_) {
                                                            setState(() {});
                                                          });
                                                        },
                                                      ),
                                                    )
                                                    .toList(),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20.0, 10.0, 20.0, 0),
                                            child: Row(
                                              children: [
                                                Text('For following: '),
                                                Spacer(),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                              context,
                                                              PageTransition(
                                                                  child:
                                                                      ListDiaryPutdown(
                                                                    diary: 1,
                                                                    pin: pin_id,
                                                                  ),
                                                                  type: PageTransitionType
                                                                      .rightToLeft))
                                                          .then((_) {
                                                        setState(() {});
                                                      });
                                                    },
                                                    child: Text(
                                                      'view more',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children:
                                                putdownDiary[1].length <= 2
                                                    ? putdownDiary[1]
                                                        .map<Widget>(
                                                          (e) => ListTile(
                                                            leading:
                                                                CircleAvatar(
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      'https://storage.googleapis.com/noseason/${e['user_detail'][0]['profile_image']}'),
                                                            ),
                                                            title: e['topic'] !=
                                                                    null
                                                                ? Text(
                                                                    e['topic'])
                                                                : Text(
                                                                    '${e['mood_emoji']} ${e['mood_detail']}'),
                                                            subtitle: Text(
                                                                '@${e['user_detail'][0]['username']} - ${e['mood_emoji']} ${e['mood_detail']}'),
                                                            trailing: e['status'] ==
                                                                    'Public'
                                                                ? Icon(Icons
                                                                    .public)
                                                                : e['status'] ==
                                                                        'Follower'
                                                                    ? Icon(Icons
                                                                        .people)
                                                                    : Icon(Icons
                                                                        .lock),
                                                            onTap: () async {
                                                              if (e['status'] ==
                                                                  'Follower') {
                                                                var check = await findFollow(
                                                                    e['user_detail']
                                                                            [0][
                                                                        '_id']);
                                                                if (check[
                                                                        'message'] ==
                                                                    'true') {
                                                                  Navigator.push(
                                                                          context,
                                                                          PageTransition(
                                                                              child: DiaryDetailPutdown(id: e['_id']),
                                                                              type: PageTransitionType.rightToLeft))
                                                                      .then((_) {
                                                                    setState(
                                                                        () {});
                                                                  });
                                                                } else if (check[
                                                                        'message'] ==
                                                                    'false') {
                                                                  Navigator.push(
                                                                      context,
                                                                      PageTransition(
                                                                          child: VisitorProfile(
                                                                            user_id:
                                                                                e['user_id'],
                                                                          ),
                                                                          type: PageTransitionType.rightToLeft));
                                                                } else {}
                                                              } else {
                                                                Navigator.push(
                                                                        context,
                                                                        PageTransition(
                                                                            child:
                                                                                DiaryDetailPutdown(id: e['_id']),
                                                                            type: PageTransitionType.rightToLeft))
                                                                    .then((_) {
                                                                  setState(
                                                                      () {});
                                                                });
                                                              }
                                                            },
                                                          ),
                                                        )
                                                        .toList()
                                                    : followingPutdown
                                                        .map<Widget>(
                                                          (e) => ListTile(
                                                            leading:
                                                                CircleAvatar(
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      'https://storage.googleapis.com/noseason/${e['user_detail'][0]['profile_image']}'),
                                                            ),
                                                            title: e['topic'] !=
                                                                    null
                                                                ? Text(
                                                                    e['topic'])
                                                                : Text(
                                                                    '${e['mood_emoji']} ${e['mood_detail']}'),
                                                            subtitle: Text(
                                                                '@${e['user_detail'][0]['username']} - ${e['mood_emoji']} ${e['mood_detail']}'),
                                                            trailing: e['status'] ==
                                                                    'Public'
                                                                ? Icon(Icons
                                                                    .public)
                                                                : e['status'] ==
                                                                        'Follower'
                                                                    ? Icon(Icons
                                                                        .people)
                                                                    : Icon(Icons
                                                                        .lock),
                                                            onTap: () async {
                                                              if (e['status'] ==
                                                                  'Follower') {
                                                                print('heeloo');
                                                                var check = await findFollow(
                                                                    e['user_detail']
                                                                            [0][
                                                                        '_id']);
                                                                if (check[
                                                                        'message'] ==
                                                                    'true') {
                                                                  Navigator.push(
                                                                          context,
                                                                          PageTransition(
                                                                              child: DiaryDetailPutdown(id: e['_id']),
                                                                              type: PageTransitionType.rightToLeft))
                                                                      .then((_) {
                                                                    setState(
                                                                        () {});
                                                                  });
                                                                } else if (check[
                                                                        'message'] ==
                                                                    'false') {
                                                                  Navigator.push(
                                                                      context,
                                                                      PageTransition(
                                                                          child:
                                                                              VisitorProfile(user_id: e['user_id']),
                                                                          type: PageTransitionType.rightToLeft));
                                                                } else {}
                                                              } else {
                                                                Navigator.push(
                                                                        context,
                                                                        PageTransition(
                                                                            child:
                                                                                DiaryDetailPutdown(id: e['_id']),
                                                                            type: PageTransitionType.rightToLeft))
                                                                    .then((_) {
                                                                  setState(
                                                                      () {});
                                                                });
                                                              }
                                                            },
                                                          ),
                                                        )
                                                        .toList(),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20.0, 10.0, 20.0, 0),
                                            child: Row(
                                              children: [
                                                Text('General: '),
                                                Spacer(),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                              context,
                                                              PageTransition(
                                                                  child:
                                                                      ListDiaryPutdown(
                                                                    diary: 0,
                                                                    pin: pin_id,
                                                                  ),
                                                                  type: PageTransitionType
                                                                      .rightToLeft))
                                                          .then((_) {
                                                        setState(() {});
                                                      });
                                                    },
                                                    child: Text(
                                                      'view more',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children:
                                                putdownDiary[0].length <= 2
                                                    ? putdownDiary[0]
                                                        .map<Widget>(
                                                          (e) => ListTile(
                                                            leading:
                                                                CircleAvatar(
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      'https://storage.googleapis.com/noseason/${e['user_detail'][0]['profile_image']}'),
                                                            ),
                                                            title: e['topic'] !=
                                                                    null
                                                                ? Text(
                                                                    e['topic'])
                                                                : Text(
                                                                    '${e['mood_emoji']} ${e['mood_detail']}'),
                                                            subtitle: Text(
                                                                '@${e['user_detail'][0]['username']} - ${e['mood_emoji']} ${e['mood_detail']}'),
                                                            trailing: e['status'] ==
                                                                    'Public'
                                                                ? Icon(Icons
                                                                    .public)
                                                                : e['status'] ==
                                                                        'Follower'
                                                                    ? Icon(Icons
                                                                        .people)
                                                                    : Icon(Icons
                                                                        .lock),
                                                            onTap: () async {
                                                              if (e['status'] ==
                                                                  'Follower') {
                                                                print('heeloo');
                                                                var check = await findFollow(
                                                                    e['user_detail']
                                                                            [0][
                                                                        '_id']);
                                                                if (check[
                                                                        'message'] ==
                                                                    'true') {
                                                                  Navigator.push(
                                                                          context,
                                                                          PageTransition(
                                                                              child: DiaryDetailPutdown(id: e['_id']),
                                                                              type: PageTransitionType.rightToLeft))
                                                                      .then((_) {
                                                                    setState(
                                                                        () {});
                                                                  });
                                                                } else if (check[
                                                                        'message'] ==
                                                                    'false') {
                                                                  Navigator.push(
                                                                      context,
                                                                      PageTransition(
                                                                          child:
                                                                              VisitorProfile(user_id: e['user_id']),
                                                                          type: PageTransitionType.rightToLeft));
                                                                } else {}
                                                              } else {
                                                                Navigator.push(
                                                                        context,
                                                                        PageTransition(
                                                                            child:
                                                                                DiaryDetailPutdown(id: e['_id']),
                                                                            type: PageTransitionType.rightToLeft))
                                                                    .then((_) {
                                                                  setState(
                                                                      () {});
                                                                });
                                                              }
                                                            },
                                                          ),
                                                        )
                                                        .toList()
                                                    : generalPutdown
                                                        .map<Widget>(
                                                          (e) => ListTile(
                                                            leading:
                                                                CircleAvatar(
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      'https://storage.googleapis.com/noseason/${e['user_detail'][0]['profile_image']}'),
                                                            ),
                                                            title: e['topic'] !=
                                                                    null
                                                                ? Text(
                                                                    e['topic'])
                                                                : Text(
                                                                    '${e['mood_emoji']} ${e['mood_detail']}'),
                                                            subtitle: Text(
                                                                '@${e['user_detail'][0]['username']} - ${e['mood_emoji']} ${e['mood_detail']}'),
                                                            trailing: e['status'] ==
                                                                    'Public'
                                                                ? Icon(Icons
                                                                    .public)
                                                                : e['status'] ==
                                                                        'Follower'
                                                                    ? Icon(Icons
                                                                        .people)
                                                                    : Icon(Icons
                                                                        .lock),
                                                            onTap: () async {
                                                              if (e['status'] ==
                                                                  'Follower') {
                                                                print('heeloo');
                                                                var check = await findFollow(
                                                                    e['user_detail']
                                                                            [0][
                                                                        '_id']);
                                                                if (check[
                                                                        'message'] ==
                                                                    'true') {
                                                                  Navigator.push(
                                                                          context,
                                                                          PageTransition(
                                                                              child: DiaryDetailPutdown(id: e['_id']),
                                                                              type: PageTransitionType.rightToLeft))
                                                                      .then((_) {
                                                                    setState(
                                                                        () {});
                                                                  });
                                                                } else if (check[
                                                                        'message'] ==
                                                                    'false') {
                                                                  Navigator.push(
                                                                      context,
                                                                      PageTransition(
                                                                          child:
                                                                              VisitorProfile(user_id: e['user_id']),
                                                                          type: PageTransitionType.rightToLeft));
                                                                } else {}
                                                              } else {
                                                                Navigator.push(
                                                                        context,
                                                                        PageTransition(
                                                                            child:
                                                                                DiaryDetailPutdown(id: e['_id']),
                                                                            type: PageTransitionType.rightToLeft))
                                                                    .then((_) {
                                                                  setState(
                                                                      () {});
                                                                });
                                                              }
                                                            },
                                                          ),
                                                        )
                                                        .toList(),
                                          ),
                                        ],
                                      )),
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  });
            });
          });
    }).toList();
    print(allPinShow[0].runtimeType);
    setState(() {});
  }

  forDiarypinFunc(pin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    putdownDiary = await findDiaryInPin(token, pin);
    user = await findMyself(token);
    if (putdownDiary[2].length <= 2) {
    } else {
      ownPutdown = putdownDiary[2].sublist(0, 2);
    }
    if (putdownDiary[1].length <= 2) {
    } else {
      followingPutdown = putdownDiary[1].sublist(0, 2);
    }
    if (putdownDiary[0].length <= 2) {
    } else {
      generalPutdown = putdownDiary[0].sublist(0, 2);
    }
    setState(() {});
  }

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
    allPin();
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
          visible: false);

      // circle = Circle(
      //     circleId: CircleId("car"),
      //     radius: newLocalData.accuracy as double,
      //     zIndex: 1,
      //     strokeColor: Colors.blue,
      //     center: latlng,
      //     fillColor: Colors.blue.withAlpha(70)
      //     );
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
            setState(() {
              newlocation = newLocalData;
            });
          }
        } else {
          updateMarkerAndCircle(newLocalData, imageData);
          setState(() {
            newlocation = newLocalData;
          });
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
                                  child: OwnerPin(newlocation: newlocation),
                                  type: PageTransitionType.rightToLeft))
                          .then((_) {
                        allPin();
                        setState(() {});
                      });
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
          body: SlidingUpPanel(
            controller: panelController,
            minHeight: MediaQuery.of(context).size.height * 0.15,
            maxHeight: MediaQuery.of(context).size.height * 0.6,
            parallaxEnabled: true,
            parallaxOffset: .85,
            body: initlaglng != null
                ? Stack(
                    children: [
                      GoogleMap(
                        markers: marker != null
                            ? allpin != null
                                ? {
                                    for (int i = 0; i < allPinShow.length; i++)
                                      allPinShow[i],
                                    for (int i = 0;
                                        i < allEventShow.length;
                                        i++)
                                      allEventShow[i],
                                    marker!
                                  }
                                : {marker!}
                            : {
                                Marker(
                                    markerId: const MarkerId('_ku'),
                                    icon: BitmapDescriptor.defaultMarkerWithHue(
                                        BitmapDescriptor.hueCyan),
                                    position: const LatLng(
                                        13.697630703230097, 100.34083452967317),
                                    infoWindow: const InfoWindow(
                                        title: 'บ้าน'),
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
                                                                    fontSize:
                                                                        25),
                                                              ),
                                                              trailing:
                                                                  IconButton(
                                                                icon: const Icon(
                                                                    Icons
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
                                                            color:
                                                                Color.fromRGBO(
                                                                    148,
                                                                    92,
                                                                    254,
                                                                    1),
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
                                                            color:
                                                                Color.fromRGBO(
                                                                    148,
                                                                    92,
                                                                    254,
                                                                    1),
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
                        zoomControlsEnabled: true,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        mapToolbarEnabled: false,
                        // myLocationButtonEnabled: true,
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              elevation: 3,
                              shadowColor: Colors.black,
                              borderRadius: BorderRadius.circular(30),
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
                                    color: Colors.black54,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'search Location',
                                  hintStyle: const TextStyle(
                                      color: Colors.black38,
                                      fontWeight: FontWeight.w200),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(30)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(30)),
                                ),
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
            panelBuilder: (controller) =>
                PanelWidget(controller, panelController),
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          floatingActionButton: Padding(
            padding: const EdgeInsets.fromLTRB(0, 200, 0, 0),
            child: FloatingActionButton(
                elevation: 3,
                heroTag: 'asd',
                backgroundColor: Colors.white,
                child: click == true
                    ? const Icon(MdiIcons.crosshairs, color: Colors.black45)
                    : const Icon(MdiIcons.crosshairsGps,
                        color: Color(0xff8b82ff)),
                onPressed: () {
                  getCurrentLocation();
                  click = !click;
                }),
          ),
        ),
      ),
    );
  }

  Widget PanelWidget(
      ScrollController controller, PanelController panelController) {
    return ListView(
      padding: EdgeInsets.zero,
      controller: controller,
      children: [
        SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            print(panelController.isPanelClosed);
          },
          child: Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        SizedBox(height: 36),
        buildPinDetail(),
        SizedBox(height: 24)
      ],
    );
  }

  Widget buildPinDetail() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Text('Select location to put down your diary'),
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

findDiaryInPin(token, pin) async {
  var url = 'http://10.0.2.2:3000/putdown/findDiaryInPin';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{
          'token': token,
          'pin': pin,
        },
      ));
  var result = jsonDecode(response.body);
  return result;
}

findMyself(token) async {
  var url = 'http://10.0.2.2:3000/auth/rememberMe';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, String>{'token': token},
      ));

  var result = jsonDecode(response.body);
  return result;
}

distance(lagcurrent, lagpin, lngcurrent, lngpin) {
  const r = 6371e3;
  var lag1 = lagcurrent * (pi / 180);
  var lag2 = lagpin * (pi / 180);
  var lng1 = lngcurrent;
  var lng2 = lngpin;
  var relag = (lag2 - lag1) * (pi / 180);
  var relng = (lng2 - lng1) * (pi / 180);
  var z = (sin(relag / 2) * sin(relag / 2)) +
      (cos(lag1) * cos(lag2) * sin(relng / 2) * sin(relng / 2));
  var zz = 2 * atan2(sqrt(z), sqrt(1 - z));
  var zzz = r * zz;
  return zzz / 1000;
}

findAllPin() async {
  var url = 'http://10.0.2.2:3000/putdown/findAllMarker';
  final http.Response response = await http.get(
    Uri.parse(url),
  );
  var result = jsonDecode(response.body);
  return result;
}

findAllEventPin() async {
  var url = 'http://10.0.2.2:3000/putdown/findEventOnTime';
  final http.Response response = await http.get(
    Uri.parse(url),
  );
  var result = jsonDecode(response.body);
  return result;
}

findFollow(target_id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'http://10.0.2.2:3000/follow/checkFollowing';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{'token': token, 'target_id': target_id},
      ));

  var result = jsonDecode(response.body);
  return result;
}
