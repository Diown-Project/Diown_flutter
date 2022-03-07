import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:diown/pages/auth/signin.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:menu_button/menu_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddActivity extends StatefulWidget {
  const AddActivity({Key? key}) : super(key: key);

  @override
  _AddActivityState createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {
  final _formkey = GlobalKey<FormState>();
  final textEditingController = TextEditingController();
  String? selectedValue;
  String? valueInput;
  addAct(token, selectedValue, valueInput) async {
    var url = 'http://10.0.2.2:3000/activity/add';
    final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
          <String, String>{
            'token': token,
            'activity_emoji': selectedValue,
            'activity_detail': valueInput
          },
        ));
    var result = jsonDecode(response.body);
    print(result);
    return result;
  }

  List<String> items = [
    '🐶',
    '🏫',
    '🧗🏻',
    '🎡',
    '🎸',
    '🏖',
    '🛹',
    '🏊🏻‍♀️',
    '🚲',
    '🦒',
    '🧶',
    '💃🏻',
    '👨🏻‍💻',
    '👨‍👩‍👧‍👦',
    '🌤',
    '🌡',
    '📊',
    '📝',
    '🛏',
    '🔭',
    '💸',
    '🛫',
    '🎰',
    '🎤',
    '🎨',
    '🎧',
    '🏃‍♀️',
    '🛍',
    '🧭',
    '🍿',
    '🍳',
    '📸',
    '🎂',
    '🕹',
    '🧁',
    '📚',
    '📺',
    '🍻',
    '🎆',
    '🧺',
    '💇🏻‍♀️',
    '💆🏻‍♂️',
    '💅🏻',
    '🩱',
    '🎄',
    '💐',
    '⛄️',
    '🏸',
    '🎣',
    '🎻',
    '🎳',
    '🛤',
    '🛣',
    '🔮',
    '🎁',
    '🧧',
    '🃏',
    '🛵',
    '🏇🏻',
    '⛹🏻‍♀️',
    '☔️',
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Add Activity'),
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
          ),
          body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 45,
                        ),
                        const Text('button activity preview.'),
                        OutlinedButton(
                            onPressed: () {},
                            child: selectedValue != null && valueInput != null
                                ? Text(
                                    '${selectedValue!} ${valueInput!}',
                                    style: const TextStyle(fontSize: 18),
                                  )
                                : const Text('')),
                        const SizedBox(
                          height: 55,
                        ),
                        TextFormField(
                          controller: textEditingController,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: const InputDecoration(
                            labelText: 'Name your activity',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                          ),
                          onChanged: (value) {
                            setState(() {
                              valueInput = value;
                            });
                          },
                          onSaved: (value) {
                            valueInput = value;
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
                        Container(
                          alignment: Alignment.topLeft,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              hint: Row(
                                children: const [
                                  Expanded(
                                    child: Text(
                                      'select',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              items: items
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 24,
                                            color: Colors.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                              value: selectedValue,
                              onChanged: (value) {
                                setState(() {
                                  selectedValue = value as String;
                                });
                              },
                              icon: const Icon(
                                Icons.arrow_drop_down,
                              ),
                              iconSize: 24,
                              iconEnabledColor: Colors.black,
                              iconDisabledColor: Colors.grey,
                              buttonHeight: 40,
                              buttonWidth: 90,
                              buttonPadding:
                                  const EdgeInsets.only(left: 20, right: 14),
                              buttonDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.black26,
                                ),
                              ),
                              buttonElevation: 2,
                              itemHeight: 40,
                              customItemsHeight: 90,
                              itemPadding:
                                  const EdgeInsets.only(left: 30, right: 14),
                              dropdownMaxHeight: 250,
                              dropdownPadding: null,
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              dropdownElevation: 8,
                              scrollbarRadius: const Radius.circular(40),
                              scrollbarThickness: 6,
                              scrollbarAlwaysShow: true,
                              offset: const Offset(0, 0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                if (_formkey.currentState!.validate()) {
                                  _formkey.currentState!.save();
                                }
                              });
                              if (valueInput == null || selectedValue == null) {
                                CoolAlert.show(
                                    barrierDismissible: false,
                                    context: context,
                                    type: CoolAlertType.error);
                              } else {
                                CoolAlert.show(
                                    barrierDismissible: false,
                                    context: context,
                                    type: CoolAlertType.confirm,
                                    onConfirmBtnTap: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      var token = prefs.getString('token');
                                      var result = await addAct(
                                          token, selectedValue, valueInput);
                                      if (result['message'] == 'success') {
                                        Navigator.pop(context);
                                        CoolAlert.show(
                                            barrierDismissible: false,
                                            context: context,
                                            type: CoolAlertType.success);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      } else {
                                        prefs.remove('token');
                                        prefs.remove('passcode');
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const SignIn()));
                                      }
                                    });
                              }
                            },
                            child: const Text(
                              'add',
                              style: TextStyle(fontSize: 18),
                            ),
                            style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all<Size>(
                                    const Size(304, 45)),
                                foregroundColor: MaterialStateProperty.all<Color>(
                                    Colors.black),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color.fromRGBO(229, 221, 255, 1)),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(80.0),
                                        side: const BorderSide(
                                            color:
                                                Color.fromRGBO(229, 221, 255, 1))))))
                      ],
                    ))),
          )),
    );
  }
}
