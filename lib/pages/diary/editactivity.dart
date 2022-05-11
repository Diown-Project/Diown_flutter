import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:diown/pages/auth/signin.dart';
import 'package:diown/pages/diary/addactivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditAct extends StatefulWidget {
  const EditAct({Key? key}) : super(key: key);

  @override
  _EditActState createState() => _EditActState();
}

class _EditActState extends State<EditAct> {
  dynamic activity;
  dynamic base_activity;

  loadActivity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    activity = await findOnlyYouAct(token);
    base_activity = activity;
    if (activity == null) {
      activity = [];
    }
    print(activity);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadActivity();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Edit Activity'),
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: const AddActivity(),
                            type: PageTransitionType.rightToLeft));
                  },
                  child: const Text('Add'),
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xff8a7efd)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side:
                                  const BorderSide(color: Color(0xff8a7efd))))),
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
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
                Column(
                  children: activity != null
                      ? activity.isNotEmpty
                          ? activity[0]['message'] != 'error'
                              ? activity
                                  .map<Widget>((e) => ListTile(
                                        leading: Text(
                                          e['activity_emoji'],
                                          style: const TextStyle(fontSize: 24),
                                        ),
                                        title: Text(e['activity_detail']),
                                        trailing: IconButton(
                                          icon:
                                              const Icon(Icons.delete_rounded),
                                          onPressed: () async {
                                            CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.confirm,
                                              title: 'Do you sure ?',
                                              text:
                                                  'Do you sure to delete this activity',
                                              onConfirmBtnTap: () async {
                                                CoolAlert.show(
                                                    context: context,
                                                    type:
                                                        CoolAlertType.loading);
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                var token =
                                                    prefs.getString('token');
                                                var act_emo =
                                                    e['activity_emoji'];
                                                var act_detail =
                                                    e['activity_detail'];
                                                var result =
                                                    await removeYourAct(token,
                                                        act_emo, act_detail);
                                                if (result['message'] ==
                                                    'success') {
                                                  await loadActivity();
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                } else {
                                                  prefs.remove('token');
                                                  prefs.remove('passcode');
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const SignIn()));
                                                }
                                              },
                                            );
                                          },
                                        ),
                                      ))
                                  .toList()
                              : [
                                  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 20),
                                        Icon(
                                          MdiIcons.humanEdit,
                                          size: 100,
                                          color: Colors.grey[300],
                                        ),
                                        const SizedBox(height: 20),
                                        const Text(
                                          'You don\'t have any custom activity.',
                                          style: TextStyle(
                                              fontSize: 20, color: Colors.grey),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  )
                                ]
                          : [
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 20),
                                    Icon(
                                      MdiIcons.humanEdit,
                                      size: 100,
                                      color: Colors.grey[300],
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      'You don\'t have any custom activity.',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.grey),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              )
                            ]
                      : [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 200, 0, 0),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        ],
                ),
              ],
            ),
          ))),
    );
  }
}

removeYourAct(token, act_emo, act_detail) async {
  var url = 'https://diown-app-server.herokuapp.com/activity/remove';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, String>{
          'token': token,
          'act_emo': act_emo,
          'act_detail': act_detail
        },
      ));
  var result = jsonDecode(response.body);
  return result;
}

findOnlyYouAct(token) async {
  var url = 'https://diown-app-server.herokuapp.com/activity/onlyYourActivity';
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
