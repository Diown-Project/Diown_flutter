import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:diown/pages/screens/visitorprofile.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
    if (following.length != 0) {
      var check = await checkAchievement(6);
      if (check['message'] == 'success') {
        AwesomeDialog(
                context: context,
                dismissOnTouchOutside: false,
                dialogType: DialogType.SUCCES,
                customHeader: Container(
                  height: 100,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset('images/Satellite.png')),
                ),
                title: 'congratulations',
                body: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 10, 10),
                    child: Column(
                      children: const [
                        Text(
                          'congratulations',
                          style: TextStyle(
                            fontSize: 20,
                            height: 1.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Congratulations to unlock this achievement (Satellite).',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )),
                btnOk: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Ok')))
            .show();
      } else {
        
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    moveResultToFollow();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: following != null
        ? following.length == 0 ? true : false 
        : false,
      backgroundColor: Color(0xffeff2f5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text('My Following'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
      ),
      body: following != null
          ? following.length != 0
            ? SingleChildScrollView(
              child: Column(
                children: following
                    .map<Widget>(
                      (e) => Container(
                        margin: EdgeInsets.fromLTRB(5, 15, 5, 0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.all(Radius.circular(5))),
                        child: ListTile(
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
                          // subtitle: const Text('One of your follower.'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              OutlinedButton(
                                  onPressed: () async {
                                    var c = await deleteFollowing(
                                        e['user_detail'][0]['_id']);
                                    following.removeWhere((element) =>
                                        element['user_detail'][0]['_id'] ==
                                        e['user_detail'][0]['_id']);
                                    setState(() {});
                                  },
                                  child: const Text(
                                    'Unfollow',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                style: OutlinedButton.styleFrom(
                                    minimumSize: Size(60, 35),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    side: BorderSide(width: 1.0, color: Colors.black)
                                  )       
                              )
                            ],
                          ),
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
                    MdiIcons.account,
                    size: 100,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'You are not following anyone yet.',
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

findFollowing() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'https://diown-app-server.herokuapp.com/follow/Following';
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
  var url = 'https://diown-app-server.herokuapp.com/follow/deleteFollowing';
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
