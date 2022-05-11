import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:diown/pages/diary/activity.dart';

import 'package:diown/pages/diary/mood.dart';
import 'package:diown/pages/extraPage/apigcloud.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LocalDiary extends StatefulWidget {
  const LocalDiary({Key? key}) : super(key: key);
  static String id = 'LocalDiary';
  @override
  _LocalDiaryState createState() => _LocalDiaryState();
}

class _LocalDiaryState extends State<LocalDiary> {
  CloudApi? api;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isVisibleMood = !isVisibleMood;
    isVisibleActivity = !isVisibleActivity;

    rootBundle.loadString('assets/credentials.json').then((value) {
      api = CloudApi(value);
    });
  }

  final _formkey = GlobalKey<FormState>();
  final textEditingController = TextEditingController();
  bool isVisibleMood = true;
  bool isVisibleActivity = true;
  int numPic = 0;
  String? resultMood;
  String? resultAct;
  String? topic;
  String? write_detail;
  Iterable<File>? _image;
  Iterable<Uint8List>? _imageByte;
  List<Uint8List>? _imageByteList;
  Iterable<String>? _imageName;
  List<String>? _imageNameList;
  final ImagePicker imagePicker = ImagePicker();
  void selectImage() async {
    final List<XFile>? selected = await imagePicker.pickMultiImage();
    setState(() {
      _image = null;
      _imageByte = null;
      _imageName = null;
      if (selected != null) {
        _image = selected.map((e) {
          return File(e.path);
        });
        _imageByte = _image!.map((e) {
          return e.readAsBytesSync();
        });
        _imageName = _image!.map((e) {
          return e.path.split('/').last;
        });
        if (_imageByteList != null && _imageNameList != null) {
          _imageByteList?.addAll(_imageByte!.toList());
          _imageNameList?.addAll(_imageName!.toList());
          if (_imageNameList!.length > 5) {
            _imageByteList = _imageByteList!.sublist(0, 5);
            _imageNameList = _imageNameList!.sublist(0, 5);
          }
          numPic = _imageNameList!.length;
        } else {
          _imageByteList = _imageByte!.toList();
          _imageNameList = _imageName!.toList();
          if (_imageNameList!.length > 5) {
            _imageByteList = _imageByteList!.sublist(0, 5);
            _imageNameList = _imageNameList!.sublist(0, 5);
          }
          numPic = _imageNameList!.length;
        }
      } else {}
    });
  }

  void cameraImage() async {
    final XFile? selected =
        await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = null;
      _imageByte = null;
      _imageName = null;
      if (selected != null) {
        List<File> _image = [File(selected.path)];

        _imageByte = _image.map((e) {
          return e.readAsBytesSync();
        });
        _imageName = _image.map((e) {
          return e.path.split('/').last;
        });
        if (_imageByteList != null && _imageNameList != null) {
          _imageByteList?.addAll(_imageByte!.toList());
          _imageNameList?.addAll(_imageName!.toList());
          if (_imageNameList!.length > 5) {
            _imageByteList = _imageByteList!.sublist(0, 5);
            _imageNameList = _imageNameList!.sublist(0, 5);
          }
          numPic = _imageNameList!.length;
        } else {
          _imageByteList = _imageByte!.toList();
          _imageNameList = _imageName!.toList();
          if (_imageNameList!.length > 5) {
            _imageByteList = _imageByteList!.sublist(0, 5);
            _imageNameList = _imageNameList!.sublist(0, 5);
          }
          numPic = _imageNameList!.length;
        }
      } else {}
    });
  }

  _saveImage() async {
    final response = await api!.save(
        _imageNameList as List<String>, _imageByteList as List<Uint8List>);
    print(response);
  }

  // var d = '🏀asd';
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          title: const Text('New Diary'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 7, 12),
              child: OutlinedButton(
                  onPressed: () async {
                    CoolAlert.show(
                        barrierDismissible: false,
                        context: context,
                        type: CoolAlertType.confirm,
                        title: 'Please confirm',
                        text: 'If you want to save this diary.',
                        onConfirmBtnTap: () async {
                          CoolAlert.show(
                              barrierDismissible: false,
                              context: context,
                              type: CoolAlertType.loading);
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          var token = prefs.getString('token');
                          if (_imageByteList != null &&
                              _imageNameList != null &&
                              resultMood != null &&
                              _imageByteList!.isNotEmpty &&
                              _imageNameList!.isNotEmpty) {
                            await _saveImage();
                            var mood_emoji = resultMood!.substring(0, 2);
                            var mood_detail = resultMood!.substring(3);
                            var result = await addDiaryWithOutText(
                              token,
                              topic,
                              write_detail,
                              mood_emoji,
                              mood_detail,
                              _imageNameList,
                              resultAct,
                            );
                            print(result);
                            var check = await checkAchievement(3);
                            var checkImg = await checkAchievement(0);
                            var check7 = await checkAchievement4();
                            var check30 = await checkAchievement9();
                            if (check['message'] == 'success' &&
                                checkImg['message'] == 'success') {
                              AwesomeDialog(
                                      dismissOnTouchOutside: false,
                                      context: context,
                                      dialogType: DialogType.SUCCES,
                                      customHeader: Container(
                                        height: 100,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Image.asset(
                                                'images/NewbieWriter.png')),
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
                                                'Congratulations to unlock this achievement (Newbie Writer).',
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          )),
                                      btnOk: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            AwesomeDialog(
                                                    dismissOnTouchOutside:
                                                        false,
                                                    context: context,
                                                    dialogType:
                                                        DialogType.SUCCES,
                                                    customHeader: Container(
                                                      height: 100,
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          child: Image.asset(
                                                              'images/Picture_Memory.png')),
                                                    ),
                                                    title: 'congratulations',
                                                    body: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                15, 0, 10, 10),
                                                        child: Column(
                                                          children: const [
                                                            Text(
                                                              'congratulations',
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                height: 1.5,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                              'Congratulations to unlock this achievement (Picture Memory).',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ],
                                                        )),
                                                    btnOk: ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context, "yeah");
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text('ok')))
                                                .show();
                                          },
                                          child: const Text('ok')))
                                  .show();
                            } else if (checkImg['message'] == 'success' &&
                                check7['message'] == 'success') {
                              AwesomeDialog(
                                      dismissOnTouchOutside: false,
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
                                                'Congratulations to unlock this achievement (Picture Memory).',
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          )),
                                      btnOk: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            AwesomeDialog(
                                                    dismissOnTouchOutside:
                                                        false,
                                                    context: context,
                                                    dialogType:
                                                        DialogType.SUCCES,
                                                    customHeader: Container(
                                                      height: 100,
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          child: Image.asset(
                                                              'images/Diary_diary.png')),
                                                    ),
                                                    title: 'congratulations',
                                                    body: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                15, 0, 10, 10),
                                                        child: Column(
                                                          children: const [
                                                            Text(
                                                              'congratulations',
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                height: 1.5,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                              'Congratulations to unlock this achievement (Diary diary).',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ],
                                                        )),
                                                    btnOk: ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context, "yeah");
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            const Text('Ok')))
                                                .show();
                                          },
                                          child: Text('ok')))
                                  .show();
                            } else if (checkImg['message'] == 'success' &&
                                check30['message'] == 'success') {
                              AwesomeDialog(
                                      context: context,
                                      dismissOnTouchOutside: false,
                                      dialogType: DialogType.SUCCES,
                                      customHeader: Container(
                                        height: 100,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Image.asset(
                                                'images/Picture_Memory.png')),
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
                                                'Congratulations to unlock this achievement (Picture Memory).',
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          )),
                                      btnOk: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            AwesomeDialog(
                                                    context: context,
                                                    dismissOnTouchOutside:
                                                        false,
                                                    dialogType:
                                                        DialogType.SUCCES,
                                                    customHeader: Container(
                                                      height: 100,
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          child: Image.asset(
                                                              'images/Expert_writer.png')),
                                                    ),
                                                    title: 'congratulations',
                                                    body: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                15, 0, 10, 10),
                                                        child: Column(
                                                          children: const [
                                                            Text(
                                                              'congratulations',
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                                height: 1.5,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                            Text(
                                                              'Congratulations to unlock this achievement (Expert writer).',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ],
                                                        )),
                                                    btnOk: ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context, "yeah");
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            const Text('Ok')))
                                                .show();
                                          },
                                          child: const Text('Ok')))
                                  .show();
                            } else if (check7['message'] == 'success') {
                              AwesomeDialog(
                                      context: context,
                                      dismissOnTouchOutside: false,
                                      dialogType: DialogType.SUCCES,
                                      customHeader: Container(
                                        height: 100,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Image.asset(
                                                'images/Diary_diary.png')),
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
                                                'Congratulations to unlock this achievement (Diary diary).',
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          )),
                                      btnOk: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context, "yeah");
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Ok')))
                                  .show();
                            } else if (checkImg['message'] == 'success') {
                              AwesomeDialog(
                                      context: context,
                                      dismissOnTouchOutside: false,
                                      dialogType: DialogType.SUCCES,
                                      customHeader: Container(
                                        height: 100,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Image.asset(
                                                'images/Picture_Memory.png')),
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
                                                'Congratulations to unlock this achievement (Picture Memory).',
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          )),
                                      btnOk: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context, "yeah");
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Ok')))
                                  .show();
                            } else if (check30['message'] == 'success') {
                              AwesomeDialog(
                                      context: context,
                                      dismissOnTouchOutside: false,
                                      dialogType: DialogType.SUCCES,
                                      customHeader: Container(
                                        height: 100,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Image.asset(
                                                'images/Expert_writer.png')),
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
                                                'Congratulations to unlock this achievement (Expert writer).',
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          )),
                                      btnOk: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context, "yeah");
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Ok')))
                                  .show();
                            } else {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context, "yeah");
                              Navigator.pop(context);
                            }
                          } else if (resultMood != null) {
                            var mood_emoji = resultMood!.substring(0, 2);
                            var mood_detail = resultMood!.substring(3);
                            var result = await addDiaryWithOutText(
                              token,
                              topic,
                              write_detail,
                              mood_emoji,
                              mood_detail,
                              _imageNameList,
                              resultAct,
                            );
                            print(result);
                            var check = await checkAchievement(3);
                            var check7 = await checkAchievement4();
                            var check30 = await checkAchievement9();
                            if (check['message'] == 'success') {
                              AwesomeDialog(
                                      dismissOnTouchOutside: false,
                                      context: context,
                                      dialogType: DialogType.SUCCES,
                                      customHeader: Container(
                                        height: 100,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Image.asset(
                                                'images/NewbieWriter.png')),
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
                                                'Congratulations to unlock this achievement (Newbie Writer).',
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          )),
                                      btnOk: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context, "yeah");
                                            Navigator.pop(context);
                                          },
                                          child: Text('ok')))
                                  .show();
                            } else if (check7['message'] == 'success') {
                              print('hello');
                              AwesomeDialog(
                                      context: context,
                                      dismissOnTouchOutside: false,
                                      dialogType: DialogType.SUCCES,
                                      customHeader: Container(
                                        height: 100,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Image.asset(
                                                'images/Diary_diary.png')),
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
                                                'Congratulations to unlock this achievement (Diary diary).',
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          )),
                                      btnOk: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context, "yeah");
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Ok')))
                                  .show();
                            } else if (check30['message'] == 'success') {
                              AwesomeDialog(
                                      context: context,
                                      dismissOnTouchOutside: false,
                                      dialogType: DialogType.SUCCES,
                                      customHeader: Container(
                                        height: 100,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Image.asset(
                                                'images/Expert_writer.png')),
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
                                                'Congratulations to unlock this achievement (Expert writer).',
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          )),
                                      btnOk: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context, "yeah");
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Ok')))
                                  .show();
                            } else {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context, "yeah");
                              Navigator.pop(context);
                            }
                          } else {
                            CoolAlert.show(
                                barrierDismissible: false,
                                context: context,
                                type: CoolAlertType.error,
                                title: 'error Alert!',
                                text: 'You must to fill at less mood.',
                                onConfirmBtnTap: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                });
                          }
                        });
                  },
                  child:
                      const Text('save', style: TextStyle(color: Colors.white)),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(65, 30),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    backgroundColor: Color(0xff8a7efd),
                    side: BorderSide.none,
                  )),
            )
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                              alignment: Alignment.bottomLeft,
                              child: Text(now.toString().substring(0, 10),
                                  style: const TextStyle(
                                      fontSize: 15, color: Color(0xffafacac)))),
                        ],
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      _imageByteList == null
                          ? Container()
                          : _imageByteList?.length == 0
                              ? Container()
                              : Container(
                                  height: 300,
                                  child: Swiper(
                                    loop: false,
                                    itemHeight: 300,
                                    pagination: const SwiperPagination(
                                        margin: EdgeInsets.all(15),
                                        builder: SwiperPagination.dots),
                                    layout: SwiperLayout.DEFAULT,
                                    itemCount: _imageByteList!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Stack(children: [
                                        Center(
                                            child: Image.memory(
                                          _imageByteList![index],
                                        )),
                                        Positioned(
                                          bottom: 5,
                                          right: 5,
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _imageByteList
                                                      ?.removeAt(index);
                                                  _imageNameList
                                                      ?.removeAt(index);
                                                  numPic = numPic - 1;
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.remove_circle_outlined,
                                                color: Colors.red,
                                              )),
                                        )
                                      ]);
                                    },
                                  ),
                                ),
                      const SizedBox(
                        height: 1,
                      ),
                      numPic != 0
                          ? Container(
                              alignment: Alignment.topRight,
                              child: Text('$numPic/5'),
                            )
                          : Container(),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Visibility(
                              visible: isVisibleMood,
                              child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Color(0xfff1f3f4),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0)),
                                    side: BorderSide.none,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isVisibleMood = false;
                                      resultMood = null;
                                    });
                                  },
                                  child: resultMood != null
                                      ? Text(
                                          resultMood!,
                                          style: const TextStyle(
                                              color: Colors.black),
                                        )
                                      : const Text('🤔 Select mood')),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Flexible(
                              child: Visibility(
                            visible: isVisibleActivity,
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Color(0xfff1f3f4),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(50.0)),
                                  side: BorderSide.none,
                                ),
                                onPressed: () {
                                  setState(() {
                                    resultAct = null;
                                    isVisibleActivity = false;
                                  });
                                },
                                child: resultAct != null
                                    ? Text(
                                        resultAct!,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      )
                                    : const Text('☕ Select Activity')),
                          ))
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              TextFormField(
                                maxLength: 30,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 10.0),
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
                                onChanged: (value) {
                                  setState(() {
                                    topic = value;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              LayoutBuilder(builder: (context, constraints) {
                                return SizedBox(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 10.0, 20.0, 10.0),
                                      hintText: 'Tell your story here',
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    maxLines: null,
                                    minLines: 12,
                                    onChanged: (value) {
                                      setState(() {
                                        write_detail = value;
                                      });
                                    },
                                  ),
                                );
                              }),
                            ],
                          )),
                      SizedBox(height: 50)
                    ],
                  ),
                ),
              ),
              _buildBottomBar()
            ],
          ),
        ),
      ),
    );
  }

  _buildBottomBar() {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Positioned(
      bottom: 0,
      left: 0,
      child: isKeyboard
          ? Column(
              children: [
                const Divider(
                  thickness: 5,
                  color: Colors.black,
                ),
                Container(
                  height: 60,
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                useRootNavigator: false,
                                builder: (context) {
                                  return const MoodSelected();
                                }).whenComplete(() {
                              setState(() {
                                if (MoodSelected.resultMood == '') {
                                } else {
                                  isVisibleMood = true;
                                  resultMood = MoodSelected.resultMood;
                                  MoodSelected.resultMood = '';
                                }
                              });
                            });
                          },
                          child: Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                  color: Color(0xff8a7efd),
                                  shape: BoxShape.circle),
                              child: const Icon(
                                MdiIcons.emoticonHappyOutline,
                                color: Colors.white,
                                size: 30,
                              )),
                        ),
                        // const SizedBox(width: 50),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) {
                                  return const ActivityPage();
                                }).whenComplete(() {
                              setState(() {
                                if (ActivityPage.resultAct == '') {
                                } else {
                                  isVisibleActivity = true;
                                  resultAct = ActivityPage.resultAct;
                                  ActivityPage.resultAct = '';
                                }
                              });
                            });
                          },
                          child: Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                  color: Color(0xff8a7efd),
                                  shape: BoxShape.circle),
                              child: const Icon(
                                MdiIcons.run,
                                color: Colors.white,
                                size: 30,
                              )),
                        ),
                        // const SizedBox(width: 50),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                ),
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        color: Colors.transparent,
                                        height: 220,
                                        child: ListView(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              child: ListTile(
                                                  title: const Text(
                                                    'Select to add images.',
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  trailing: IconButton(
                                                    icon: const Icon(
                                                      Icons.close_outlined,
                                                      color: Colors.black,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  )),
                                            ),
                                            const Divider(
                                              thickness: 0.8,
                                            ),
                                            ListTile(
                                              leading: Container(
                                                height: 40,
                                                width: 40,
                                                decoration: const BoxDecoration(
                                                    color: Color(0xff8a7efd),
                                                    shape: BoxShape.circle),
                                                child: const Icon(
                                                  Icons.photo,
                                                  color: Colors.white,
                                                  size: 22,
                                                ),
                                              ),
                                              title: const Text(
                                                  'Pick images in gallery.'),
                                              trailing: const Icon(
                                                  Icons.navigate_next_rounded),
                                              onTap: () {
                                                selectImage();
                                                Navigator.pop(context);
                                              },
                                            ),
                                            ListTile(
                                              leading: Container(
                                                height: 40,
                                                width: 40,
                                                decoration: const BoxDecoration(
                                                    color: Color(0xff8a7efd),
                                                    shape: BoxShape.circle),
                                                child: const Icon(
                                                  Icons.camera_alt,
                                                  color: Colors.white,
                                                  size: 22,
                                                ),
                                              ),
                                              title:
                                                  const Text('Take a picture.'),
                                              trailing: const Icon(
                                                  Icons.navigate_next_rounded),
                                              onTap: () {
                                                cameraImage();
                                                Navigator.pop(context);
                                              },
                                            )
                                          ],
                                        )),
                                  );
                                });
                          },
                          child: Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                  color: Color(0xff8a7efd),
                                  shape: BoxShape.circle),
                              child: const Icon(
                                MdiIcons.imageOutline,
                                color: Colors.white,
                                size: 30,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Container(
              height: 180,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        spreadRadius: -7,
                        blurRadius: 20,
                        offset: Offset(0, 5)),
                  ]),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(40.0, 20.0, 0.0, 10.0),
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  useRootNavigator: false,
                                  builder: (context) {
                                    return const MoodSelected();
                                  }).whenComplete(() {
                                setState(() {
                                  if (MoodSelected.resultMood == '') {
                                  } else {
                                    isVisibleMood = true;
                                    resultMood = MoodSelected.resultMood;
                                    MoodSelected.resultMood = '';
                                  }
                                });
                              });
                            },
                            child: Row(
                              children: [
                                Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                        color: Color(0xff8a7efd),
                                        shape: BoxShape.circle),
                                    child: const Icon(
                                      MdiIcons.emoticonHappyOutline,
                                      color: Colors.white,
                                      size: 30,
                                    )),
                                SizedBox(width: 20),
                                const Text('feeling',
                                    style: TextStyle(fontSize: 20))
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(40.0, 0.0, 0.0, 10.0),
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) {
                                    return const ActivityPage();
                                  }).whenComplete(() {
                                setState(() {
                                  if (ActivityPage.resultAct == '') {
                                  } else {
                                    isVisibleActivity = true;
                                    resultAct = ActivityPage.resultAct;
                                    ActivityPage.resultAct = '';
                                  }
                                });
                              });
                            },
                            child: Row(
                              children: [
                                Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                        color: Color(0xff8a7efd),
                                        shape: BoxShape.circle),
                                    child: const Icon(
                                      MdiIcons.run,
                                      color: Colors.white,
                                      size: 30,
                                    )),
                                SizedBox(width: 20),
                                const Text('activities',
                                    style: TextStyle(fontSize: 20))
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(40.0, 0.0, 0.0, 0.0),
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15)),
                                  ),
                                  context: context,
                                  builder: (context) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                          color: Colors.transparent,
                                          height: 200,
                                          child: ListView(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ListTile(
                                                    title: const Text(
                                                      'Select to add images.',
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                    trailing: IconButton(
                                                      icon: const Icon(Icons
                                                          .highlight_remove_rounded),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    )),
                                              ),
                                              const Divider(
                                                thickness: 0.8,
                                              ),
                                              ListTile(
                                                leading: const Icon(
                                                  Icons.photo,
                                                  color: Color(0xff8a7efd),
                                                ),
                                                title: const Text(
                                                    'Pick images in gallery.'),
                                                trailing: const Icon(Icons
                                                    .navigate_next_rounded),
                                                onTap: () {
                                                  selectImage();
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              ListTile(
                                                leading: const Icon(
                                                  Icons.camera_alt,
                                                  color: Color(0xff8a7efd),
                                                ),
                                                title: const Text(
                                                    'Take a picture.'),
                                                trailing: const Icon(Icons
                                                    .navigate_next_rounded),
                                                onTap: () {
                                                  cameraImage();
                                                  Navigator.pop(context);
                                                },
                                              )
                                            ],
                                          )),
                                    );
                                  });
                            },
                            child: Row(
                              children: [
                                Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                        color: Color(0xff8a7efd),
                                        shape: BoxShape.circle),
                                    child: const Icon(
                                      MdiIcons.imageOutline,
                                      color: Colors.white,
                                      size: 30,
                                    )),
                                SizedBox(width: 20),
                                const Text('picture',
                                    style: TextStyle(fontSize: 20))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

addDiaryWithOutText(token, topic, write_detail, mood_emoji, mood_detail,
    _imageNameList, resultAct) async {
  var url = 'https://diown-app-server.herokuapp.com/localDiary/saveDiary';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{
          'token': token,
          'mood_emoji': mood_emoji,
          'mood_detail': mood_detail,
          'activity': resultAct,
          'imageLocation': _imageNameList,
          'topic': topic,
          'detail': write_detail,
          'favorite': false,
        },
      ));
  var result = jsonDecode(response.body);
  return result;
}

checkAchievement(index) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'https://diown-app-server.herokuapp.com/achievement/checkSuccess';
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

checkAchievement4() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'https://diown-app-server.herokuapp.com/achievement/checkSuccess4';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{'token': token, 'index': 4},
      ));
  var result = jsonDecode(response.body);
  return result;
}

checkAchievement9() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'https://diown-app-server.herokuapp.com/achievement/checkSuccess9';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{'token': token, 'index': 9},
      ));
  var result = jsonDecode(response.body);
  return result;
}
