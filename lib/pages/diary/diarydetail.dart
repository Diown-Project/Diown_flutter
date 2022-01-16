import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:diown/pages/diary/choosediary.dart';
import 'package:diown/pages/diary/editlocaldiary.dart';
import 'package:ink_widget/ink_widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:favorite_button/favorite_button.dart';

class DiaryDetail extends StatefulWidget {
  const DiaryDetail({Key? key, required this.id}) : super(key: key);
  final id;
  @override
  _DiaryDetailState createState() => _DiaryDetailState();
}

class _DiaryDetailState extends State<DiaryDetail> {
  dynamic diary;
  var time;
  var isFav;
  findDetail(id) async {
    var url = 'http://10.0.2.2:3000/localDiary/findDetail';
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
      time =
          DateFormat('EEE. MMM d / yyyy').format(DateTime.parse(diary['date']));
      isFav = diary['favorite'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: diary != null ? Text('${time}') : Text('wait. . .'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        actions: [
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: isFav != null
                  ? StarButton(
                      iconSize: 40,
                      isStarred: isFav,
                      valueChanged: (value) async {
                        setState(() {
                          isFav = value;
                        });
                        var d = await favorite(widget.id, isFav);
                      })
                  : const Center(
                      child: CircularProgressIndicator(),
                    )),
          diary != null
              ? PopupMenuButton(
                  itemBuilder: (context) => [
                        PopupMenuItem(
                            onTap: () {
                              Future.delayed(
                                  const Duration(seconds: 0),
                                  () => Navigator.push(
                                      context,
                                      PageTransition(
                                          child: EditLocalDiary(
                                              id: widget.id, diary: diary),
                                          type:
                                              PageTransitionType.rightToLeft)));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.edit,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                                Text(
                                  'edit',
                                  style: TextStyle(fontSize: 14),
                                )
                              ],
                            )),
                        PopupMenuItem(
                            onTap: () {
                              Future.delayed(
                                  const Duration(seconds: 0),
                                  () => CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.confirm,
                                      onConfirmBtnTap: () async {
                                        CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.loading);
                                        var re = await deleteLocaldiary(diary);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                child: const ChooseDiary(),
                                                type: PageTransitionType
                                                    .rightToLeft));
                                      }));
                            },
                            padding: EdgeInsets.all(2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.delete_forever_rounded,
                                  size: 20,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'remove',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.red),
                                )
                              ],
                            ))
                      ])
              : Container()
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            diary != null && diary['imageLocation'] != null
                ? CarouselSlider.builder(
                    itemCount: diary['imageLocation'].length,
                    itemBuilder: (context, index, realIndex) {
                      return Container(
                        alignment: Alignment.center,
                        child: InkWidget(
                            onTap: () {
                              Alert(
                                  style: AlertStyle(
                                      backgroundColor: Colors.grey.shade200,
                                      isCloseButton: true,
                                      isButtonVisible: false,
                                      animationType: AnimationType.grow,
                                      buttonAreaPadding:
                                          const EdgeInsets.all(10),
                                      alertPadding: const EdgeInsets.all(10),
                                      constraints: const BoxConstraints()),
                                  context: context,
                                  content: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      'https://storage.googleapis.com/noseason/${diary['imageLocation'][index]}',
                                    ),
                                  )).show();
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                'https://storage.googleapis.com/noseason/${diary['imageLocation'][index]}',
                              ),
                            )),
                      );
                    },
                    options: CarouselOptions(
                        height: 280,
                        viewportFraction: 0.9,
                        aspectRatio: 16 / 9,
                        enableInfiniteScroll: false,
                        enlargeCenterPage: true))
                : Container(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
              child: Row(
                children: [
                  Flexible(
                    child: diary != null
                        ? Chip(
                            padding: EdgeInsets.all(0),
                            backgroundColor: Colors.grey[100],
                            label: Text(
                                '${diary['mood_emoji']} ${diary['mood_detail']}',
                                style: TextStyle(color: Colors.black)),
                          )
                        : Container(),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Flexible(
                      flex: 2,
                      child: diary != null && diary['activity'] != null
                          ? Chip(
                              padding: EdgeInsets.all(0),
                              backgroundColor: Colors.grey[100],
                              label: Text('${diary['activity']}',
                                  style: TextStyle(color: Colors.black)),
                            )
                          : Container()),
                ],
              ),
            ),
            diary != null && diary['topic'] != null
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(23, 0, 8, 5),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '${diary['topic']}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                : Container(),
            diary != null && diary['detail'] != null
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(23, 0, 8, 5),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${diary['detail']}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

favorite(id, isFav) async {
  var url = 'http://10.0.2.2:3000/localDiary/fav';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{'id': id, 'fav': isFav!},
      ));
  var result = jsonDecode(response.body);
  return result;
}

deleteLocaldiary(diary) async {
  var url = 'http://10.0.2.2:3000/localDiary/deleteLocalDiary';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{'diary': diary},
      ));
  var result = jsonDecode(response.body);
  return result;
}
