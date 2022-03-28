import 'dart:convert';
import 'package:diown/pages/putdowndiary/diarydetailputdown.dart';
import 'package:diown/pages/screens/visitorprofile.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FollowPage extends StatefulWidget {
  const FollowPage({Key? key}) : super(key: key);

  @override
  State<FollowPage> createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {
  var follower;

  moveResultToFollower() async {
    follower = await findFollower();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    moveResultToFollower();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text('My Follower'),
      ),
      body: SingleChildScrollView(
          child: follower != null
              ? Column(
                  children: follower
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
                              await moveResultToFollower();
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
                                    var c = await deleteFollower(
                                        e['user_detail'][0]['_id']);
                                    follower.removeWhere((element) =>
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

findFollower() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url =
      'http://ec2-175-41-169-93.ap-southeast-1.compute.amazonaws.com:3000/follow/follower';
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

deleteFollower(id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url =
      'http://ec2-175-41-169-93.ap-southeast-1.compute.amazonaws.com:3000/follow/deleteFollower';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{'target': token, 'following_by': id},
      ));
  var result = jsonDecode(response.body);
  return result;
}

findFollow(target_id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url =
      'http://ec2-175-41-169-93.ap-southeast-1.compute.amazonaws.com:3000/follow/checkFollowing';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{'token': token, 'target': target_id},
      ));

  var result = jsonDecode(response.body);
  return result;
}
