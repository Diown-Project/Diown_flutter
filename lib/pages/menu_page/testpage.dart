import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class TestPage extends StatefulWidget {
  TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: FlatButton(
            onPressed: () {
              AwesomeDialog(
                      context: context,
                      dialogType: DialogType.SUCCES,
                      customHeader: Container(
                        height: 100,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset('images/profile.png')),
                      ),
                      title: 'congratulations',
                      body: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 10, 10),
                          child: Column(
                            children: [
                              const Text(
                                'congratulations',
                                style: TextStyle(
                                  fontSize: 20,
                                  height: 1.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'asdqqq qw fqwg qg qwg qwgqwgq wgqgwqwgqwgqgrrhw qqgwe qeqee',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )),
                      btnOk: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.SUCCES,
                                    customHeader: Container(
                                      height: 100,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.asset(
                                              'images/Picture_Memory.png')),
                                    ),
                                    body: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 0, 10, 10),
                                        child: Column(
                                          children: [
                                            const Text(
                                              'congratulations',
                                              style: TextStyle(
                                                fontSize: 20,
                                                height: 1.5,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            const Text(
                                              'asdqqq qw fqwg qg qwg qwgqwgq wgqgwqwgqwgqgrrhw qqgwe qeqee',
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        )),
                                    btnOk: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('qweasd')))
                                .show();
                          },
                          child: const Text('asd')))
                  .show();
            },
            child: Text('data')),
      ),
    );
  }
}
