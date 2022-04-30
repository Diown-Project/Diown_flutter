import 'dart:convert';

import 'package:diown/pages/putdowndiary/diarydetailputdown.dart';
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

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  dynamic pro, allPutdown;
  findUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.get('token');
    pro = await callUser(token);
    allPutdown = await findAllPutdownDiary();
    for (int i = 0; i < allPutdown.length; i++) {
      allPutdown[i]['date'] = allPutdown[i]['date'].toString().substring(0, 10);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    findUser();
  }

  final tabs = ['put down', 'feeling', 'achieve'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          title: pro != null
              ? Text(
                  '${pro['username']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              : const Text(
                  'Please wait . . .',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: DefaultTabController(
          length: 3,
          child: pro != null
              ? NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 0.0, 10.0, 0.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Stack(children: [
                                      ClipOval(
                                          child: Material(
                                        color: Colors.transparent,
                                        child: Image.network(
                                          'https://storage.googleapis.com/noseason/${pro['profile_image']}',
                                          fit: BoxFit.cover,
                                          width: 100,
                                          height: 100,
                                        ),
                                      )),
                                      // Positioned(
                                      //   bottom: 0,
                                      //   right: 1,
                                      //   child: ClipOval(
                                      //     child: Container(
                                      //       padding: const EdgeInsets.all(4.0),
                                      //       color: Colors.white,
                                      //       child: ClipOval(
                                      //         child: Container(
                                      //           padding:
                                      //               const EdgeInsets.all(8.0),
                                      //           color: const Color(0xff945CFE),
                                      //           child: const Icon(
                                      //             Icons.edit,
                                      //             size: 20.0,
                                      //             color: Colors.white,
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                    ]),
                                    SizedBox(width: 10),
                                    Column(
                                      children: [
                                        Text(
                                          '${pro['putdown_num']}',
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
                                            '${pro['following_num']}',
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
                                          '${pro['follower_num']}',
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
                              pro['bio'] != null
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          18, 15, 15, 15),
                                      child: Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          '${pro['bio']}',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              height: 1.5,
                                              color: Colors.black54),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    )
                                  : Container(),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(18, 5, 15, 0),
                                child: GestureDetector(
                                  onTap: () async {
                                    Navigator.push(
                                            context,
                                            PageTransition(
                                                child: EditProfile(pro: pro),
                                                type: PageTransitionType
                                                    .rightToLeft))
                                        .then((_) async {
                                      await findUser();
                                      setState(() {});
                                    });
                                  },
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black54),
                                        borderRadius:
                                            BorderRadius.circular(4.0)),
                                    child: const Center(
                                      child: Text(
                                        'Edit Profile',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SliverOverlapAbsorber(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                        sliver: SliverPersistentHeader(
                          delegate: TabSliverDelegate(
                            TabBar(
                              indicator: MaterialIndicator(
                                  color: Color(0xffC7B7FF),
                                  bottomLeftRadius: 5,
                                  bottomRightRadius: 5,
                                  height: 4,
                                  horizontalPadding: 30),
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
                    ];
                  },
                  body: TabBarView(children: [
                    allPutdown != null
                        ? Container(
                            margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                            child: ListView.builder(
                              itemCount: allPutdown.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  onTap: () {
                                    Navigator.push(
                                            context,
                                            PageTransition(
                                                child: DiaryDetailPutdown(
                                                    id: allPutdown[index]
                                                        ['_id']),
                                                type: PageTransitionType
                                                    .rightToLeft))
                                        .then((_) async {
                                      await findUser();
                                      setState(() {});
                                    });
                                  },
                                  leading: Text(
                                    '${allPutdown[index]['mood_emoji']}',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  trailing: allPutdown[index]['date'] != null
                                      ? Text(allPutdown[index]['date'])
                                      : null,
                                  title: allPutdown[index]['topic'] != null
                                      ? Text("${allPutdown[index]['topic']}")
                                      : Text(
                                          '${allPutdown[index]['mood_detail']}'),
                                  subtitle: allPutdown[index]['activity'] !=
                                          null
                                      ? Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                '${allPutdown[index]['activity']} ',
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Flexible(
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.pin_drop_rounded,
                                                    color: Colors.blue,
                                                    size: 14,
                                                  ),
                                                  Text(
                                                      '${allPutdown[index]['marker_detail'][0]['marker_id']}',
                                                      style: const TextStyle(
                                                          color: Colors.blue))
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
                                                    Icons.pin_drop_rounded,
                                                    color: Colors.blue,
                                                    size: 14,
                                                  ),
                                                  Text(
                                                      '${allPutdown[index]['marker_detail'][0]['marker_id']}',
                                                      style: const TextStyle(
                                                          color: Colors.blue))
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                );
                              },
                            ))
                        : Container(
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                    BarChartOne(),
                    Achieve('achieve')
                  ]),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ));
  }

  IconButton _buildIcon(IconData icon) {
    return IconButton(
      onPressed: () {},
      splashRadius: 25,
      icon: Icon(
        icon,
        color: Colors.black,
        size: 20,
      ),
    );
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
        childCount: 11,
      ),
      itemExtent: 50,
    );
  }
}

callUser(token) async {
  var url = 'https://diown-app-server.herokuapp.com/auth/rememberMe';
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

checkAchievement4() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'https://diown-app-server.herokuapp.com/achievement/checkSuccess';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{'token': token, 'index': 4},
      ));
  var result = jsonDecode(response.body);
  return result;
}

findAllPutdownDiary() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'https://diown-app-server.herokuapp.com/putdown/findAllputDown';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{'token': token},
      ));
  var result = jsonDecode(response.body);
  return result;
}
