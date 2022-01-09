import 'package:diown/pages/auth/signin.dart';
import 'package:diown/pages/extraPage/loadding.dart';
import 'package:diown/pages/mainpage/calendar.dart';
import 'package:diown/pages/mainpage/home.dart';
import 'package:diown/pages/mainpage/home_page.dart';
import 'package:diown/pages/mainpage/map.dart';
import 'package:flutter/material.dart';
import 'package:diown/pages/auth/signup.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main(){
  runApp(MaterialApp(
    theme: ThemeData(fontFamily: 'readex'),
    initialRoute: LoaddingPage.id,
    routes: {
      SignIn.id: (context) => const SignIn(),
      SignUp.id: (context) => const SignUp(),
      Home.id: (context) => const Home(),
      LoaddingPage.id: (context) => const LoaddingPage(),
      MapPage.id: (context) => const MapPage(),
      CalendarPage.id: (context) => const CalendarPage(),
      HomePage.id: (context) => const HomePage()
    },
  ));
}
