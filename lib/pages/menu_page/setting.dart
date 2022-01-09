import 'package:diown/pages/mainpage/home.dart';
import 'package:diown/pages/menu_page/pinpasswordpage.dart';
import 'package:diown/pages/menu_page/privacy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      ),
      body: FutureBuilder(
        future: checkPin(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (hasPin != null) {
              return ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.lock),
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
                            'Plase enter passcode',
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
                            final inputController = InputController();
                            screenLock<void>(
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
                                inputController: inputController,
                                didConfirmed: (matchedText) {
                                  _setPasscode(matchedText);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Home()));
                                },
                                footer: TextButton(
                                  onPressed: () {
                                    // Release the confirmation state and return to the initial input state.
                                    inputController.unsetConfirmed();
                                  },
                                  child: const Text('Return enter mode.'),
                                ),
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
                    leading: const Icon(Icons.lock),
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
                            'Plase enter passcode',
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
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Home()));
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
                        final inputController = InputController();
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
                            inputController: inputController,
                            didConfirmed: (matchedText) {
                              _setPasscode(matchedText);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Home()));
                            },
                            footer: TextButton(
                              onPressed: () {
                                // Release the confirmation state and return to the initial input state.
                                inputController.unsetConfirmed();
                              },
                              child: const Text(' Return enter mode.'),
                            ),
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
