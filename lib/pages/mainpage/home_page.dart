import 'package:diown/pages/mainpage/homeDetail/FeatureEvent.dart';
import 'package:diown/pages/mainpage/homeDetail/HomeAppBar.dart';
import 'package:diown/pages/mainpage/homeDetail/ListEvent.dart';
import 'package:diown/pages/mainpage/homeDetail/TitleEvent.dart';
import 'package:diown/pages/mainpage/homeDetail/TitleLast.dart';
import 'package:diown/pages/mainpage/homeDetail/TitlePut.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static String id = 'HomePage';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
            HomeAppBar(),
            // TitleEvent('Event', '+ more'),
            FeatureEvent(),
            TitlePut('Following put down', '+ more'),
            TitleLast('Last Diary'),
          
        ],)],
      ),
    );
  }
}
