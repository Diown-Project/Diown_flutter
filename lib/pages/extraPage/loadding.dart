import 'dart:convert';
import 'package:diown/pages/auth/signin.dart';
import 'package:diown/pages/mainpage/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoaddingPage extends StatefulWidget {
  const LoaddingPage({Key? key}) : super(key: key);
  static String id = 'LoaddingPage';
  @override
  _LoaddingPageState createState() => _LoaddingPageState();
}

class _LoaddingPageState extends State<LoaddingPage> {
  dynamic user;
  checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? c = prefs.getString('token');
    if (c == null) {
      prefs.remove('token');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const SignIn()));
    } else {
      user = await rememberMe(c);
      if (user == null) {
        prefs.remove('token');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const SignIn()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Home()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          } else {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }
        });
  }
}

rememberMe(String tokenId) async {
  var url = 'http://10.0.2.2:3000/auth/rememberMe';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, String>{'token': tokenId},
      ));

  var result = jsonDecode(response.body);
  return result;
}
