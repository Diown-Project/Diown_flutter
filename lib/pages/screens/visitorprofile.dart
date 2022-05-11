import 'dart:convert';

import 'package:diown/pages/mainpage/map.dart';
import 'package:diown/pages/putdowndiary/diarydetailputdown.dart';
import 'package:diown/pages/screens/editprofile.dart';
import 'package:diown/pages/screens/visitorachiement.dart';
import 'package:diown/pages/screens/widgets/mood_chart.dart';
import 'package:diown/pages/screens/widgets/tab_sliver_delegate.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ink_widget/ink_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:http/http.dart' as http;
import 'achievement.dart';

class VisitorProfile extends StatefulWidget {
  const VisitorProfile({Key? key, required this.user_id}) : super(key: key);
  final user_id;
  @override
  State<VisitorProfile> createState() => _VisitorProfileState();
}

class _VisitorProfileState extends State<VisitorProfile> {
  final tabs = ['put down', 'achieve'];
  var user, isRequest, isFollowing, allPutdown;
  findForUser() async {
    user = await findUser(widget.user_id);
    var d = await checkRequest(widget.user_id);
    var f = await findFollow(widget.user_id);
    allPutdown = await findAllPutdownUser(widget.user_id);
    for (int i = 0; i < allPutdown.length; i++) {
      allPutdown[i]['date'] = allPutdown[i]['date'].toString().substring(0, 10);
    }
    if (d['message'] == 'true') {
      isRequest = true;
    } else {
      isRequest = false;
    }
    if (f['message'] == 'true') {
      isFollowing = true;
    } else {
      isFollowing = false;
    }
    if (mounted) {
      setState(() {
        user;
        allPutdown;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findForUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
            title: user != null
                ? Text(user['username'])
                : const Text('Loading . . .'),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            )),
        body: user != null
            ? DefaultTabController(
                length: 2,
                child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.all(0),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ClipOval(
                                        child: Material(
                                      color: Colors.transparent,
                                      child: Image.network(
                                        'https://storage.googleapis.com/noseason/${user['profile_image']}',
                                        fit: BoxFit.cover,
                                        width: 90,
                                        height: 90,
                                      ),
                                    )),
                                    SizedBox(width: 10),
                                    Column(
                                      children: [
                                        Text(
                                          user['putdown_num'].toString(),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            height: 1.5,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Text('Put down')
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Column(
                                        children: [
                                          Text(
                                            user['following_num'].toString(),
                                            style: const TextStyle(
                                              fontSize: 20,
                                              height: 1.5,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Text('Following')
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Column(children: [
                                        Text(
                                          user['follower_num'].toString(),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            height: 1.5,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Text('Followers')
                                      ]),
                                    ),
                                  ],
                                ),
                              ),
                              user['bio'] != null
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 15, 15, 15),
                                      child: Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'bio',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              height: 1.5,
                                              color: Colors.black54),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    )
                                  : Container(),
                              isRequest
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 10, 15, 0),
                                      child: GestureDetector(
                                        onTap: () async {
                                          var re = await deleteRequest(
                                              widget.user_id);
                                          setState(() {
                                            isRequest = false;
                                          });
                                        },
                                        child: Container(
                                          height: 35,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black38),
                                              borderRadius:
                                                  BorderRadius.circular(4.0)),
                                          child: const Center(
                                            child: Text(
                                              'Requested',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black87),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : isFollowing
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 10, 15, 0),
                                          child: GestureDetector(
                                            onTap: () async {
                                              var c =
                                                  await unFollow(user['_id']);
                                              await findForUser();
                                              setState(() {
                                                isFollowing = false;
                                              });
                                            },
                                            child: Container(
                                              height: 35,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black38),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0)),
                                              child: const Center(
                                                child: Text(
                                                  'Unfollow',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black87),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 10, 15, 0),
                                          child: GestureDetector(
                                            onTap: () async {
                                              var re = await addRequest(
                                                  widget.user_id);
                                              setState(() {
                                                isRequest = true;
                                              });
                                            },
                                            child: Container(
                                              height: 35,
                                              decoration: BoxDecoration(
                                                  color: Color(0xff8a7efd),
                                                  border: Border.all(
                                                      color:
                                                          Colors.transparent),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0)),
                                              child: const Center(
                                                child: Text(
                                                  'Follow',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                            ],
                          ),
                        ),
                      ),
                      isFollowing
                          ? SliverOverlapAbsorber(
                              handle: NestedScrollView
                                  .sliverOverlapAbsorberHandleFor(context),
                              sliver: SliverPersistentHeader(
                                delegate: TabSliverDelegate(
                                  TabBar(
                                    indicator: MaterialIndicator(
                                        color: Color(0xffC7B7FF),
                                        bottomLeftRadius: 5,
                                        bottomRightRadius: 5,
                                        height: 4,
                                        horizontalPadding: 20),
                                    labelColor: Colors.black,
                                    unselectedLabelColor: Colors.grey[400],
                                    tabs: tabs
                                        .map((e) => Tab(
                                              child: Text(
                                                e,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ),
                                pinned: true,
                              ),
                            )
                          : SliverOverlapAbsorber(
                              handle: NestedScrollView
                                  .sliverOverlapAbsorberHandleFor(context))
                    ];
                  },
                  body: isFollowing
                      ? TabBarView(children: [
                          allPutdown != null
                              ? allPutdown.length != 0
                                ? Container(
                                  margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                                  child: ListView.builder(
                                    itemCount: allPutdown.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                  child: DiaryDetailPutdown(
                                                      id: allPutdown[index]
                                                          ['_id']),
                                                  type: PageTransitionType
                                                      .rightToLeft));
                                        },
                                        leading: Text(
                                          '${allPutdown[index]['mood_emoji']}',
                                          style: TextStyle(fontSize: 24),
                                        ),
                                        trailing: allPutdown[index]['date'] !=
                                                null
                                            ? Text(allPutdown[index]['date'])
                                            : null,
                                        title: allPutdown[index]['topic'] !=
                                                null
                                            ? Text(
                                                "${allPutdown[index]['topic']}")
                                            : Text(
                                                '${allPutdown[index]['mood_detail']}'),
                                        subtitle: allPutdown[index]
                                                    ['activity'] !=
                                                null
                                            ? Row(
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      '${allPutdown[index]['activity']} ',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .pin_drop_rounded,
                                                          color: Colors.blue,
                                                          size: 14,
                                                        ),
                                                        Text(
                                                            '${allPutdown[index]['marker_detail'][0]['marker_id']}',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .blue))
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  Flexible(
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .pin_drop_rounded,
                                                          color: Colors.blue,
                                                          size: 14,
                                                        ),
                                                        Text(
                                                            '${allPutdown[index]['marker_detail'][0]['marker_id']}',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .blue))
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      );
                                    },
                                  ))
                                  : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 20),
                                      Icon(
                                        MdiIcons.bookMarker,
                                        size: 100,
                                        color: Colors.grey[300],
                                      ),
                                      const SizedBox(height: 20),
                                      const Text(
                                        'Dont have putdown diary',
                                        style:
                                            TextStyle(fontSize: 20, color: Colors.grey),
                                      )
                                    ],
                                  )
                              : Container(
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                          visitorAchieve('Achieve', user_id: user['_id'])
                        ])
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'This profile is private',
                                style: TextStyle(color: Colors.black45),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'only confirmed followers can read diary you need to send a request before you can start following this account',
                                style: TextStyle(color: Colors.black45),
                              )
                            ],
                          ),
                        ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  Widget _builderList(int items) {
    return SliverFixedExtentList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Center(
            child: Text(
              'Item $index',
              textScaleFactor: 2,
            ),
          );
        },
        childCount: items,
      ),
      itemExtent: 50,
    );
  }
}

findUser(id) async {
  var url = 'https://diown-app-server.herokuapp.com/auth/findUser';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, String>{'id': id},
      ));

  var result = jsonDecode(response.body);
  return result;
}

checkRequest(target_id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'https://diown-app-server.herokuapp.com/follow/checkRequest';
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

addRequest(target_id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'https://diown-app-server.herokuapp.com/follow/addRequest';
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

deleteRequest(target_id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'https://diown-app-server.herokuapp.com/follow/deleteRequest';
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

unFollow(target_id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'https://diown-app-server.herokuapp.com/follow/deleteFollowing';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{'token': token, 'target': target_id},
      ));

  var result = jsonDecode(response.body);
  return result;
}

findAllPutdownUser(id) async {
  var url = 'https://diown-app-server.herokuapp.com/putdown/findAllPutdownUser';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{'user_id': id},
      ));

  var result = jsonDecode(response.body);
  return result;
}
