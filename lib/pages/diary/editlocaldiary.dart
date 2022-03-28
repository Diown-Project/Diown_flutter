import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:card_swiper/card_swiper.dart';
import 'package:http/http.dart' as http;
import 'package:cool_alert/cool_alert.dart';
import 'package:diown/pages/extraPage/apigcloud.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
  bool isVisibleMood = true;
  bool isVisibleActivity = true;
  CloudApi? api;
  int numPic = 0;
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
          if (imageLocation != null) {
            var check = imageLocation.length + _imageNameList.length;
            if (check > 5) {
              _imageByteList =
                  _imageByteList!.sublist(0, 5 - imageLocation.length);
              _imageNameList =
                  _imageNameList!.sublist(0, 5 - imageLocation.length);
            }
            numPic = _imageNameList!.length + imageLocation.length;
          } else {
            if (_imageNameList!.length > 5) {
              _imageByteList = _imageByteList!.sublist(0, 5);
              _imageNameList = _imageNameList!.sublist(0, 5);
            }
            numPic = _imageNameList!.length;
          }
        } else {
          _imageByteList = _imageByte!.toList();
          _imageNameList = _imageName!.toList();
          if (imageLocation != null) {
            var check = imageLocation.length + _imageNameList.length;
            if (check > 5) {
              _imageByteList =
                  _imageByteList!.sublist(0, 5 - imageLocation.length);
              _imageNameList =
                  _imageNameList!.sublist(0, 5 - imageLocation.length);
            }
            numPic = _imageNameList!.length + imageLocation.length;
          } else {
            if (_imageNameList!.length > 5) {
              _imageByteList = _imageByteList!.sublist(0, 5);
              _imageNameList = _imageNameList!.sublist(0, 5);
            }
            numPic = _imageNameList!.length;
          }
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
          if (imageLocation != null) {
            var check = imageLocation.length + _imageNameList.length;
            if (check > 5) {
              _imageByteList =
                  _imageByteList!.sublist(0, 5 - imageLocation.length);
              _imageNameList =
                  _imageNameList!.sublist(0, 5 - imageLocation.length);
            }
            numPic = _imageNameList!.length + imageLocation.length;
          } else {
            if (_imageNameList!.length > 5) {
              _imageByteList = _imageByteList!.sublist(0, 5);
              _imageNameList = _imageNameList!.sublist(0, 5);
            }
            numPic = _imageNameList!.length;
          }
        } else {
          _imageByteList = _imageByte!.toList();
          _imageNameList = _imageName!.toList();
          if (imageLocation != null) {
            var check = imageLocation.length + _imageNameList.length;
            if (check > 5) {
              _imageByteList =
                  _imageByteList!.sublist(0, 5 - imageLocation.length);
              _imageNameList =
                  _imageNameList!.sublist(0, 5 - imageLocation.length);
            }
            numPic = _imageNameList!.length + imageLocation.length;
          } else {
            if (_imageNameList!.length > 5) {
              _imageByteList = _imageByteList!.sublist(0, 5);
              _imageNameList = _imageNameList!.sublist(0, 5);
            }
            numPic = _imageNameList!.length;
          }
        }
      } else {}
    });
  }

  _saveImage() async {
    final response = await api!.save(_imageNameList!, _imageByteList!);
    print(response);
  }

  findDetail(id) async {
    var url = 'http://ec2-175-41-169-93.ap-southeast-1.compute.amazonaws.com:3000/localDiary/findDetail';
    final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
          <String, String>{'id': id},
        ));
    var result = jsonDecode(response.body);
    setState(() {
      diary = result;
      resultMood = '${diary['mood_emoji']} ${diary['mood_detail']}';
      resultAct = diary['activity'];
      topic = diary['topic'];
      detail = diary['detail'];
      if (resultMood != null) {
        isVisibleMood = isVisibleMood;
      } else {
        isVisibleMood = !isVisibleMood;
      }
      if (resultAct != null) {
        isVisibleActivity = isVisibleActivity;
      } else {
        isVisibleActivity = !isVisibleActivity;
      }
      imageLocation = diary['imageLocation'];
      if (imageLocation != null) {
        setState(() {
          numPic = imageLocation.length;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findDetail(widget.diary['_id']);
    rootBundle.loadString('assets/credentials.json').then((value) {
      api = CloudApi(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return diary == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : GestureDetector(
            onTap: FocusScope.of(context).unfocus,
            child: Scaffold(
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
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                  diary['date'].toString().substring(0, 10),
                                  style: const TextStyle(
                                      fontSize: 15, color: Color(0xffafacac)))),
                          const Spacer(),
                          OutlinedButton(
                            onPressed: () async {
                              CoolAlert.show(
                                  barrierDismissible: false,
                                  context: context,
                                  type: CoolAlertType.confirm,
                                  title: 'Are you sure?',
                                  text:
                                      'touch ok button if you want to save this edit.',
                                  onConfirmBtnTap: () async {
                                    CoolAlert.show(
                                        barrierDismissible: false,
                                        context: context,
                                        type: CoolAlertType.loading);
                                    if (_imageByteList != null &&
                                        _imageNameList != null &&
                                        resultMood != null &&
                                        _imageByteList!.isNotEmpty &&
                                        _imageNameList!.isNotEmpty) {
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
                                          detail,
                                          imageLocation);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
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
                                          detail,
                                          imageLocation);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    } else {
                                      CoolAlert.show(
                                          barrierDismissible: false,
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
                            child: const Text('save',
                                style: TextStyle(color: Colors.white)),
                            style: OutlinedButton.styleFrom(
                              minimumSize: Size(65, 30),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              backgroundColor: Color(0xff945cfe),
                              side: BorderSide.none,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      imageLocation == null
                          ? _imageByteList != null
                              ? _imageByteList.isNotEmpty
                                  ? Container(
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
                                                    });
                                                  },
                                                  icon: const Icon(
                                                    Icons
                                                        .remove_circle_outlined,
                                                    color: Colors.red,
                                                  )),
                                            )
                                          ]);
                                        },
                                      ),
                                    )
                                  : Container()
                              : Container()
                          : _imageByteList != null
                              ? imageLocation.isNotEmpty
                                  ? Container(
                                      height: 300,
                                      child: Swiper(
                                        loop: false,
                                        itemHeight: 300,
                                        pagination: const SwiperPagination(
                                            margin: EdgeInsets.all(15),
                                            builder: SwiperPagination.dots),
                                        layout: SwiperLayout.DEFAULT,
                                        itemCount: _imageByteList!.length +
                                            imageLocation.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          var c = [
                                            ...imageLocation,
                                            ..._imageByteList
                                          ].toSet().toList();
                                          return c[index].runtimeType != String
                                              ? Stack(children: [
                                                  Center(
                                                      child: Image.memory(
                                                    c[index],
                                                  )),
                                                  Positioned(
                                                    bottom: 5,
                                                    right: 5,
                                                    child: IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            var dex =
                                                                _imageByteList
                                                                    .indexOf(c[
                                                                        index]);
                                                            _imageByteList
                                                                ?.remove(
                                                                    c[index]);

                                                            _imageNameList
                                                                ?.removeAt(dex);
                                                            numPic = numPic - 1;
                                                          });
                                                        },
                                                        icon: const Icon(
                                                          Icons
                                                              .remove_circle_outlined,
                                                          color: Colors.red,
                                                        )),
                                                  )
                                                ])
                                              : Stack(children: [
                                                  Center(
                                                      child: Image.network(
                                                    'https://storage.googleapis.com/noseason/${c[index]}',
                                                  )),
                                                  Positioned(
                                                    bottom: 5,
                                                    right: 5,
                                                    child: IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            imageLocation
                                                                .remove(
                                                                    c[index]);
                                                            numPic = numPic - 1;
                                                          });
                                                        },
                                                        icon: const Icon(
                                                          Icons
                                                              .remove_circle_outlined,
                                                          color: Colors.red,
                                                        )),
                                                  )
                                                ]);
                                        },
                                      ),
                                    )
                                  : _imageByteList.isNotEmpty
                                      ? Container(
                                          height: 300,
                                          child: Swiper(
                                            loop: false,
                                            itemHeight: 300,
                                            pagination: const SwiperPagination(
                                                margin: EdgeInsets.all(15),
                                                builder: SwiperPagination.dots),
                                            layout: SwiperLayout.DEFAULT,
                                            itemCount: _imageByteList!.length +
                                                imageLocation.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              var c = [
                                                ...imageLocation,
                                                ..._imageByteList
                                              ].toSet().toList();
                                              return c[index].runtimeType !=
                                                      String
                                                  ? Stack(children: [
                                                      Center(
                                                          child: Image.memory(
                                                        c[index],
                                                      )),
                                                      Positioned(
                                                        bottom: 5,
                                                        right: 5,
                                                        child: IconButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                var dex = _imageByteList
                                                                    .indexOf(c[
                                                                        index]);
                                                                _imageByteList
                                                                    ?.remove(c[
                                                                        index]);

                                                                _imageNameList
                                                                    ?.removeAt(
                                                                        dex);
                                                                numPic =
                                                                    numPic - 1;
                                                              });
                                                            },
                                                            icon: const Icon(
                                                              Icons
                                                                  .remove_circle_outlined,
                                                              color: Colors.red,
                                                            )),
                                                      )
                                                    ])
                                                  : Stack(children: [
                                                      Center(
                                                          child: Image.network(
                                                        'https://storage.googleapis.com/noseason/${c[index]}',
                                                      )),
                                                      Positioned(
                                                        bottom: 5,
                                                        right: 5,
                                                        child: IconButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                imageLocation
                                                                    .remove(c[
                                                                        index]);
                                                                numPic =
                                                                    numPic - 1;
                                                              });
                                                            },
                                                            icon: const Icon(
                                                              Icons
                                                                  .remove_circle_outlined,
                                                              color: Colors.red,
                                                            )),
                                                      )
                                                    ]);
                                            },
                                          ),
                                        )
                                      : Container()
                              : imageLocation.isNotEmpty
                                  ? Container(
                                      height: 300,
                                      child: Swiper(
                                        loop: false,
                                        itemHeight: 300,
                                        pagination: const SwiperPagination(
                                            margin: EdgeInsets.all(15),
                                            builder: SwiperPagination.dots),
                                        layout: SwiperLayout.DEFAULT,
                                        itemCount: imageLocation.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Stack(children: [
                                            Center(
                                                child: Image.network(
                                              'https://storage.googleapis.com/noseason/${imageLocation[index]}',
                                            )),
                                            Positioned(
                                              bottom: 5,
                                              right: 5,
                                              child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      imageLocation.remove(
                                                          imageLocation[index]);
                                                      numPic = numPic - 1;
                                                    });
                                                  },
                                                  icon: const Icon(
                                                    Icons
                                                        .remove_circle_outlined,
                                                    color: Colors.red,
                                                  )),
                                            )
                                          ]);
                                        },
                                      ),
                                    )
                                  : Container(),
                      const SizedBox(
                        height: 1,
                      ),
                      numPic != 0
                          ? Container(
                              alignment: Alignment.topRight,
                              child: Text('$numPic/5'))
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
                                      ? Text(resultMood)
                                      : Container()),
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
                                    isVisibleActivity = false;
                                    resultAct = null;
                                  });
                                },
                                child: resultAct != null
                                    ? Text(resultAct)
                                    : Container()),
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
                                initialValue: diary['topic'],
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
                                    initialValue: diary['detail'],
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
                                        detail = value;
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

