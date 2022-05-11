import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:diown/pages/auth/signin.dart';
import 'package:diown/pages/extraPage/loadding.dart';
import 'package:diown/pages/menu_page/FAQsScreen.dart';
import 'package:diown/pages/menu_page/favpage.dart';
import 'package:diown/pages/menu_page/follow.dart';
import 'package:diown/pages/menu_page/followRequest.dart';
import 'package:diown/pages/menu_page/following.dart';
import 'package:diown/pages/menu_page/picdiarypage.dart';
import 'package:diown/pages/menu_page/setting.dart';
import 'package:diown/pages/menu_page/support.dart';
import 'package:diown/pages/menu_page/testpage.dart';
import 'package:diown/pages/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DrawerDetails extends StatefulWidget {
  const DrawerDetails({Key? key}) : super(key: key);

  @override
  _DrawerDetailsState createState() => _DrawerDetailsState();
}

class _DrawerDetailsState extends State<DrawerDetails> {
  dynamic user;
  String? d;
  var request;
  // ignore: non_constant_identifier_names
  bool notification_switch = true;
  loaddingUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? c = prefs.getString('token');
    print(c);
    user = await rememberMe(c!);
    if (mounted) {
      setState(() {
        d = 'hello';
      });
    }
  }

  setRequest() async {
    request = await findRequest();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loaddingUserData();
    setRequest();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
          color: Colors.white,
            child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          user != null
              ? ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    backgroundImage: NetworkImage(
                        'https://storage.googleapis.com/noseason/${user['profile_image']}'),
                  ),
                  title: Text('${user['username']}'),
                  subtitle: const Text('edit profile'),
                  trailing: const Icon(Icons.navigate_next_rounded),
                  onTap: () {
                    Navigator.push(
                            context,
                            PageTransition(
                                child: ProfilePage(),
                                type: PageTransitionType.rightToLeft))
                        .then((_) {
                      loaddingUserData();
                      setState(() {});
                    });
                  },
                )
              : const Center(child: CircularProgressIndicator()),
          const Divider(
            thickness: 0.5,
          ),
          ListTile(
              leading: const Icon(Icons.star_border),
              title: const Text('Favorite'),
              visualDensity: VisualDensity.compact,
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: const FavPage(),
                        type: PageTransitionType.rightToLeft));
              }),
          ListTile(
              leading: const Icon(Icons.photo_camera_back),
              title: const Text('Picture diary'),
              visualDensity: VisualDensity.compact,
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: const PictureDiary(),
                        type: PageTransitionType.rightToLeft));
              }),
          ListTile(
              leading: const Icon(Icons.person_add_alt_1_outlined),
              title: const Text('Follow request'),
              visualDensity: VisualDensity.compact,
              trailing: request != null
                  ? request != 0
                      ? Badge(
                          animationDuration: const Duration(milliseconds: 100),
                          animationType: BadgeAnimationType.scale,
                          padding: EdgeInsets.all(6.0),
                          badgeContent: Text(
                            request.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        )
                      : null
                  : null,
              onTap: () {
                Navigator.push(
                        context,
                        PageTransition(
                            child: const FollowRequest_Page(),
                            type: PageTransitionType.rightToLeft))
                    .then((_) async {
                  await setRequest();
                });
              }),
          ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Following'),
              visualDensity: VisualDensity.compact,
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: const FollowingPage(),
                        type: PageTransitionType.rightToLeft));
              }),
          ListTile(
              leading: const Icon(Icons.groups_outlined),
              title: const Text('Follower'),
              visualDensity: VisualDensity.compact,
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: const FollowPage(),
                        type: PageTransitionType.rightToLeft));
              }),
          ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help Center'),
              visualDensity: VisualDensity.compact,
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: SupportPage(),
                        type: PageTransitionType.rightToLeft));
              }),
          ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              visualDensity: VisualDensity.compact,
              onTap: () {
                Navigator.of(context).push(PageTransition(
                    child: const SettingPage(),
                    type: PageTransitionType.rightToLeft));
              }),
          ListTile(
              leading: const Icon(
                Icons.logout_outlined,
                color: Colors.red,
              ),
              title: const Text(
                'Log out',
                style: TextStyle(color: Colors.red),
              ),
              visualDensity: VisualDensity.compact,
              onTap: () async {
                CoolAlert.show(
                  context: context,
                  type: CoolAlertType.confirm,
                  title: 'Do you sure to logout.',
                  confirmBtnColor: Colors.red,
                  confirmBtnText: 'Yes',
                  cancelBtnText: 'No',
                  onConfirmBtnTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('token');
                    prefs.remove('passcode');
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: const SignIn(),
                            type: PageTransitionType.rightToLeft));
                  },
                );
              }),
        ],
      ),
    )));
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
  return result.length;
}
