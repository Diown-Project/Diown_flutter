import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ContactScreen extends StatefulWidget {
  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  get textEditingController => null;
  final _formkey = GlobalKey<FormState>();
  var topic, detail;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Center(
                  child: Image(
                    image: AssetImage('images/logo_support.png'),
                    width: 200,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.topLeft,
                ),
                const SizedBox(
                  height: 0,
                ),
                Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: textEditingController,
                          maxLength: 48,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            filled: true,
                            fillColor: Color(0xfff1f3f4),
                            hintText: 'Topic',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onSaved: (value) {
                            setState(() {
                              topic = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'You must to fill this field.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          minLines: 7,
                          maxLines: null,
                          controller: textEditingController,
                          decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            hintText: 'Write details to us here.',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onSaved: (value) {
                            setState(() {
                              detail = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'You must to fill this field.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        GestureDetector(
                            onTap: () async {
                              setState(() {
                                if (_formkey.currentState!.validate()) {
                                  _formkey.currentState!.save();
                                }
                              });
                              if (topic == null || detail == null) {
                              } else {
                                CoolAlert.show(
                                    barrierDismissible: false,
                                    context: context,
                                    type: CoolAlertType.confirm,
                                    title: 'Are you sure?',
                                    text:
                                        'please select confirm button to send this report to our team.',
                                    onConfirmBtnTap: () async {
                                      CoolAlert.show(
                                          context: context,
                                          barrierDismissible: false,
                                          type: CoolAlertType.loading);
                                      var text = await sendToSupportTeam(
                                          topic, detail);
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.success,
                                          title: 'Thank you.',
                                          text: 'Thank you for your feedback.',
                                          onConfirmBtnTap: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          });
                                    });
                              }
                            },
                            child: Container(
                                    width: double.infinity,
                                    height: 40,
                                    decoration: const BoxDecoration(color: Color(0xff8b82ff), borderRadius: BorderRadius.all(Radius.circular(5))),
                                    child: const Center(
                                      child: Text('Send',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          )),
                                    )),
                                                ),
                      ],
                    )),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

sendToSupportTeam(topic, detail) async {
  var url = 'https://diown-app-server.herokuapp.com/support/add';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var id = prefs.getString('token');
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{
          'token': id!,
          'topic': topic,
          'detail': detail,
        },
      ));
  var result = jsonDecode(response.body);
  return result;
}
