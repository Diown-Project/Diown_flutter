import 'dart:convert';
import 'package:card_swiper/card_swiper.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:diown/pages/diary/gallery.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DetailDiaryOnePutdown extends StatefulWidget {
  const DetailDiaryOnePutdown({Key? key, required this.id}) : super(key: key);
  final id;
  @override
  State<DetailDiaryOnePutdown> createState() => _DetailDiaryOnePutdownState();
}

class _DetailDiaryOnePutdownState extends State<DetailDiaryOnePutdown> {
  dynamic diary, user;
  var time;
  // var isFav;
  findDetail(id) async {
    var url = 'http://10.0.2.2:3000/putdown/findDetail';
    final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
          <String, String>{'id': id},
        ));
    var result = jsonDecode(response.body);
    if (result == null) {
      diary = {};
      diary['message'] = 'This diary was deleted.';
      // isFav = false;
      setState(() {});
    } else {
      setState(() {
        diary = result;
        time = DateFormat('EEE. MMM d / yyyy')
            .format(DateTime.parse(diary['date']));
        // isFav = diary['favorite'];
      });
    }
  }

  findUser() async {
    var url = 'http://10.0.2.2:3000/auth/rememberMe';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
          <String, dynamic>{'token': token},
        ));
    user = jsonDecode(response.body);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findDetail(widget.id);
    findUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: diary != null
            ? diary.containsKey('message')
                ? Text('This diary was deleted.')
                : Text('${time}')
            : Text('wait. . .'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        actions: [
          diary != null
              ? diary.containsKey('message')
                  ? Container()
                  : user != null
                      ? user['_id'] == diary['user_id']
                          ? FavoriteButton(
                              iconSize: 40,
                              valueChanged: (_) {},
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FavoriteButton(
                                iconSize: 40,
                                valueChanged: (_) {},
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
              padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
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

deletePutdowndiary(diary) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'http://10.0.2.2:3000/putdown/deletePutdownDiary';
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
