import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:diown/pages/auth/signup.dart';
import 'package:diown/pages/mainpage/home.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);
  static String id = 'SignIn';
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formkey = GlobalKey<FormState>();
  final  textEditingController = TextEditingController(); 
  String? email;
  String? password;
  bool see = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Center(
                child: Image(
                  image: AssetImage('images/diownlogo.png'),
                  width: 220,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'readex'),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: textEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'email',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'You must to fill this field.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          email = value;
                        },
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                          labelText: 'password',
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  see = !see;
                                });
                              },
                              icon: Icon(see
                                  ? Icons.visibility
                                  : Icons.visibility_off)),
                        ),
                        obscureText: see,
                        onSaved: (value) {
                          password = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'You must to fill this field.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              if (_formkey.currentState!.validate()) {
                                _formkey.currentState!.save();
                              }
                            });

                            if (email == null || password == null) {
                            } else {
                              CoolAlert.show(
                                context: context,
                                type: CoolAlertType.loading,
                              );
                              await signin(email, password);
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String? msg = prefs.getString('msg');
                              if (msg == 'success') {
                                Navigator.of(context)
                                    .pushReplacement(PageTransition(
                                  child: const Home(),
                                  type: PageTransitionType.rightToLeft,
                                ));
                              } else {
                                CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.error,
                                    title: 'Error warning!',
                                    text: msg,
                                    onConfirmBtnTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    });
                              }
                            }
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(fontSize: 20),
                          ),
                          style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(304, 65)),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromRGBO(229, 221, 255, 1)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(80.0),
                                      side: const BorderSide(
                                          color: Color.fromRGBO(
                                              229, 221, 255, 1)))))),
                    ],
                  )),
              const SizedBox(
                height: 15,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: const SignUp()));
                  },
                  child: const Text('Dont have an account?'))
            ],
          ),
        ),
      ),
    );
  }
}

signin(email, password) async {
  var url = 'http://10.0.2.2:3000/auth/signin';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, String>{'email': email, 'password': password},
      ));
  var result = jsonDecode(response.body);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('msg', result['msg']);
  if(result['token'] != null){
    await prefs.setString('token', result['token']);
  }
}
