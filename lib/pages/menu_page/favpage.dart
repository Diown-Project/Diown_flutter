import 'dart:collection';
import 'dart:convert';

import 'package:diown/pages/diary/diarydetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FavPage extends StatefulWidget {
  const FavPage({Key? key}) : super(key: key);

  @override
  _FavPageState createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  dynamic listDiary;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  useFuncFindAllFav() async {
    listDiary = await findAllFav();
    for (var i in listDiary) {
      i['date'] = DateTime.parse(i['date']);
    }
    if (mounted) {
      setState(() {});
    }
  }

  bool justSort = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    useFuncFindAllFav();
  }

  onLoading() async {
    await useFuncFindAllFav();
    setState(() {});
    _refreshController.loadComplete();
  }

  void onRefresh() async {
    // monitor network fetch
    await useFuncFindAllFav();
    setState(() {});
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('favorite diary'),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SmartRefresher(
            onRefresh: onRefresh,
            onLoading: onLoading,
            controller: _refreshController,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CupertinoSearchTextField(
                      placeholder: 'Search by date, topic',
                      onChanged: (value) async {
                        listDiary = await favSearch(value);
                        setState(() {});
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                              
                              child: const Text(
                                'Sort by Date.',
                                style: TextStyle(fontSize: 18),
                              )),
                          const Spacer(),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                              onPressed: listDiary != null
                                  ? () {
                                      if (listDiary == null &&
                                          listDiary.length == 0 &&
                                          listDiary.length == 1) {
                                      } else if (justSort == false) {
                                        setState(() {
                                          listDiary.sort((a, b) {
                                            return a['date']!
                                                .compareTo(b['date']!) as int;
                                          });
                                          justSort = true;
                                        });
                                      } else {
                                        setState(() {
                                          listDiary.sort((b, a) {
                                            return a['date']!
                                                .compareTo(b['date']!) as int;
                                          });
                                          justSort = false;
                                        });
                                      }
                                    }
                                  : () {},
                              icon: const Icon(Icons.sort)),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Column(
                      children: listDiary != null
                          ? listDiary.length != 0
                              ? listDiary.map<Widget>((e) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      leading: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${e['mood_emoji']}',
                                            style: TextStyle(fontSize: 24),
                                          ),
                                        ],
                                      ),
                                      title: e['topic'] == null
                                          ? Text('${e['mood_detail']}',
                                              style: TextStyle(fontSize: 16))
                                          : RichText(
                                              overflow: TextOverflow.ellipsis,
                                              text: TextSpan(
                                                  text: '${e['topic']}',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16)),
                                            ),
                                      subtitle: e['activity'] == null
                                          ? null
                                          : Text('${e['activity']}'),
                                      trailing: Text(
                                          '${e['date'].toString().substring(0, 10)}'),
                                      tileColor: Color(0xfff1f3f4),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      onTap: () {
                                        Navigator.push(
                                                context,
                                                PageTransition(
                                                    child: DiaryDetail(
                                                        id: e['_id']),
                                                    type: PageTransitionType
                                                        .rightToLeft))
                                            .then((_) async {
                                          await useFuncFindAllFav();
                                          setState(() {});
                                        });
                                      },
                                    ),
                                  );
                                }).toList()
                              : [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    // crossAxisAlignment:CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 20),
                                      Icon(
                                        MdiIcons.bookOff,
                                        size: 100,
                                        color: Colors.grey[300],
                                      ),
                                      const SizedBox(height: 20),
                                      const Text(
                                        'Dont have favorite diary',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.grey),
                                      )
                                    ],
                                  )
                                ]
                          : [
                              const Center(
                                child: CircularProgressIndicator(),
                              )
                            ],
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

findAllFav() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'https://diown-app-server.herokuapp.com/localDiary/findAllFav';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{
          'token': token,
        },
      ));
  var result = jsonDecode(response.body);
  return result;
}

favSearch(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'https://diown-app-server.herokuapp.com/localDiary/favSearch';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{
          'token': token,
          'value': value,
        },
      ));
  var result = jsonDecode(response.body);
  return result;
}
