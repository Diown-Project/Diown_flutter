import 'dart:io';
import 'dart:typed_data';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:diown/pages/diary/activity.dart';
import 'package:diown/pages/diary/mood.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LocalDiary extends StatefulWidget {
  const LocalDiary({Key? key}) : super(key: key);

  @override
  _LocalDiaryState createState() => _LocalDiaryState();
}

class _LocalDiaryState extends State<LocalDiary> {
  final _formkey = GlobalKey<FormState>();
  String? resultMood;
  String? resultAct;
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
                  onPressed: () {},
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
