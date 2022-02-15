import 'dart:convert';
import 'package:cool_alert/cool_alert.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);
  static String id = 'SignUp';
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formkey = GlobalKey<FormState>();

  String? username;
  String? email;
  String? password;
  String? checkPassword1, checkPassword2;
  bool see1 = true;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: Colors.black,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: const Text(
                      'Sign Up',
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
                            maxLength: 20,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: 'username',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              prefixIcon: Icon(
                                Icons.person,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'You must to fill this field.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              username = value;
                            },
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
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
                              } else if (!value.contains('@')) {
                                return 'Your input must be email.';
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
                          TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'password',
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      see1 = !see1;
                                    });
                                  },
                                  icon: Icon(see1
                                      ? Icons.visibility
                                      : Icons.visibility_off)),
                            ),
                            obscureText: see1,
                            onSaved: (value) {
                              password = value;
                            },
                            validator: (value) {
                              setState(() {
                                checkPassword1 = value;
                              });
                              if (value == null || value.isEmpty) {
                                return 'You must to fill this field.';
                              } else if (value.length <= 8) {
                                return 'Your password must be greater than 8';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 25),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Confirm password',
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      see1 = !see1;
                                    });
                                  },
                                  icon: Icon(see1
                                      ? Icons.visibility
                                      : Icons.visibility_off)),
                            ),
                            obscureText: see1,
                            onSaved: (value) {
                              password = value;
                            },
                            validator: (value) {
                              setState(() {
                                checkPassword2 = value;
                              });
                              if (value == null || value.isEmpty) {
                                return 'You must to fill this field.';
                              }
                              if (checkPassword1 != checkPassword2) {
                                return 'your password not match each other.';
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
                                if (email != null &&
                                    password != null &&
                                    username != null) {
                                  CoolAlert.show(
                                    barrierDismissible: false,
                                    context: context,
                                    type: CoolAlertType.loading,
                                  );
                                  await signup(username, email, password);
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  String? msg = prefs.getString('msg');
                                  if (msg == 'success') {
                                    CoolAlert.show(
                                      barrierDismissible: false,
                                      context: context,
                                      type: CoolAlertType.success,
                                      title: msg,
                                      text:
                                          "Your registeration was successful!",
                                      onConfirmBtnTap: () {
                                        prefs.remove('msg');
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  } else {
                                    CoolAlert.show(
                                      barrierDismissible: false,
                                      context: context,
                                      type: CoolAlertType.error,
                                      text: msg,
                                      onConfirmBtnTap: () {
                                        prefs.remove('msg');
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  }
                                }
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(fontSize: 20),
                              ),
                              style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all<Size>(
                                      const Size(304, 65)),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black),
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                      const Color.fromRGBO(229, 221, 255, 1)),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(80.0),
                                          side: const BorderSide(
                                              color:
                                                  Color.fromRGBO(229, 221, 255, 1)))))),
                        ],
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Already have an account?'))
                ],
              ),
            )),
      ),
    );
  }
}

signup(username, email, password) async {
  var url = 'http://10.0.2.2:3000/auth/signup';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, String>{
          'username': username,
          'email': email,
          'password': password
        },
      ));
  var result = jsonDecode(response.body);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('msg', result['msg']);

  // SharedPreferences.setMockInitialValues({});
}
