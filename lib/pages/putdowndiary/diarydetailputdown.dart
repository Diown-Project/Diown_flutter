import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:diown/pages/diary/gallery.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DiaryDetailPutdown extends StatefulWidget {
  const DiaryDetailPutdown({Key? key, required this.id}) : super(key: key);
  final id;
  @override
  State<DiaryDetailPutdown> createState() => _DiaryDetailPutdownState();
}

class _DiaryDetailPutdownState extends State<DiaryDetailPutdown> {
  dynamic diary, user, like, likeCount;
  var time;
  // var isFav;
  findDetail(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var url1 = 'https://diown-app-server.herokuapp.com/putdown/findDetail';
    final http.Response response1 = await http.post(Uri.parse(url1),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
          <String, String>{'id': id},
        ));
    var result = jsonDecode(response1.body);
    print(result.isEmpty);
    if (result.isEmpty) {
      diary = {};
      diary['message'] = 'This diary was deleted.';
      // isFav = false;
      if (mounted) {
        setState(() {});
      }
    } else {
      var url2 = 'https://diown-app-server.herokuapp.com/putdown/checkLike';
      final http.Response response2 = await http.post(Uri.parse(url2),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(
            <String, String>{'token': token!, 'diary_id': id},
          ));
      var result2 = jsonDecode(response2.body);
      var url = 'https://diown-app-server.herokuapp.com/auth/rememberMe';
      final http.Response response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(
            <String, dynamic>{'token': token},
          ));
      user = jsonDecode(response.body);
      if (mounted) {
        setState(() {});
      }
      if (result2['message'] == 'true') {
        like = true;
        if (mounted) {
          setState(() {});
        }
      } else {
        like = false;
        if (mounted) {
          setState(() {});
        }
      }
      if (mounted) {
        setState(() {
          diary = result[0];
          likeCount = diary['like'];
          time = DateFormat('d MMM yyyy (EEE)')
              .format(DateTime.parse(diary['date']));
          // isFav = diary['favorite'];
        });
      }

