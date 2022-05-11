import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:diown/pages/auth/signin.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:menu_button/menu_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_select/awesome_select.dart';

class AddActivity extends StatefulWidget {
  const AddActivity({Key? key}) : super(key: key);

  @override
  _AddActivityState createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {
  final _formkey = GlobalKey<FormState>();
  final textEditingController = TextEditingController();
  String? selectedValue;
  String? _category;
  String? valueInput;
  addAct(token, selectedValue, valueInput) async {
    var url = 'https://diown-app-server.herokuapp.com/activity/add';
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

  List<S2Choice<String?>> categories = [
    S2Choice<String?>(value: '🐶', title: '🐶' ),
    S2Choice<String?>(value: '🏫', title: '🏫' ),
    S2Choice<String?>(value: '🧗🏻', title: '🧗🏻' ),
    S2Choice<String?>(value: '🎡', title: '🎡' ),
    S2Choice<String?>(value: '🎸', title: '🎸' ),
    S2Choice<String?>(value: '🏖', title: '🏖' ),
    S2Choice<String?>(value: '🛹', title: '🛹' ),
    S2Choice<String?>(value: '🏊🏻‍♀️', title: '🏊🏻‍♀️' ),
    S2Choice<String?>(value: '🚲', title: '🚲' ),
    S2Choice<String?>(value: '🦒', title: '🦒' ),
    S2Choice<String?>(value: '🧶', title: '🧶' ),
    S2Choice<String?>(value: '💃🏻', title: '💃🏻' ),
    S2Choice<String?>(value: '👨🏻‍💻', title: '👨🏻‍💻' ), 
    S2Choice<String?>(value: '👨‍👩‍👧‍👦', title: '👨‍👩‍👧‍👦' ),
    S2Choice<String?>(value: '🌤', title: '🌤' ),
    S2Choice<String?>(value: '🌡', title: '🌡' ),
    S2Choice<String?>(value: '📊', title: '📊' ),
    S2Choice<String?>(value: '📝', title: '📝' ),
    S2Choice<String?>(value: '🛏', title: '🛏' ),
    S2Choice<String?>(value: '🔭', title: '🔭' ),
    S2Choice<String?>(value: '💸', title: '💸' ),
    S2Choice<String?>(value: '🛫', title: '🛫' ),
    S2Choice<String?>(value: '🎰', title: '🎰' ),
    S2Choice<String?>(value: '🎤', title: '🎤' ),
    S2Choice<String?>(value: '🎨', title: '🎨' ),
    S2Choice<String?>(value: '🎧', title: '🎧' ),
    S2Choice<String?>(value: '🏃‍♀️', title: '🏃‍♀️' ),
    S2Choice<String?>(value: '🛍', title: '🛍' ),
    S2Choice<String?>(value: '🧭', title: '🧭' ),
    S2Choice<String?>(value: '🍿', title: '🍿' ),
    S2Choice<String?>(value: '🍳', title: '🍳' ),
    S2Choice<String?>(value: '📸', title: '📸' ),
    S2Choice<String?>(value: '🎂', title: '🎂' ),
    S2Choice<String?>(value: '🕹', title: '🕹' ),
    S2Choice<String?>(value: '🧁', title: '🧁' ),
    S2Choice<String?>(value: '📚', title: '📚' ),
    S2Choice<String?>(value: '📺', title: '📺' ),
    S2Choice<String?>(value: '🍻', title: '🍻' ),
    S2Choice<String?>(value: '🎆', title: '🎆' ),
    S2Choice<String?>(value: '🧺', title: '🧺' ),
    S2Choice<String?>(value: '💇🏻‍♀️', title: '💇🏻‍♀️' ),
    S2Choice<String?>(value: '💆🏻‍♂️', title: '💆🏻‍♂️' ),
    S2Choice<String?>(value: '💅🏻', title: '💅🏻' ),
    S2Choice<String?>(value: '🩱', title: '🩱' ),
    S2Choice<String?>(value: '🎄', title: '🎄' ),
    S2Choice<String?>(value: '💐', title: '💐' ),
    S2Choice<String?>(value: '⛄️', title: '⛄️' ),
    S2Choice<String?>(value: '🏸', title: '🏸' ),
    S2Choice<String?>(value: '🎣', title: '🎣' ),
    S2Choice<String?>(value: '🎻', title: '🎻' ),
    S2Choice<String?>(value: '🎳', title: '🎳' ),
    S2Choice<String?>(value: '🛤', title: '🛤' ),
    S2Choice<String?>(value: '🛣', title: '🛣' ),
    S2Choice<String?>(value: '🔮', title: '🔮' ),
    S2Choice<String?>(value: '🎁', title: '🎁' ),
    S2Choice<String?>(value: '🧧', title: '🧧' ),
    S2Choice<String?>(value: '🃏', title: '🃏' ),
    S2Choice<String?>(value: '🛵', title: '🛵' ),
    S2Choice<String?>(value: '🏇🏻', title: '🏇🏻' ),
    S2Choice<String?>(value: '⛹🏻‍♀️', title: '⛹🏻‍♀️' ),
    S2Choice<String?>(value: '☔️', title: '☔️' ),
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
            leading: IconButton(
              icon:
                  const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
                child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(color: Color(0xfff1f3f4), borderRadius: BorderRadius.all(Radius.circular(5))),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                const Text(
                                  'Preview : ',
                                  style: TextStyle(
                                    fontSize: 20
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  child: selectedValue != null && valueInput != null
                                      ? Text(
                                          '${selectedValue!} ${valueInput!}',
                                          style: const TextStyle(fontSize: 18),
                                        )
                                      : const Center(
                                        child: Text(
                                          'select icon and name',
                                          style: TextStyle(
                                            color: Colors.black54
                                          ),
                                        ),
                                      ),
                                )
                                // OutlinedButton(
                                //   onPressed: () {},
                                //   child: selectedValue != null && valueInput != null
                                //       ? Text(
                                //           '${selectedValue!} ${valueInput!}',
                                //           style: const TextStyle(fontSize: 18),
                                //         )
                                //       : const Text(''),
                                //   style: ButtonStyle(
                                //     foregroundColor:
                                //         MaterialStateProperty.all<Color>(Colors.white),
                                //     backgroundColor: MaterialStateProperty.all<Color>(
                                //         const Color(0xfff1f3f4)),
                                //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                //         RoundedRectangleBorder(
                                //             borderRadius: BorderRadius.circular(5.0),
                                //             side: const BorderSide(
                                //                 color: Color(0xfff1f3f4))))),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(color: Color(0xfff1f3f4), borderRadius: BorderRadius.all(Radius.circular(5))),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              children: [
                                // Container(
                                //   alignment: Alignment.topLeft,
                                //   child: DropdownButtonHideUnderline(
                                //     child: DropdownButton2(
                                //       isExpanded: true,
                                //       hint: Row(
                                //         children: const [
                                //           Expanded(
                                //             child: Text(
                                //               'select',
                                //               style: TextStyle(
                                //                 fontSize: 14,
                                //                 fontWeight: FontWeight.bold,
                                //                 color: Colors.black,
                                //               ),
                                //               overflow: TextOverflow.ellipsis,
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //       items: items
                                //           .map((item) => DropdownMenuItem<String>(
                                //                 value: item,
                                //                 child: Text(
                                //                   item,
                                //                   textAlign: TextAlign.center,
                                //                   style: const TextStyle(
                                //                     fontSize: 24,
                                //                     color: Colors.white,
                                //                   ),
                                //                   overflow: TextOverflow.ellipsis,
                                //                 ),
                                //               ))
                                //           .toList(),
                                //       value: selectedValue,
                                //       onChanged: (value) {
                                //         setState(() {
                                //           selectedValue = value as String;
                                //         });
                                //       },
                                //       icon: const Icon(
                                //         Icons.arrow_drop_down,
                                //       ),
                                //       iconSize: 24,
                                //       iconEnabledColor: Colors.black,
                                //       iconDisabledColor: Colors.grey,
                                //       buttonHeight: 40,
                                //       buttonWidth: 90,
                                //       buttonPadding:
                                //           const EdgeInsets.only(left: 20, right: 14),
                                //       buttonDecoration: BoxDecoration(
                                //         borderRadius: BorderRadius.circular(14),
                                //         border: Border.all(
                                //           color: Colors.black26,
                                //         ),
                                //       ),
                                //       buttonElevation: 2,
                                //       itemHeight: 40,
                                //       customItemsHeight: 90,
                                //       itemPadding:
                                //           const EdgeInsets.only(left: 30, right: 14),
                                //       dropdownMaxHeight: 250,
                                //       dropdownPadding: null,
                                //       dropdownDecoration: BoxDecoration(
                                //         borderRadius: BorderRadius.circular(14),
                                //       ),
                                //       dropdownElevation: 8,
                                //       scrollbarRadius: const Radius.circular(40),
                                //       scrollbarThickness: 6,
                                //       scrollbarAlwaysShow: true,
                                //       offset: const Offset(0, 0),
                                //     ),
                                //   ),
                                // ),
                                SmartSelect<String?>.single(
                                  title: 'Icon',
                                  selectedValue: selectedValue,
                                  choiceItems: categories,
                                  modalConfirm: true,                         
                                  modalType: S2ModalType.bottomSheet,
                                  modalConfig: const S2ModalConfig(
                                    useConfirm: true,
                                    title: 'Select icon',
                                    style: S2ModalStyle(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15.0),
                                          topRight: Radius.circular(15.0),
                                        ),
                                      ),
                                      backgroundColor: Color(0xfff5f5f5)
                                    ),
                                    headerStyle: S2ModalHeaderStyle(
                                      useLeading: true,
                                      elevation: 0,
                                      iconTheme: IconThemeData(color: Colors.black),
                                      actionsIconTheme: IconThemeData(color: Colors.black),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15.0),
                                          topRight: Radius.circular(15.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  choiceType: S2ChoiceType.chips,
                                  choiceStyle: const S2ChoiceStyle(
                                    outlined: false, 
                                    showCheckmark: true,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20.0))
                                    )    
                                  ),
                                  choiceActiveStyle: S2ChoiceStyle(
                                    color: Color(0xff8b82ff),
                                  ),
                                  onChange: (selected) => setState(() {
                                    selectedValue = selected.value as String;
                                    print(selected);
                                    print(selected.value);
                                  }),
                                  tileBuilder: (context, state) => S2Tile.fromState(
                                    state,
                                    isTwoLine: false,

                                    
                                    // leading: Container(
                                    //   width: 40,
                                    //   alignment: Alignment.center,
                                    //   child: const Icon(Icons.label_outline),
                                    // ),
                                  ),
                                  modalConfirmBuilder: (context, state) {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        child: ElevatedButton(
                                          child: const Text('Done'),
                                          style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all<Color>(Colors.white),
                                            backgroundColor: MaterialStateProperty.all<Color>(
                                                const Color(0xff8a7efd)),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(5.0),
                                                    side: const BorderSide(
                                                        color: Color(0xff8a7efd))))),
                                          onPressed: () => state.closeModal(confirmed: true),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                TextFormField(
                                  controller: textEditingController,
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: const InputDecoration(                           
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Name your activity',
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
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
                                  height: 35,
                                ),
                                // ElevatedButton(
                                //     onPressed: () async {
                                //       setState(() {
                                //         if (_formkey.currentState!.validate()) {
                                //           _formkey.currentState!.save();
                                //         }
                                //       });
                                //       if (valueInput == null || selectedValue == null) {
                                //         CoolAlert.show(
                                //             barrierDismissible: false,
                                //             context: context,
                                //             type: CoolAlertType.error);
                                //       } else {
                                //         CoolAlert.show(
                                //             barrierDismissible: false,
                                //             context: context,
                                //             type: CoolAlertType.confirm,
                                //             onConfirmBtnTap: () async {
                                //               SharedPreferences prefs =
                                //                   await SharedPreferences.getInstance();
                                //               var token = prefs.getString('token');
                                //               var result = await addAct(
                                //                   token, selectedValue, valueInput);
                                //               if (result['message'] == 'success') {
                                //                 Navigator.pop(context);
                                //                 CoolAlert.show(
                                //                     barrierDismissible: false,
                                //                     context: context,
                                //                     type: CoolAlertType.success);
                                //                 Navigator.pop(context);
                                //                 Navigator.pop(context);
                                //                 Navigator.pop(context);
                                //               } else {
                                //                 prefs.remove('token');
                                //                 prefs.remove('passcode');
                                //                 Navigator.pushReplacement(
                                //                     context,
                                //                     MaterialPageRoute(
                                //                         builder: (context) =>
                                //                             const SignIn()));
                                //               }
                                //             });
                                //       }
                                //     },
                                //     child: const Text(
                                //       'add',
                                //       style: TextStyle(fontSize: 18),
                                //     ),
                                //     style: ButtonStyle(
                                //         minimumSize: MaterialStateProperty.all<Size>(
                                //             const Size(304, 45)),
                                //         foregroundColor: MaterialStateProperty.all<Color>(
                                //             Colors.black),
                                //         backgroundColor:
                                //             MaterialStateProperty.all<Color>(
                                //                 const Color.fromRGBO(229, 221, 255, 1)),
                                //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                //             RoundedRectangleBorder(
                                //                 borderRadius:
                                //                     BorderRadius.circular(80.0),
                                //                 side: const BorderSide(
                                //                     color:
                                //                         Color.fromRGBO(229, 221, 255, 1)))))),
                                GestureDetector(
                                  onTap: () async {
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
                                  child: Container(
                                    width: double.infinity,
                                    height: 40,
                                    decoration: const BoxDecoration(color: Color(0xff8b82ff), borderRadius: BorderRadius.all(Radius.circular(5))),
                                    child: const Center(
                                      child: Text('Add Activity',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          )),
                                    )),
                                ),   
                                const SizedBox(height: 10)                      
                              ],
                            ),
                          ),
                        ),
                      ],
                    ))),
          )),
    );
  }
}
