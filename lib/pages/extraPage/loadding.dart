import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cool_alert/cool_alert.dart';
import 'package:diown/pages/auth/signin.dart';
import 'package:diown/pages/mainpage/home.dart';
import 'package:flutter/cupertino.dart';
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
    bool? checkfail = prefs.getBool('checkfail');
    String? date_checkfail = prefs.getString('date_checkfail');
    if (checkfail != null && checkfail == true) {
      // await prefs.setBool('checkfail', false);
      var date = DateTime.now();
      var date_checkfail2 = DateTime.parse(date_checkfail!);
      if (date.compareTo(date_checkfail2) == 1 &&
          ((date.second - date_checkfail2.second).abs() >= 30 ||
              (date.minute - date_checkfail2.minute).abs() >= 1 ||
              (date.hour - date_checkfail2.hour).abs() >= 1)) {
        prefs.remove('checkfail');
        prefs.remove('date_checkfail');
        Navigator.pushReplacementNamed(context, LoaddingPage.id);
      } else {
        showDialog(
            barrierDismissible: false,
            useRootNavigator: true,
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: const Text(
                  'password incorrect.',
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
                content: const Text(
                  'You enter password incorrect more than 5 times. Please wait 30 seconds to try again.',
                  style: TextStyle(fontSize: 14),
                ),
                actions: [
                  CupertinoDialogAction(
                    child: const Text('ok'),
                    onPressed: () {
                      exit(1);
                    },
                  )
                ],
              );
            });
      }
    } else {
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
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const SignIn()));
          }
          if (passcode == null) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const Home()));
          } else {
            screenLock(
                maxRetries: 5,
                didMaxRetries: (retries) {
                  prefs.setBool('checkfail', true);
                  prefs.setString('date_checkfail', DateTime.now().toString());
                  showDialog(
                      barrierDismissible: false,
                      useRootNavigator: true,
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          title: const Text(
                            'password incorrect.',
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          ),
                          content: const Text(
                            'You enter password incorrect more than 5 times. Please wait 30 seconds to try again.',
                            style: TextStyle(fontSize: 14),
                          ),
                          actions: [
                            CupertinoDialogAction(
                              child: const Text('ok'),
                              onPressed: () {
                                exit(1);
                              },
                            )
                          ],
                        );
                      });
                },
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
  }

  @override
  Widget build(BuildContext context) {
    checkUser();
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

rememberMe(String tokenId) async {
  var url = 'http://ec2-175-41-169-93.ap-southeast-1.compute.amazonaws.com:3000/auth/rememberMe';
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
