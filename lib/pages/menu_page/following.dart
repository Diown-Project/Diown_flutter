import 'dart:convert';
import 'package:diown/pages/screens/visitorprofile.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FollowingPage extends StatefulWidget {
  const FollowingPage({Key? key}) : super(key: key);

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  var following;

  moveResultToFollow() async {
    following = await findFollowing();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    moveResultToFollow();
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
        title: const Text('My Following'),
      ),
      body: SingleChildScrollView(
          child: following != null
              ? Column(
                  children: following
                      .map<Widget>(
                        (e) => ListTile(
                          onTap: () {
                            Navigator.push(
                                    context,
                                    PageTransition(
                                        child: VisitorProfile(
                                          user_id: e['user_detail'][0]['_id'],
                                        ),
                                        type: PageTransitionType.rightToLeft))
                                .then((_) async {
                              await moveResultToFollow();
                              setState(() {});
                            });
                          },
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                                'https://storage.googleapis.com/noseason/${e['user_detail'][0]['profile_image']}'),
                          ),
                          title: Text(
                            e['user_detail'][0]['username'],
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: const Text('One of your follower.'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                  onPressed: () async {
                                    var c = await deleteFollowing(e['user_detail'][0]['_id']);
                                    following.removeWhere((element) =>
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

findFollowing() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'http://10.0.2.2:3000/follow/Following';
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

deleteFollowing(id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'http://10.0.2.2:3000/follow/deleteFollowing';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{'token': token, 'target': id},
      ));
  var result = jsonDecode(response.body);
  return result;
}
