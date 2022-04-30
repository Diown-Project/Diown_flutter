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
import 'package:dropdown_button2/dropdown_button2.dart';

class WritePutdownDiary extends StatefulWidget {
  const WritePutdownDiary(
      {Key? key, required this.pin, required this.pin_name, required this.deal})
      : super(key: key);
  final pin_name;
  final pin;
  final deal;
  @override
  State<WritePutdownDiary> createState() => _WritePutdownDiaryState();
}

class _WritePutdownDiaryState extends State<WritePutdownDiary> {
  CloudApi? api;
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
  final _formkey = GlobalKey<FormState>();
  DateTime now = DateTime.now();
  String? selectedValue = 'Public';
  List<String> items = [
    'Public',
    'Follower',
    'Private',
  ];
  Map<String, Icon> icons = {
    'Public': const Icon(Icons.public),
    'Follower': const Icon(Icons.people),
    'Private': const Icon(Icons.lock),
  };
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
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(now.toString().substring(0, 10),
                          style: const TextStyle(
                              fontSize: 15, color: Color(0xffafacac)))),
                  const Spacer(),
                  OutlinedButton(
                      onPressed: () async {
                        CoolAlert.show(
                            barrierDismissible: false,
                            context: context,
                            type: CoolAlertType.confirm,
                            title: 'Please confirm',
                            text: 'If you want to save this diary.',
                            onConfirmBtnTap: () async {
                              CoolAlert.show(
                                  context: context,
                                  barrierDismissible: false,
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
                                await saveDiary(
                                    token,
                                    mood_emoji,
                                    mood_detail,
                                    resultAct,
                                    _imageNameList,
                                    topic,
                                    write_detail,
                                    widget.pin,
                                    selectedValue,
                                    widget.deal);
                                var check = await checkAchievement(1);
                                if (check['message'] == 'success') {
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
                                                    'images/Place_Memory.png')),
                                          ),
                                          title: 'congratulations',
                                          body: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15, 0, 10, 10),
                                              child: Column(
                                                children: const [
                                                  Text(
                                                    'congratulations',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      height: 1.5,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    'Congratulations to unlock this achievement (Place Memory).',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              )),
                                          btnOk: ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                              child: const Text('ok')))
                                      .show();
                                } else {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              } else if (resultMood != null) {
                                var mood_emoji = resultMood!.substring(0, 2);
                                var mood_detail = resultMood!.substring(3);
                                await saveDiary(
                                    token,
                                    mood_emoji,
                                    mood_detail,
                                    resultAct,
                                    _imageNameList,
                                    topic,
                                    write_detail,
                                    widget.pin,
                                    selectedValue,
                                    widget.deal);
                                var check = await checkAchievement(1);
                                if (check['message'] == 'success') {
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
                                                    'images/Place_Memory.png')),
                                          ),
                                          title: 'congratulations',
                                          body: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15, 0, 10, 10),
                                              child: Column(
                                                children: const [
                                                  Text(
                                                    'congratulations',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      height: 1.5,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    'Congratulations to unlock this achievement (Place Memory).',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              )),
                                          btnOk: ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                              child: const Text('ok')))
                                      .show();
                                } else {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              } else {
                                CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.error,
                                    barrierDismissible: false,
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
                      child: const Text('save',
                          style: TextStyle(color: Colors.white)),
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(65, 30),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        backgroundColor: Color(0xff945cfe),
                        side: BorderSide.none,
                      ))
                ],
              ),
              const SizedBox(
                height: 2,
              ),
              Row(
                children: [
                  Container(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        children: [
                          Icon(
                            Icons.pin_drop_rounded,
                            color: Colors.black,
                          ),
                          Text(widget.pin_name,
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black))
                        ],
                      )),
                  Spacer(),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      hint: Text(
                        'Select Item',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      items: items
                          .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Container(
                                child: Row(
                                  children: [
                                    icons[item] as Widget,
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '$item',
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              )))
                          .toList(),
                      value: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value as String;
                        });
                      },
                      buttonHeight: 40,
                      buttonWidth: 140,
                      itemHeight: 40,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
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
                            itemBuilder: (BuildContext context, int index) {
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
                                          _imageByteList?.removeAt(index);
                                          _imageNameList?.removeAt(index);
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
                                borderRadius: BorderRadius.circular(50.0)),
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
                                  style: const TextStyle(color: Colors.black),
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
                              borderRadius: BorderRadius.circular(50.0)),
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
                                style: const TextStyle(color: Colors.black),
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
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
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
                      })
                    ],
                  )),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  Container _buildBottomBar() {
    return Container(
      height: 120,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          boxShadow: [
            // BoxShadow(
            //     color: Colors.grey,
            //     spreadRadius: -7,
            //     blurRadius: 20,
            //     offset: Offset(0, 5)),
          ]),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25)),
                    ),
                    builder: (context) {
                      return Container(
                        height: 260,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: 7,
                                width: 69,
                                decoration: BoxDecoration(
                                    color: Color(0xffc4c4c4),
                                    borderRadius: BorderRadius.circular(25)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  40.0, 20.0, 0.0, 20.0),
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
                                        isVisibleMood = isVisibleMood;
                                        resultMood = MoodSelected.resultMood;
                                        MoodSelected.resultMood = '';
                                      }
                                    });
                                  });
                                },
                                child: Row(
                                  children: [
                                    Container(
                                        width: 48,
                                        height: 48,
                                        decoration: const BoxDecoration(
                                            color: Color(0xff945cfe),
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
                              padding: const EdgeInsets.fromLTRB(
                                  40.0, 0.0, 0.0, 20.0),
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
                                        width: 48,
                                        height: 48,
                                        decoration: const BoxDecoration(
                                            color: Color(0xff945cfe),
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
                              padding: const EdgeInsets.fromLTRB(
                                  40.0, 0.0, 0.0, 20.0),
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            topRight: Radius.circular(30)),
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
                                                        const EdgeInsets.all(
                                                            8.0),
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
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        )),
                                                  ),
                                                  const Divider(
                                                    thickness: 0.8,
                                                  ),
                                                  ListTile(
                                                    leading: const Icon(
                                                      Icons.photo,
                                                      color: Color.fromRGBO(
                                                          148, 92, 254, 1),
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
                                                      color: Color.fromRGBO(
                                                          148, 92, 254, 1),
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
                                        width: 48,
                                        height: 48,
                                        decoration: const BoxDecoration(
                                            color: Color(0xff945cfe),
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
                      );
                    });
              },
              child: Container(
                height: 7,
                width: 69,
                decoration: BoxDecoration(
                    color: Color(0xffc4c4c4),
                    borderRadius: BorderRadius.circular(25)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                          color: Color(0xff945cfe), shape: BoxShape.circle),
                      child: const Icon(
                        MdiIcons.emoticonHappyOutline,
                        color: Colors.white,
                        size: 30,
                      )),
                ),
                const SizedBox(width: 50),
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
                          color: Color(0xff945cfe), shape: BoxShape.circle),
                      child: const Icon(
                        MdiIcons.run,
                        color: Colors.white,
                        size: 30,
                      )),
                ),
                const SizedBox(width: 50),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
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
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                          title: const Text(
                                            'Select to add images.',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          trailing: IconButton(
                                            icon: const Icon(
                                                Icons.highlight_remove_rounded),
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
                                        color: Color.fromRGBO(148, 92, 254, 1),
                                      ),
                                      title:
                                          const Text('Pick images in gallery.'),
                                      trailing: const Icon(
                                          Icons.navigate_next_rounded),
                                      onTap: () {
                                        selectImage();
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.camera_alt,
                                        color: Color.fromRGBO(148, 92, 254, 1),
                                      ),
                                      title: const Text('Take a picture.'),
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
                          color: Color(0xff945cfe), shape: BoxShape.circle),
                      child: const Icon(
                        MdiIcons.imageOutline,
                        color: Colors.white,
                        size: 30,
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

saveDiary(token, mood_emoji, mood_detail, resultAct, _imageNameList, topic,
    write_detail, pin, selectedValue, deal) async {
  var url = 'https://diown-app-server.herokuapp.com/putdown/saveDiary';
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
          'like': 0,
          'marker_id': pin,
          'status': selectedValue,
          'deal': deal
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
