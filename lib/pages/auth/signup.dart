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
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Color(0xffeff2f5),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: Colors.black,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: const Text(
                      'Create your',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: const Text(
                      'account',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.normal,
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
                          const SizedBox(height: 5),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: Color(0xff8a7efd),
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
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              } else if (!value.contains('@')) {
                                return 'Your input must be email';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              email = value;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            'Username',
                            style: TextStyle(
                                color: Color(0xff8fa1b6),
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            maxLength: 20,
                            keyboardType: TextInputType.text,
                            cursorColor: Color(0xff8a7efd),
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'yourusername',
                              hintStyle: TextStyle(
                                  color: Color(0xffc5d2e1),
                                  fontWeight: FontWeight.w200),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff8a7efd), width: 2),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              username = value;
                            },
                          ),
                          
                          const Text(
                            'Password',
                            style: TextStyle(
                                color: Color(0xff8fa1b6),
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            keyboardType: TextInputType.text,
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
                                    see1 = !see1;
                                  });
                                },
                                icon: Icon(see1
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                color: Color(0xff8fa1b6),
                                focusColor: Color(0xff8fa1b6),
                              ),
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
                                return 'This field is required';
                              } else if (value.length <= 8) {
                                return 'Your password must be at least than 8 characters';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'Confirm password',
                            style: TextStyle(
                                color: Color(0xff8fa1b6),
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            cursorColor: Color(0xff8a7efd),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'confirm yourpassword',
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
                                    see1 = !see1;
                                  });
                                },
                                icon: Icon(see1
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                color: Color(0xff8fa1b6),
                                focusColor: Color(0xff8fa1b6),
                              ),
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
                                return 'This field is required';
                              }
                              if (checkPassword1 != checkPassword2) {
                                return 'your password not match each other';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          GestureDetector(
                            onTap: () async {
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
                                    text: "Your registeration it successful",
                                    onConfirmBtnTap: () {
                                      prefs.remove('Success');
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
                                      prefs.remove('Success');
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                  );
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
                                  'REGISTER',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            )),
      ),
    );
  }
}

signup(username, email, password) async {
  var url = 'https://diown-app-server.herokuapp.com/auth/signup';
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
