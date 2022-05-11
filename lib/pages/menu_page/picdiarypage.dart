import 'dart:convert';
import 'package:diown/pages/diary/diarydetail.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ink_widget/ink_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PictureDiary extends StatefulWidget {
  const PictureDiary({Key? key}) : super(key: key);

  @override
  _PictureDiaryState createState() => _PictureDiaryState();
}

class _PictureDiaryState extends State<PictureDiary> {
  var search;
  dynamic allDiary;
  findAllYourDiary2() async {
    allDiary = await findAllYourDiary1();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findAllYourDiary2();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: Color(0xffeff2f5),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black,
          centerTitle: true,
          title: const Text('Picture Diary'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CupertinoSearchTextField(
                placeholder: 'Search by date, topic',
                onChanged: (value) async {
                  allDiary = await findPicDiaryBySearch(value);
                  setState(() {});
                },
              ),
            ),
            Expanded(
                child: allDiary != null
                    ? allDiary.length != 0
                        ? MasonryGridView.count(
                            padding: EdgeInsets.all(8.0),
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                            itemCount: allDiary != null ? allDiary.length : 0,
                            crossAxisCount: 2,
                            itemBuilder: (context, index) {
                              return Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    InkWidget(
                                        onTap: () {
                                          Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      child: DiaryDetail(
                                                          id: allDiary[index]
                                                              ['_id']),
                                                      type: PageTransitionType
                                                          .rightToLeft))
                                              .then((_) async {
                                            await findAllYourDiary2();
                                            setState(() {});
                                          });
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                              'https://storage.googleapis.com/noseason/${allDiary[index]['imageLocation'][0]}'),
                                        )),
                                    Positioned(
                                        left: 6,
                                        bottom: 5,
                                        child: Text(
                                          '${allDiary![index]['date'].substring(0, 10)}',
                                          style: const TextStyle(
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 10.0,
                                                  color: Colors.black,
                                                  offset: Offset(1.0, 2.0),
                                                ),
                                              ],
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    allDiary[index]['topic'] != null
                                        ? Positioned(
                                            left: 6,
                                            bottom: 21,
                                            child: RichText(
                                              overflow: TextOverflow.ellipsis,
                                              text: TextSpan(
                                                text:
                                                    '${allDiary[index]['topic']}',
                                                style: const TextStyle(
                                                    shadows: [
                                                      Shadow(
                                                        blurRadius: 10.0,
                                                        color: Colors.black,
                                                        offset:
                                                            Offset(1.0, 2.0),
                                                      ),
                                                    ],
                                                    fontSize: 13,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ))
                                        : Container()
                                  ]);
                            })
                        : Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 40),
                              Icon(
                                MdiIcons.imageOff,
                                size: 100,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Dont have Picture diary',
                                style:
                                    TextStyle(fontSize: 20, color: Colors.grey),
                              )
                            ],
                          )
                    : Container()),
          ],
        ),
      ),
    );
  }
}

findAllYourDiary1() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url =
      'https://diown-app-server.herokuapp.com/localDiary/findAllDiaryHaveImage';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, String>{'token': token!},
      ));
  var result = jsonDecode(response.body);
  return result;
}

findPicDiaryBySearch(value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url =
      'https://diown-app-server.herokuapp.com/localDiary/findPicDiaryWithSearch';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, String>{'token': token!, 'value': value},
      ));
  var result = jsonDecode(response.body);
  return result;
}
