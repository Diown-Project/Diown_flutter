import 'package:diown/pages/event/carousel_loading.dart';
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
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 15, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'images/logo_support.png',
                      width: 120,
                    ),
                    ClipOval(
                      child: Image.asset('images/non.jpg', width: 50),
                    ),
                  ],
                ),
              ),
              CarouselLoading(),
          ],)],
        ),
      ),
    );
  }
}
