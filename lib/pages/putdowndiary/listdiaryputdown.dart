import 'dart:convert';
import 'package:diown/pages/mainpage/map.dart';
import 'package:diown/pages/putdowndiary/diarydetailputdown.dart';
import 'package:diown/pages/screens/visitorprofile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ListDiaryPutdown extends StatefulWidget {
  const ListDiaryPutdown({
    Key? key,
    required this.diary,
    required this.pin,
  }) : super(key: key);
  final diary, pin;
  @override
  State<ListDiaryPutdown> createState() => _ListDiaryPutdownState();
}

class _ListDiaryPutdownState extends State<ListDiaryPutdown> {
  var putdownDiary, savePutdownDiary, save2;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    forDiarypinFunc(widget.pin);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('More Diary.'),
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
        ),
        body: putdownDiary != null
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    CupertinoSearchTextField(
                      onChanged: (value) {
                        if (value == '') {
                          setState(() {
                            putdownDiary = [...save2];
                            savePutdownDiary = [...save2];
                          });
                        } else {
                          setState(() {
                            putdownDiary[widget.diary] =
                                savePutdownDiary[widget.diary].where((e) {
                              if (e['topic'] == null) {
                                if (e['mood_detail']!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())
                                        as bool ||
                                    e['user_detail'][0]['username']!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())
                                        as bool) {
                                  return true;
                                } else {
                                  return false;
                                }
                              } else {
                                if (e['mood_detail']!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())
                                        as bool ||
                                    e['topic']!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())
                                        as bool ||
                                    e['user_detail'][0]['username']!
                                            .toLowerCase()
                                            .contains(value.toLowerCase())
                                        as bool) {
                                  return true;
                                } else {
                                  return false;
                                }
                              }
                            }).toList();
                          });
                        }
                      },
                    ),
                    Column(
                      children: putdownDiary[widget.diary].map<Widget>((e) {
                        return ListTile(
                          leading: Text('${e['mood_emoji']}',
                              style: TextStyle(fontSize: 24)),
                          title: e['topic'] != null
                              ? Text(e['topic'])
                              : Text(e['mood_detail']),
                          subtitle: e['activity'] != null
                              ? Row(
                                  children: [
                                    Flexible(
                                        child: Text(
                                      '${e['activity']} @${e['user_detail'][0]['username']}',
                                      overflow: TextOverflow.ellipsis,
                                    ))
                                  ],
                                )
                              : Row(
                                  children: [
                                    Flexible(
                                        child: Text(
                                      '@${e['user_detail'][0]['username']}',
                                      overflow: TextOverflow.ellipsis,
                                    ))
                                  ],
                                ),
                          trailing: e['status'] == 'Public'
                              ? Icon(Icons.public)
                              : e['status'] == 'Follower'
                                  ? Icon(Icons.people)
                                  : Icon(Icons.lock),
                          onTap: () async {
                            if (widget.diary == 2) {
                              Navigator.push(
                                      context,
                                      PageTransition(
                                          child:
                                              DiaryDetailPutdown(id: e['_id']),
                                          type: PageTransitionType.rightToLeft))
                                  .then((_) {
                                setState(() {});
                              });
                            } else {
                              if (e['status'] == 'Follower') {
                                var check = await findFollow(
                                    e['user_detail'][0]['_id']);
                                if (check['message'] == 'true') {
                                  Navigator.push(
                                          context,
                                          PageTransition(
                                              child: DiaryDetailPutdown(
                                                  id: e['_id']),
                                              type: PageTransitionType
                                                  .rightToLeft))
                                      .then((_) {
                                    setState(() {});
                                  });
                                } else if (check['message'] == 'false') {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: VisitorProfile(
                                              user_id: e['user_id']),
                                          type:
                                              PageTransitionType.rightToLeft));
                                } else {}
                              } else {
                                Navigator.push(
                                        context,
                                        PageTransition(
                                            child: DiaryDetailPutdown(
                                                id: e['_id']),
                                            type:
                                                PageTransitionType.rightToLeft))
                                    .then((_) async {
                                  await forDiarypinFunc(widget.pin);
                                  setState(() {});
                                });
                              }
                            }
                          },
                        );
                      }).toList(),
                    )
                  ]),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  forDiarypinFunc(pin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    putdownDiary = await findDiaryInPin(token, pin);
    savePutdownDiary = [...putdownDiary];
    save2 = [...putdownDiary];
    if (mounted) {
      setState(() {});
    }
  }
}

findDiaryInPin(token, pin) async {
  var url = 'https://diown-app-server.herokuapp.com/putdown/findDiaryInPin';
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
