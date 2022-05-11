import 'dart:convert';
import 'dart:io';
import 'package:cool_alert/cool_alert.dart';
import 'package:diown/pages/auth/signup.dart';
import 'package:diown/pages/mainpage/home.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dart_ipify/dart_ipify.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);
  static String id = 'SignIn';
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formkey = GlobalKey<FormState>();

  String? email;
  String? password;
  bool see = true;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: Color(0xffeff2f5),   
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
                  height: 5,
                ),
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'DIOWN',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                    key: _formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Email',
                          style: TextStyle(
                              color: Color(0xff8fa1b6),
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: const Color(0xff8a7efd),
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'yourname@example.com',
                            hintStyle: TextStyle(
                                color: Color(0xffc5d2e1),
                                fontWeight: FontWeight.w200),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff8a7efd), width: 2),
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            // prefixIcon: Icon(
                            //   Icons.email_outlined,
                            // ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field is required';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            email = value;
                          },
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        const Text(
                          'Password',
                          style: TextStyle(
                              color: Color(0xff8fa1b6),
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          cursorColor: Color(0xff8a7efd),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'yourpassword',
                            hintStyle: const TextStyle(
                                color: Color(0xffc5d2e1),
                                fontWeight: FontWeight.w200),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff8a7efd), width: 2),
                            ),
                            enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            // prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  see = !see;
                                });
                              },
                              icon: Icon(see
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              color: Color(0xff8fa1b6),
                              focusColor: Color(0xff8fa1b6),
                            ),
                          ),
                          obscureText: see,
                          onSaved: (value) {
                            password = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              if (_formkey.currentState!.validate()) {
                                _formkey.currentState!.save();
                              }
                            });

                            if (email == null || password == null) {
                            } else {
                              CoolAlert.show(
                                barrierDismissible: false,
                                context: context,
                                type: CoolAlertType.loading,
                              );
                              await signin(email, password);
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String? msg = prefs.getString('msg');
                              if (msg == 'success') {
                                Navigator.pop(context);
                                Navigator.of(context)
                                    .pushReplacement(PageTransition(
                                  child: const Home(),
                                  type: PageTransitionType.rightToLeft,
                                ));
                              } else {
                                CoolAlert.show(
                                    barrierDismissible: false,
                                    context: context,
                                    type: CoolAlertType.error,
                                    title: 'Error',
                                    text: msg,
                                    onConfirmBtnTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    });
                              }
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            height: 60,
                            decoration: const BoxDecoration(
                                color: Color(0xff8b82ff),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: const Center(
                              child: Text(
                                'SIGN IN',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Register now',
                          style: TextStyle(
                            color: Color(0xff8a7efd),
                            fontSize: 15
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

signin(email, password) async {
  var url = 'https://diown-app-server.herokuapp.com/auth/signin';
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
  if (result['token'] != null) {
    await prefs.setString('token', result['token']);
  }
}
