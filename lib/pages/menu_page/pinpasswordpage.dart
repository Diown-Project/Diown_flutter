import 'package:diown/pages/mainpage/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pin extends StatefulWidget {
  const Pin({Key? key}) : super(key: key);

  @override
  _PinState createState() => _PinState();
}

class _PinState extends State<Pin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('screen lock'),
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // Define it to control the confirmation state with its own events.
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
                      textStyle: InputButtonConfig.getDefaultTextStyle(context)
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
                    cancelButton: const Icon(Icons.close, color: Colors.black),
                    deleteButton:
                        const Icon(Icons.backspace, color: Colors.black));
              },
              child: const Text('set pin password'),
            ),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                dynamic passcode = prefs.getString('passcode');
                screenLock<void>(
                    context: context,
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
                      textStyle: InputButtonConfig.getDefaultTextStyle(context)
                          .copyWith(
                        color: Colors.black,
                      ),
                      buttonStyle: OutlinedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                      ),
                    ),
                    correctString: passcode,
                    didUnlocked: () {
                      Navigator.popAndPushNamed(context, '/home');
                      // NextPage.show(context);
                    },
                    cancelButton: const Icon(Icons.close, color: Colors.black),
                    deleteButton:
                        const Icon(Icons.backspace, color: Colors.black));
              },
              child: const Text('Next page with unlock'),
            ),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
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
                      textStyle: InputButtonConfig.getDefaultTextStyle(context)
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
                      await prefs.clear();
                      print('Delete');
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Home()));
                    },
                    cancelButton: const Icon(Icons.close, color: Colors.black),
                    deleteButton:
                        const Icon(Icons.backspace, color: Colors.black));
              },
              child: const Text('Delete pin'),
            ),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
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
                      textStyle: InputButtonConfig.getDefaultTextStyle(context)
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
                            child: const Text('Return enter mode.'),
                          ),
                          cancelButton:
                              const Icon(Icons.close, color: Colors.black),
                          deleteButton:
                              const Icon(Icons.backspace, color: Colors.black));
                      // NextPage.show(context);
                    },
                    cancelButton: const Icon(Icons.close, color: Colors.black),
                    deleteButton:
                        const Icon(Icons.backspace, color: Colors.black));
              },
              child: const Text('Change pinpassword'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _setPasscode(String matchedText) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('passcode', matchedText);
  print(matchedText);
}
