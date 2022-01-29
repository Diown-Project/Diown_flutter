import 'package:cool_alert/cool_alert.dart';
import 'package:diown/pages/auth/signin.dart';
import 'package:diown/pages/extraPage/loadding.dart';
import 'package:diown/pages/menu_page/favpage.dart';
import 'package:diown/pages/menu_page/picdiarypage.dart';
import 'package:diown/pages/menu_page/setting.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerDetails extends StatefulWidget {
  const DrawerDetails({Key? key}) : super(key: key);

  @override
  _DrawerDetailsState createState() => _DrawerDetailsState();
}

class _DrawerDetailsState extends State<DrawerDetails> {
  dynamic user;
  String? d;
  // ignore: non_constant_identifier_names
  bool notification_switch = true;
  loaddingUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? c = prefs.getString('token');
    user = await rememberMe(c!);
    setState(() {
      d = 'hello';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loaddingUserData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          user != null
              ? ListTile(
                  leading: const CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        'https://storage.googleapis.com/noseason/nonja'),
                  ),
                  title: Text('${user['username']}'),
                  subtitle: const Text('edit profile.'),
                  trailing: const Icon(Icons.navigate_next_rounded),
                  onTap: () {},
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
              onTap: () {}),
          ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Following'),
              visualDensity: VisualDensity.compact,
              onTap: () {}),
          ListTile(
              leading: const Icon(Icons.groups_outlined),
              title: const Text('Follower'),
              visualDensity: VisualDensity.compact,
              onTap: () {}),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Notification'),
            visualDensity: VisualDensity.compact,
            trailing: Switch(
                value: notification_switch,
                onChanged: (newvalue) {
                  setState(() {
                    notification_switch = newvalue;
                  });
                }),
          ),
          ListTile(
              leading: const Icon(Icons.backup_outlined),
              title: const Text('Backup and Restore data'),
              visualDensity: VisualDensity.compact,
              onTap: () {}),
          ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help Center'),
              visualDensity: VisualDensity.compact,
              onTap: () {}),
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
                  onConfirmBtnTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('token');
                    prefs.remove('passcode');
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
