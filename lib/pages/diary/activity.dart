import 'dart:convert';

import 'package:diown/pages/auth/signin.dart';
import 'package:diown/pages/diary/editactivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);
  static var resultAct = '';
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  dynamic activity;
  dynamic base_activity;
  loadActivity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    activity = await findAllActivity(token);
    if (activity[0]['message'] == 'error') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const SignIn()));
    }
    base_activity = activity;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadActivity();
  }

  @override
  Widget build(BuildContext context) {
    return makeDismissible(
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        builder: (_, controller) => Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              title: const Text('Activity'),
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              child: const EditAct(),
                              type: PageTransitionType.rightToLeft));
                    },
                    child: const Text('Edit'),
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromRGBO(148, 92, 254, 1)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: const BorderSide(
                                        color:
                                            Color.fromRGBO(148, 92, 254, 1))))),
                  ),
                )
              ],
            ),
            body: Container(
              height: double.maxFinite,
              color: Colors.white,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      CupertinoSearchTextField(
                        onChanged: (value) {
                          if (activity == null) {
                          } else {
                            if (value == '') {
                              setState(() {
                                activity = base_activity;
                              });
                            } else {
                              setState(() {
                                activity = base_activity
                                    .where((e) => e['activity_detail']!
                                        .toLowerCase()
                                        .contains(value.toLowerCase()) as bool)
                                    .toList();
                              });
                            }
                          }
                        },
                      ),
                      Container(
                        child: Column(
                          children: activity != null
                              ? activity.isNotEmpty
                                  ? activity[0]['message'] != 'error'
                                      ? activity
                                          .map<Widget>((e) => ListTile(
                                                leading: Text(
                                                  e['activity_emoji'],
                                                  style: const TextStyle(
                                                      fontSize: 24),
                                                ),
                                                title:
                                                    Text(e['activity_detail']),
                                                onTap: () {
                                                  setState(() {
                                                    ActivityPage.resultAct =
                                                        '${e['activity_emoji']} ${e['activity_detail']}';
                                                  });
                                                  Navigator.pop(context);
                                                },
                                              ))
                                          .toList()
                                      : [Container()]
                                  : [Container()]
                              : [
                                  Container(
                                    child: const Padding(
                                      padding: EdgeInsets.all(100.0),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  )
                                ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }

  Widget makeDismissible({required Widget child}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(
            onTap: FocusScope.of(context).unfocus, child: child),
      );
}

findAllActivity(token) async {
  var url = 'http://10.0.2.2:3000/activity/allActivity';
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
