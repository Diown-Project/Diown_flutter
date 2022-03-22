import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
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
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestNow();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Follow request'),
      ),
      body: SingleChildScrollView(
          child: request != null
              ? Column(
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
                                    var c = await addToFollow(
                                        e['user_detail'][0]['_id']);
                                    request.removeWhere((element) =>
                                        element['user_detail'][0]['_id'] ==
                                        e['user_detail'][0]['_id']);
                                    setState(() {});
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
                )
              : Center(child: CircularProgressIndicator())),
    );
  }
}

findRequest() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'http://10.0.2.2:3000/follow/checkAllRequest';
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
  var url = 'http://10.0.2.2:3000/follow/addFollow';
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
  var url = 'http://10.0.2.2:3000/follow/removeRequest';
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
