import 'package:diown/pages/diary/choosediary.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);
  static String id = 'CalendarPage';
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  PageTransition(
                      child: const ChooseDiary(),
                      type: PageTransitionType.rightToLeft));
            },
            child: Text('diary')),
      ),
    ));
  }
}
