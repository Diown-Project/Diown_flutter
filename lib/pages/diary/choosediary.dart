import 'dart:convert';

import 'package:diown/pages/diary/diarydetail.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ChooseDiary extends StatefulWidget {
  const ChooseDiary({Key? key}) : super(key: key);

  @override
  _ChooseDiaryState createState() => _ChooseDiaryState();
}

class _ChooseDiaryState extends State<ChooseDiary> {
  dynamic allDiary;
  findAllYourDiary2() async {
    allDiary = await findAllYourDiary1();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Choose your diary.'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: findAllYourDiary2(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView(
                children: allDiary.map<Widget>((e) {
              return ListTile(
                leading: Text(
                  '${e['mood_emoji']}',
                  style: TextStyle(fontSize: 24),
                ),
                title: e['topic'] == null
                    ? Text('${e['mood_detail']}')
                    : Text('${e['topic']}'),
                subtitle:
                    e['activity'] == null ? null : Text('${e['activity']}'),
                trailing: Text('${e['date'].toString().substring(0, 10)}'),
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child:  DiaryDetail(id:e['_id']),
                          type: PageTransitionType.rightToLeft));
                },
              );
            }).toList());
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

findAllYourDiary1() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'http://10.0.2.2:3000/localDiary/findAllDiary';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, String>{'token': token!},
      ));
  var result = jsonDecode(response.body);
  return result;
}
