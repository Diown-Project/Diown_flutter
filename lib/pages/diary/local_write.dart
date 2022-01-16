import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:diown/pages/diary/activity.dart';
import 'package:diown/pages/diary/mood.dart';
import 'package:diown/pages/extraPage/apigcloud.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LocalDiary extends StatefulWidget {
  const LocalDiary({Key? key}) : super(key: key);

  @override
  _LocalDiaryState createState() => _LocalDiaryState();
}

class _LocalDiaryState extends State<LocalDiary> {
  CloudApi? api;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rootBundle.loadString('assets/credentials.json').then((value) {
      api = CloudApi(value);
    });
  }

  final _formkey = GlobalKey<FormState>();
  final textEditingController = TextEditingController();
  String? resultMood;
  String? resultAct;
  String? topic;
  String? write_detail;
  Iterable<File>? _image;
  Iterable<Uint8List>? _imageByte;
  var _imageByteList;
  Iterable<String>? _imageName;
  var _imageNameList;
  final ImagePicker imagePicker = ImagePicker();
  void selectImage() async {
    final List<XFile>? selected = await imagePicker.pickMultiImage();
    setState(() {
      _imageByteList = null;
      _image = null;
      _imageByte = null;
      _imageName = null;
      _imageNameList = null;
      if (selected != null) {
        _image = selected.map((e) {
          return File(e.path);
        });
        _imageByte = _image!.map((e) {
          return e.readAsBytesSync();
        });
        _imageByteList = _imageByte!.toList();
        _imageName = _image!.map((e) {
          return e.path.split('/').last;
        });
        _imageNameList = _imageName!.toList();
      } else {}
    });
  }

  _saveImage() async {
    final response = await api!.save(_imageNameList!, _imageByteList!);
    print(response);
  }

  // var d = '🏀asd';
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text('New Diary'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                    alignment: Alignment.topLeft,
                    child: Text(now.toString().substring(0, 10),
                        style: const TextStyle(
                          fontSize: 20,
                        ))),
                const Spacer(),
                OutlinedButton(
                  onPressed: () async {
                    CoolAlert.show(
                        context: context,
                        type: CoolAlertType.confirm,
                        onConfirmBtnTap: () async {
                          CoolAlert.show(
                              context: context, type: CoolAlertType.loading);
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          var token = prefs.getString('token');
                          if (_imageByteList != null &&
                              _imageNameList != null &&
                              resultMood != null) {
                            await _saveImage();
                            var mood_emoji = resultMood!.substring(0, 2);
                            var mood_detail = resultMood!.substring(3);
                            await addDiaryWithOutText(
                                token,
                                topic,
                                write_detail,
                                mood_emoji,
                                mood_detail,
                                _imageNameList,
                                resultAct,
                                now);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          } else if (resultMood != null) {
                            var mood_emoji = resultMood!.substring(0, 2);
                            var mood_detail = resultMood!.substring(3);
                            await addDiaryWithOutText(
                                token,
                                topic,
                                write_detail,
                                mood_emoji,
                                mood_detail,
                                _imageNameList,
                                resultAct,
                                now);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          } else {
                            CoolAlert.show(
                                context: context,
                                type: CoolAlertType.error,
                                onConfirmBtnTap: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                });
                          }
                        });
                  },
                  child: const Text('save'),
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromRGBO(148, 92, 254, 1)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0),
                              side: const BorderSide(
                                  color: Color.fromRGBO(148, 92, 254, 1))))),
                )
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            _imageByteList == null
                ? Container()
                : CarouselSlider.builder(
                    itemCount: _imageByteList.length,
                    itemBuilder: (context, index, realIndex) {
                      return Image.memory(_imageByteList[index]);
                    },
                    options: CarouselOptions(
                        height: 200,
                        enableInfiniteScroll: false,
                        enlargeCenterPage: true)),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Flexible(
                  child: OutlinedButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30)),
                            ),
                            useRootNavigator: false,
                            builder: (context) {
                              return const MoodSelected();
                            }).whenComplete(() {
                          setState(() {
                            if (MoodSelected.resultMood == '') {
                            } else {
                              resultMood = MoodSelected.resultMood;
                              MoodSelected.resultMood = '';
                            }
                          });
                        });
                      },
                      child: resultMood != null
                          ? Text(resultMood!)
                          : const Text('🤔 Select your mood')),
                ),
                const SizedBox(
                  width: 5,
                ),
                Flexible(
                    child: OutlinedButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return const ActivityPage();
                              }).whenComplete(() {
                            setState(() {
                              if (ActivityPage.resultAct == '') {
                              } else {
                                resultAct = ActivityPage.resultAct;
                                ActivityPage.resultAct = '';
                              }
                            });
                          });
                        },
                        child: resultAct != null
                            ? Text(resultAct!)
                            : const Text('☕ Select Activity')))
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
                      decoration: const InputDecoration(
                        labelText: 'Topic',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        prefixIcon: Icon(
                          Icons.book_outlined,
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
                            hintText: 'Tell your story here ^^',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
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
                    })
                  ],
                )),
            ElevatedButton(
                onPressed: () {
                  selectImage();
                },
                child: const Text('add image')),
          ],
        ),
      ),
    );
  }
}

addDiaryWithOutText(token, topic, write_detail, mood_emoji, mood_detail,
    _imageNameList, resultAct, now) async {
  var url = 'http://10.0.2.2:3000/localDiary/saveDiary';
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
          'date': now.toIso8601String(),
          'imageLocation': _imageNameList,
          'topic': topic,
          'detail': write_detail,
          'favorite': false,
        },
      ));
  var result = jsonDecode(response.body);
  return result;
}
