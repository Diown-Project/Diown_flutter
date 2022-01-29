import 'dart:convert';
import 'package:diown/pages/auth/signin.dart';
import 'package:diown/pages/mainpage/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
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
  // final inputController = InputController();
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
        dynamic passcode = prefs.getString('passcode');
        dynamic result = await rememberMe(c);
        if (result == null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const SignIn()));
        }
        if (passcode == null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Home()));
        } else {
          screenLock(
              context: context,
              correctString: passcode,
              title: const Text(
                'Please enter passcode',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              screenLockConfig: const ScreenLockConfig(
                backgroundColor: Colors.white,
              ),
              secretsConfig: const SecretsConfig(
                  spacing: 15, // or spacingRatio
                  padding: EdgeInsets.all(40),
                  secretConfig: SecretConfig(
                    borderColor: Colors.black,
                    borderSize: 2.0,
                    disabledColor: Colors.white,
                    enabledColor: Colors.black,
                    height: 15,
                    width: 15,
                  )),
              inputButtonConfig: InputButtonConfig(
                textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
                buttonStyle: OutlinedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                ),
              ),
              didUnlocked: () {
                Navigator.pushReplacementNamed(context, Home.id);
              },
              deleteButton: const Icon(Icons.backspace, color: Colors.black));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    checkUser();
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
