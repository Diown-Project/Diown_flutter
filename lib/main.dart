import 'package:diown/pages/auth/signin.dart';
import 'package:diown/pages/diary/local_write.dart';
import 'package:diown/pages/extraPage/loadding.dart';
import 'package:diown/pages/mainpage/calendar.dart';
import 'package:diown/pages/mainpage/home.dart';
import 'package:diown/pages/mainpage/home_page.dart';
import 'package:diown/pages/mainpage/map.dart';
import 'package:flutter/material.dart';
import 'package:diown/pages/auth/signup.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MaterialApp(
    theme: ThemeData(fontFamily: 'readex'),
    initialRoute: LoaddingPage.id,
    debugShowCheckedModeBanner: false,
    routes: {
      LocalDiary.id: (context) => const LocalDiary(),
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
