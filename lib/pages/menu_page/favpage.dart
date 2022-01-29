import 'dart:collection';
import 'dart:convert';

import 'package:diown/pages/diary/diarydetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    setState(() {});
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
    return Scaffold(
        appBar: AppBar(
          title: const Text('favorite diary'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
        ),
        body: SmartRefresher(
          onRefresh: onRefresh,
          onLoading: onLoading,
          controller: _refreshController,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  CupertinoSearchTextField(
                    onChanged: (value) async {
                      listDiary = await favSearch(value);
                      setState(() {});
                    },
                  ),
                  Row(
                    children: [
                      Container(
                          alignment: Alignment.topLeft,
                          child: const Text(
                            'Sort by Date.',
                            style: TextStyle(fontSize: 18),
                          )),
                      const Spacer(),
                      IconButton(
                          onPressed: listDiary != null
                              ? () {
                                  if (listDiary == null &&
                                      listDiary.length == 0 &&
                                      listDiary.length == 1) {
                                  } else if (justSort == false) {
                                    setState(() {
                                      listDiary.sort((a, b) {
                                        return a['date']!.compareTo(b['date']!)
                                            as int;
                                      });
                                      justSort = true;
                                    });
                                  } else {
                                    setState(() {
                                      listDiary.sort((b, a) {
                                        return a['date']!.compareTo(b['date']!)
                                            as int;
                                      });
                                      justSort = false;
                                    });
                                  }
                                }
                              : () {},
                          icon: const Icon(Icons.sort)),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Column(
                    children: listDiary != null
                        ? listDiary.length != 0
                            ? listDiary.map<Widget>((e) {
                                return ListTile(
                                  leading: Text(
                                    '${e['mood_emoji']}',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  title: e['topic'] == null
                                      ? Text('${e['mood_detail']}')
                                      : Text('${e['topic']}'),
                                  subtitle: e['activity'] == null
                                      ? null
                                      : Text('${e['activity']}'),
                                  trailing: Text(
                                      '${e['date'].toString().substring(0, 10)}'),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: DiaryDetail(id: e['_id']),
                                            type: PageTransitionType
                                                .rightToLeft));
                                  },
                                );
                              }).toList()
                            : [
                                const Center(
                                  child: Text('no favorite'),
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
        ));
  }
}

findAllFav() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'http://10.0.2.2:3000/localDiary/findAllFav';
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
  var url = 'http://10.0.2.2:3000/localDiary/favSearch';
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