      if (like == false && likeCount >= 1 && diary['user_id'] == user['_id']) {
        var check = await checkAchievement(11);
        if (check['message'] == 'success') {
          AwesomeDialog(
                  context: context,
                  dismissOnTouchOutside: false,
                  dialogType: DialogType.SUCCES,
                  customHeader: Container(
                    height: 100,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset('images/someone_interesting.png')),
                  ),
                  title: 'Congratulations',
                  body: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 10, 10),
                      child: Column(
                        children: const [
                          Text(
                            'Congratulations',
                            style: TextStyle(
                              fontSize: 20,
                              height: 1.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'You have unlock the new achievement (Someone Interest)',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )),
                  btnOk: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK')))
              .show();
        }
      } else if (like == true &&
          likeCount > 1 &&
          diary['user_id'] == user['_id']) {
        var check = await checkAchievement(11);
        if (check['message'] == 'success') {
          AwesomeDialog(
                  context: context,
                  dismissOnTouchOutside: false,
                  dialogType: DialogType.SUCCES,
                  customHeader: Container(
                    height: 100,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset('images/someone_interesting.png')),
                  ),
                  title: 'Congratulations',
                  body: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 10, 10),
                      child: Column(
                        children: const [
                          Text(
                            'Congratulations',
                            style: TextStyle(
                              fontSize: 20,
                              height: 1.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'You have unlock the new achievement (Someone Interest)',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )),
                  btnOk: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                        backgroundColor: Color(0xff8a7efd),
                        side: BorderSide.none,
                      ),
                  ))
              .show();
        }
      } else {}
    }
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
        title: diary != null
            ? diary.containsKey('message')
                ? Text('This Diary was Deleted.')
                : Text('${time}')
            : Text('Please wait. . .'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        actions: [
          diary != null
              ? diary.containsKey('message')
                  ? Container()
                  : user != null
                      ? user['_id'] == diary['user_id']
                          ? Row(
                              children: [
                                likeCount.toString().length > 6
                                    ? Text(likeCount.toString().substring(0,
                                            likeCount.toString().length - 6) +
                                        'm')
                                    : likeCount.toString().length > 3
                                        ? Text(likeCount.toString().substring(
                                                0,
                                                likeCount.toString().length -
                                                    3) +
                                            'k')
                                        : Text(likeCount.toString()),
                                FavoriteButton(
                                  iconSize: 40,
                                  isFavorite: like,
                                  valueChanged: (value) async {
                                    var check = await checkAchievement(10);
                                    if (check['message'] == 'success') {
                                      AwesomeDialog(
                                              context: context,
                                              dismissOnTouchOutside: false,
                                              dialogType: DialogType.SUCCES,
                                              customHeader: Container(
                                                height: 100,
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    child: Image.asset(
                                                        'images/first_like.png')),
                                              ),
                                              title: 'Congratulations',
                                              body: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          15, 0, 10, 10),
                                                  child: Column(
                                                    children: const [
                                                      Text(
                                                        'Congratulations',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          height: 1.5,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      Text(
                                                        'You have unlock the new achievement (First Like)',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ],
                                                  )),
                                              btnOk: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('OK'),
                                                  style: OutlinedButton.styleFrom(
                                                    shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(5.0)),
                                                    backgroundColor: Color(0xff8a7efd),
                                                    side: BorderSide.none,
                                                  ),
                                              ))
                                          .show();
                                    }
                                    if (value) {
                                      setState(() {
                                        likeCount += 1;
                                      });
                                      await addLike(diary['_id']);
                                    } else {
                                      setState(() {
                                        likeCount -= 1;
                                      });
                                      await removeLike(diary['_id']);
                                    }
                                  },
                                ),
                              ],
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  likeCount.toString().length > 6
                                      ? Text(likeCount.toString().substring(0,
                                              likeCount.toString().length - 6) +
                                          'm')
                                      : likeCount.toString().length > 3
                                          ? Text(likeCount.toString().substring(
                                                  0,
                                                  likeCount.toString().length -
                                                      3) +
                                              'k')
                                          : Text(likeCount.toString()),
                                  FavoriteButton(
                                    iconSize: 40,
                                    isFavorite: like,
                                    valueChanged: (value) async {
                                      var check = await checkAchievement(10);
                                      if (check['message'] == 'success') {
                                        AwesomeDialog(
                                                context: context,
                                                dismissOnTouchOutside: false,
                                                dialogType: DialogType.SUCCES,
                                                customHeader: Container(
                                                  height: 100,
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      child: Image.asset(
                                                          'images/first_like.png')),
                                                ),
                                                title: 'Congratulations',
                                                body: Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        15, 0, 10, 10),
                                                    child: Column(
                                                      children: const [
                                                        Text(
                                                          'Congratulations',
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            height: 1.5,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Text(
                                                          'You have unlock the new achievement (First Like)',
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    )),
                                                btnOk: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      'OK',
                                                      style: TextStyle(
                                                        color: Colors.white
                                                      ),
                                                    ),
                                                    style: OutlinedButton.styleFrom(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5.0)),
                                                      backgroundColor: Color(0xff8a7efd),
                                                      side: BorderSide.none,
                                                    ),
                                                )
                                                )
                                            .show();
                                      }
                                      if (value) {
                                        setState(() {
                                          likeCount += 1;
                                        });
                                        await addLike(diary['_id']);
                                      } else {
                                        setState(() {
                                          likeCount -= 1;
                                        });
                                        await removeLike(diary['_id']);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            )
                      : Container()
              : Container(),
          diary != null
              ? diary.containsKey('message')
                  ? Container()
                  : user != null
                      ? user['_id'] == diary['user_id']
                          ? PopupMenuButton(
                              itemBuilder: (context) => [
                                    PopupMenuItem(
                                        onTap: () {
                                          Future.delayed(
                                              const Duration(seconds: 0),
                                              () => CoolAlert.show(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  type: CoolAlertType.confirm,
                                                  title: 'Are you sure?',
                                                  text:
                                                      'Do you want to delete this diary.',
                                                  confirmBtnColor: Colors.red,
                                                  onConfirmBtnTap: () async {
                                                    CoolAlert.show(
                                                        barrierDismissible:
                                                            false,
                                                        context: context,
                                                        type: CoolAlertType
                                                            .loading);
                                                    await deletePutdowndiary(
                                                        diary);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  }));
                                        },
                                        padding: EdgeInsets.all(2),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                                  fontSize: 14,
                                                  color: Colors.red),
                                            )
                                          ],
                                        ))
                                  ])
                          : Container()
                      : Container()
              : Container()
        ],
        leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            diary != null && diary['imageLocation'] != null
                ? Container(
                    height: 300,
                    child: Swiper(
                      loop: false,
                      itemHeight: 300,
                      itemCount: diary['imageLocation'].length,
                      pagination: const SwiperPagination(
                          margin: EdgeInsets.all(15),
                          builder: DotSwiperPaginationBuilder(
                              activeColor: Colors.black, color: Colors.white)),
                      layout: SwiperLayout.DEFAULT,
                      itemBuilder: (context, index) {
                        return Container(
                          alignment: Alignment.center,
                          child: InkWell(
                            child: Ink.image(
                              image: NetworkImage(
                                'https://storage.googleapis.com/noseason/${diary['imageLocation'][index]}',
                              ),
                              height: 300,
                              fit: BoxFit.cover,
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => GalleryWidget(
                                  diary: diary,
                                  index: index,
                                ),
                              ));
                            },
                          ),
                        );
                      },
                    ),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 2),
              child: Row(
                children: [
                  Flexible(
                    child: diary != null && diary['mood_emoji'] != null
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
            diary != null
                ? diary.containsKey('message')
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          children: [
                            const Icon(
                              MdiIcons.mapMarker,
                              color: Colors.black,
                              size: 20,
                            ),
                            SizedBox(width: 5),
                            Text(diary['marker_detail'][0]['marker_id'],
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black)),
                          ],
                        ),
                      )
                : Container(),
            SizedBox(
              height: 20,
            ),
            diary != null && diary['topic'] != null
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Text('${diary['topic']}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  )
                : Container(),
            diary != null && diary['detail'] != null
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${diary['detail']}',
                        style: TextStyle(fontSize: 15),
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

deletePutdowndiary(diary) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'https://diown-app-server.herokuapp.com/putdown/deletePutdownDiary';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{'token': token, 'diary': diary},
      ));
  var result = jsonDecode(response.body);
  return result;
}

addLike(id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'https://diown-app-server.herokuapp.com/putdown/addLike';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{'token': token, 'diary_id': id},
      ));
  var result = jsonDecode(response.body);
  return result;
}

removeLike(id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'https://diown-app-server.herokuapp.com/putdown/removeLike';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{'token': token, 'diary_id': id},
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
