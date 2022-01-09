import 'package:diown/pages/menu_page/pinpasswordpage.dart';
import 'package:diown/pages/menu_page/privacy.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Set pin password"),
            trailing: const Icon(Icons.navigate_next_rounded),
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      child: const Pin(),
                      type: PageTransitionType.rightToLeft));
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text("Privacy policy"),
            trailing: const Icon(Icons.navigate_next_rounded),
            onTap: () {
              Navigator.of(context).push(PageTransition(
                  child: const PrivacypolicyWidget(),
                  type: PageTransitionType.rightToLeft));
            },
          ),
        ],
      ),
    );
  }
}
