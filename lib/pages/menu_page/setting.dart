import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:diown/pages/mainpage/home.dart';
import 'package:diown/pages/menu_page/privacy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  dynamic hasPin;
  checkPin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    hasPin = prefs.getString('passcode');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text('Settings'),
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder(
        future: checkPin(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (hasPin != null) {
              return ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.change_circle_outlined),
                    title: const Text("Change pin password"),
                    trailing: const Icon(Icons.navigate_next_rounded),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      dynamic passcode = prefs.getString('passcode');
                      screenLock<void>(
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
                            textStyle:
                                InputButtonConfig.getDefaultTextStyle(context)
                                    .copyWith(
                              color: Colors.black,
                            ),
                            buttonStyle: OutlinedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                            ),
                          ),
                          didUnlocked: () {
                            // final inputController = InputController();
                            screenLock<void>(
                                title: const Text(
                                  'Please enter new passcode',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                confirmTitle: const Text(
                                  'Please enter new passcode again',
                                  style: TextStyle(color: Colors.black),
                                ),
                                context: context,
                                correctString: '',
                                confirmation: true,
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
                                  textStyle:
                                      InputButtonConfig.getDefaultTextStyle(
                                              context)
                                          .copyWith(
                                    color: Colors.black,
                                  ),
                                  buttonStyle: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.grey[300],
                                  ),
                                ),

                                // inputController: inputController,
                                didConfirmed: (matchedText) {
                                  _setPasscode(matchedText);
                                  Navigator.popAndPushNamed(context, Home.id);
                                },
                                cancelButton: const Icon(Icons.close,
                                    color: Colors.black),
                                deleteButton: const Icon(Icons.backspace,
                                    color: Colors.black));
                            // NextPage.show(context);
                          },
                          cancelButton:
                              const Icon(Icons.close, color: Colors.black),
                          deleteButton:
                              const Icon(Icons.backspace, color: Colors.black));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock_open_outlined),
                    title: const Text("Delete pin password"),
                    trailing: const Icon(Icons.navigate_next_rounded),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      dynamic passcode = prefs.getString('passcode');
                      screenLock<void>(
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
                            textStyle:
                                InputButtonConfig.getDefaultTextStyle(context)
                                    .copyWith(
                              color: Colors.black,
                            ),
                            buttonStyle: OutlinedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                            ),
                          ),
                          didUnlocked: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.remove('passcode');
                            print('Delete');
                            Navigator.popAndPushNamed(context, Home.id);
                          },
                          cancelButton:
                              const Icon(Icons.close, color: Colors.black),
                          deleteButton:
                              const Icon(Icons.backspace, color: Colors.black));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip),
                    title: const Text("Privacy policy"),
                    trailing: const Icon(Icons.navigate_next_rounded),
                    onTap: () {
                      Navigator.of(context).push(PageTransition(
                          child: const PrivacypolicyWidget(),
                          type: PageTransitionType.rightToLeft));
                    },
                  ),
                ],
              );
            } else {
              return ListView(
                children: [
                  ListTile(
                      leading: const Icon(Icons.lock),
                      title: const Text("Set pin password"),
                      trailing: const Icon(Icons.navigate_next_rounded),
                      onTap: () {
                        // final inputController = InputController();
                        screenLock<void>(
                            context: context,
                            correctString: '',
                            confirmation: true,
                            title: const Text(
                              'Please enter passcode',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            confirmTitle: const Text(
                              'Please enter confirm passcode',
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
                              textStyle:
                                  InputButtonConfig.getDefaultTextStyle(context)
                                      .copyWith(
                                color: Colors.black,
                              ),
                              buttonStyle: OutlinedButton.styleFrom(
                                backgroundColor: Colors.grey[300],
                              ),
                            ),
                            // inputController: inputController,
                            didConfirmed: (matchedText) async {
                              _setPasscode(matchedText);
                              var check = await checkAchievement(2);
                              if (check['message'] == 'success') {
                                AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.SUCCES,
                                        customHeader: Container(
                                          height: 100,
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image.asset(
                                                  'images/Make_A_Secret.png')),
                                        ),
                                        title: 'congratulations',
                                        body: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 0, 10, 10),
                                            child: Column(
                                              children: const [
                                                Text(
                                                  'congratulations',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    height: 1.5,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  'Congratulations to unlock this achievement (Make a secret).',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            )),
                                        btnOk: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.popAndPushNamed(
                                                  context, Home.id);
                                            },
                                            child: Text('ok')))
                                    .show();
                              } else {
                                Navigator.popAndPushNamed(context, Home.id);
                              }
                            },
                            cancelButton:
                                const Icon(Icons.close, color: Colors.black),
                            deleteButton: const Icon(Icons.backspace,
                                color: Colors.black));
                      }),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip),
                    title: const Text("Privacy policy"),
                    trailing: const Icon(Icons.navigate_next_rounded),
                    onTap: () {
                      Navigator.of(context).push(PageTransition(
                          child: const PrivacypolicyWidget(),
                          type: PageTransitionType.rightToLeft));
                    },
                  ),
                ],
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

Future<void> _setPasscode(String matchedText) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('passcode', matchedText);
  print(matchedText);
}

checkAchievement(index) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'http://10.0.2.2:3000/achievement/checkSuccess';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{'token': token, 'index': index},
      ));
  var result = jsonDecode(response.body);
  return result;
}
