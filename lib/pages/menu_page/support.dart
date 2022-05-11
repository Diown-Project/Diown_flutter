import 'package:diown/pages/menu_page/ContactScreen.dart';
import 'package:diown/pages/menu_page/FAQsScreen.dart';
import 'package:flutter/material.dart';

class SupportPage extends StatefulWidget {
  SupportPage({Key? key}) : super(key: key);

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('Help center',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontFamily: 'Readex Pro',
                  fontSize: 24,
                  letterSpacing:
                      0 /*percentages not used in flutter. defaulting to zero*/,
                  fontWeight: FontWeight.normal,
                  height: 0.6666666666666666)),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          bottom: const TabBar(
            labelColor: Colors.black,
            // labelStyle: TextStyle(color: Colors.pink),
            indicatorColor: Color(0xffC7B7FF),
            tabs: <Widget>[
              Tab(
                text: "FAQs",
              ),
              Tab(
                text: "Contact us",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[FAQsScreen(), ContactScreen()],
        ),
      ),
      length: 2,
      initialIndex: 0,
    );
  }
}
