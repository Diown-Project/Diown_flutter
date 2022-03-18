import 'dart:convert';

import 'package:diown/pages/mainpage/map.dart';
import 'package:diown/pages/screens/editprofile.dart';
import 'package:diown/pages/screens/widgets/mood_chart.dart';
import 'package:diown/pages/screens/widgets/tab_sliver_delegate.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ink_widget/ink_widget.dart';
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
  final tabs = ['put down'];
  var user, isRequest, isFollowing;
  findForUser() async {
    user = await findUser(widget.user_id);
    var d = await checkRequest(widget.user_id);
    var f = await findFollow(widget.user_id);
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
    setState(() {});
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
                length: 1,
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
                          CustomScrollView(
                            slivers: [_builderList(30)],
                          ),
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
  var url = 'http://10.0.2.2:3000/auth/findUser';
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
  var url = 'http://10.0.2.2:3000/follow/checkRequest';
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
  var url = 'http://10.0.2.2:3000/follow/addRequest';
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
  var url = 'http://10.0.2.2:3000/follow/deleteRequest';
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