import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FollowRequest_Page extends StatefulWidget {
  const FollowRequest_Page({Key? key}) : super(key: key);

  @override
  State<FollowRequest_Page> createState() => _FollowRequest_PageState();
}

class _FollowRequest_PageState extends State<FollowRequest_Page> {
  var request;

  requestNow() async {
    request = await findRequest();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestNow();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: request != null
        ? request.length == 0 ? true : false 
        : false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Follow request'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
      ),
      body: request != null
          ? request.length != 0
            ? SingleChildScrollView(
              child: Column(
                children: request
                    .map<Widget>(
                      (e) => ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(
                              'https://storage.googleapis.com/noseason/${e['user_detail'][0]['profile_image']}'),
                        ),
                        title: Text(
                          e['user_detail'][0]['username'],
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: const Text('Want to follow you.'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                                onPressed: () async {
                                  var check = await checkAchievement(5);
                                  if (check['message'] == 'success') {
                                    AwesomeDialog(
                                            context: context,
                                            dismissOnTouchOutside: false,
                                            dialogType: DialogType.SUCCES,
                                            customHeader: Container(
                                              height: 100,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50),
                                                  child: Image.asset(
                                                      'images/Starlight.png')),
                                            ),
                                            title: 'congratulations',
                                            body: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 0, 10, 10),
                                                child: Column(
                                                  children: const [
                                                    Text(
                                                      'congratulations',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        height: 1.5,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text(
                                                      'Congratulations to unlock this achievement (Starlight).',
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                )),
                                            btnOk: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Ok')))
                                        .show();
                                    var c = await addToFollow(
                                        e['user_detail'][0]['_id']);
                                    request.removeWhere((element) =>
                                        element['user_detail'][0]['_id'] ==
                                        e['user_detail'][0]['_id']);
                                    setState(() {});
                                  } else {
                                    var c = await addToFollow(
                                        e['user_detail'][0]['_id']);
                                    request.removeWhere((element) =>
                                        element['user_detail'][0]['_id'] ==
                                        e['user_detail'][0]['_id']);
                                    setState(() {});
                                  }
                                },
                                child: const Text('confirm')),
                            TextButton(
                                onPressed: () async {
                                  var c = await remove(
                                      e['user_detail'][0]['_id']);
                                  request.removeWhere((element) =>
                                      element['user_detail'][0]['_id'] ==
                                      e['user_detail'][0]['_id']);
                                  setState(() {});
                                },
                                child: const Text(
                                  'remove',
                                  style: TextStyle(color: Colors.red),
                                ))
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Icon(
                      MdiIcons.accountMultiplePlus,
                      size: 100,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'When someone requests to follow you, \nit will show up here.',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

findRequest() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'https://diown-app-server.herokuapp.com/follow/checkAllRequest';
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

addToFollow(rb) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'https://diown-app-server.herokuapp.com/follow/addFollow';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{'target': token, 'request_by': rb},
      ));
  var result = jsonDecode(response.body);
  return result;
}

remove(rb) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'https://diown-app-server.herokuapp.com/follow/removeRequest';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{'token': token, 'request_by': rb},
      ));
  var result = jsonDecode(response.body);
  return result;
}

checkAchievement(index) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'https://diown-app-server.herokuapp.com/achievement/checkSuccess';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{'token': token, 'index': index},
      ));
  var result = jsonDecode(response.body);
  return result;
}