updateDiary(id, mood_emoji, mood_detail, resultAct, _imageNameList, topic,
    detail, imageLocation) async {
  var url = 'http://ec2-175-41-169-93.ap-southeast-1.compute.amazonaws.com:3000/localDiary/update';
  if (topic == '') {
    topic = null;
  }
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
          'imageOld': imageLocation,
          'topic': topic,
          'detail': detail,
        },
      ));
  var result = jsonDecode(response.body);
  return result;
}


// Row(
//                   children: [
//                     Flexible(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             _imageByteList = null;
//                             _image = null;
//                             _imageByte = null;
//                             _imageName = null;
//                             _imageNameList = [];
//                             imageLocation = null;
//                           });
//                         },
//                         child: const Text('Delete image sets.'),
//                         style: ButtonStyle(
//                             foregroundColor:
//                                 MaterialStateProperty.all<Color>(Colors.white),
//                             backgroundColor:
//                                 MaterialStateProperty.all<Color>(Colors.red),
//                             shape: MaterialStateProperty.all<
//                                     RoundedRectangleBorder>(
//                                 RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(80.0),
//                                     side: const BorderSide(
//                                         color:
//                                             Color.fromRGBO(148, 92, 254, 1))))),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 5,
//                     ),
//                     Flexible(
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           await selectImage();
//                           if (_imageNameList != null) {
//                             setState(() {
//                               imageLocation = null;
//                             });
//                           }
//                         },
//                         child: const Text('Change image sets.'),
//                         style: ButtonStyle(
//                             foregroundColor:
//                                 MaterialStateProperty.all<Color>(Colors.white),
//                             backgroundColor: MaterialStateProperty.all<Color>(
//                                 const Color.fromRGBO(148, 92, 254, 1)),
//                             shape: MaterialStateProperty.all<
//                                     RoundedRectangleBorder>(
//                                 RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(80.0),
//                                     side: const BorderSide(
//                                         color:
//                                             Color.fromRGBO(148, 92, 254, 1))))),
//                       ),
//                     )
//                   ],
//                 )


// _imageByteList != null
//                         ? CarouselSlider.builder(
//                             itemCount: _imageByteList.length,
//                             itemBuilder: (context, index, realIndex) {
//                               return Image.memory(_imageByteList[index]);
//                             },
//                             options: CarouselOptions(
//                                 height: 200,
//                                 enableInfiniteScroll: false,
//                                 enlargeCenterPage: true))
//                         : Container()
//                     : CarouselSlider.builder(
//                         itemCount: imageLocation.length,
//                         itemBuilder: (context, index, realIndex) {
//                           return Image.network(
//                               'https://storage.googleapis.com/noseason/${imageLocation[index]}');
//                         },
//                         options: CarouselOptions(
//                             height: 200,
//                             enableInfiniteScroll: false,
//                             enlargeCenterPage: true)),