import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:diown/pages/diary/choosediary.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:diown/pages/extraPage/apigcloud.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ink_widget/ink_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'activity.dart';
import 'mood.dart';

class EditLocalDiary extends StatefulWidget {
  const EditLocalDiary({Key? key, required this.id, required this.diary})
      : super(key: key);
  final id;
  final diary;
  @override
  _EditLocalDiaryState createState() => _EditLocalDiaryState();
}

class _EditLocalDiaryState extends State<EditLocalDiary> {
  final _formkey = GlobalKey<FormState>();
  CloudApi? api;
  var diary;
  var resultMood,
      resultMoodInit,
      resultAct,
      topic,
      detail,
      imageLocation,
      mood_emoji,
      mood_detail;
  Iterable<File>? _image;
  Iterable<Uint8List>? _imageByte;
  var _imageByteList;
  Iterable<String>? _imageName;
  var _imageNameList;
  final ImagePicker imagePicker = ImagePicker();
  selectImage() async {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    diary = widget.diary;
    resultMood = '${diary['mood_emoji']} ${diary['mood_detail']}';
    resultAct = diary['activity'];
    topic = diary['topic'];
    detail = diary['detail'];

    imageLocation = diary['imageLocation'];
    rootBundle.loadString('assets/credentials.json').then((value) {
      api = CloudApi(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('edit diary'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                      alignment: Alignment.topLeft,
                      child: Text(diary['date'].toString().substring(0, 10),
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
                            if (_imageByteList != null &&
                                _imageNameList != null &&
                                resultMood != null) {
                              await _saveImage();
                              mood_emoji = resultMood!.substring(0, 2);
                              mood_detail = resultMood!.substring(3);
                              await updateDiary(
                                  diary['_id'],
                                  mood_emoji,
                                  mood_detail,
                                  resultAct,
                                  _imageNameList,
                                  topic,
                                  detail);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: const ChooseDiary(),
                                      type: PageTransitionType.rightToLeft));
                            } else if (resultMood != null) {
                              mood_emoji = resultMood!.substring(0, 2);
                              mood_detail = resultMood!.substring(3);
                              await updateDiary(
                                  diary['_id'],
                                  mood_emoji,
                                  mood_detail,
                                  resultAct,
                                  _imageNameList,
                                  topic,
                                  detail);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: const ChooseDiary(),
                                      type: PageTransitionType.rightToLeft));
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80.0),
                                    side: const BorderSide(
                                        color:
                                            Color.fromRGBO(148, 92, 254, 1))))),
                  )
                ],
              ),
              const SizedBox(
                height: 2,
              ),
              imageLocation == null
                  ? _imageByteList != null
                      ? CarouselSlider.builder(
                          itemCount: _imageByteList.length,
                          itemBuilder: (context, index, realIndex) {
                            return Image.memory(_imageByteList[index]);
                          },
                          options: CarouselOptions(
                              height: 200,
                              enableInfiniteScroll: false,
                              enlargeCenterPage: true))
                      : Container()
                  : CarouselSlider.builder(
                      itemCount: imageLocation.length,
                      itemBuilder: (context, index, realIndex) {
                        return Image.network(
                            'https://storage.googleapis.com/noseason/${imageLocation[index]}');
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
                            ? Text(resultMood)
                            : Container()),
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
                              ? Text(resultAct)
                              : Container()))
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
                        initialValue: diary['topic'],
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
                            initialValue: diary['detail'],
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
                                detail = value;
                              });
                            },
                          ),
                        );
                      })
                    ],
                  )),
              Row(
                children: [
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _imageByteList = null;
                          _image = null;
                          _imageByte = null;
                          _imageName = null;
                          _imageNameList = [];
                          imageLocation = null;
                        });
                      },
                      child: const Text('Delete image sets.'),
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(80.0),
                                      side: const BorderSide(
                                          color: Color.fromRGBO(
                                              148, 92, 254, 1))))),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () async {
                        await selectImage();
                        if (_imageNameList != null) {
                          setState(() {
                            imageLocation = null;
                          });
                        }
                      },
                      child: const Text('Change image sets.'),
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromRGBO(148, 92, 254, 1)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(80.0),
                                      side: const BorderSide(
                                          color: Color.fromRGBO(
                                              148, 92, 254, 1))))),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

updateDiary(id, mood_emoji, mood_detail, resultAct, _imageNameList, topic,
    detail) async {
  var url = 'http://10.0.2.2:3000/localDiary/update';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{
          'id': id,
          'mood_emoji': mood_emoji,
          'mood_detail': mood_detail,
          'activity': resultAct,
          'imageLocation': _imageNameList,
          'topic': topic,
          'detail': detail,
        },
      ));
  var result = jsonDecode(response.body);
  return result;
}
