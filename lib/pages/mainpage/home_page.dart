import 'dart:convert';
import 'package:diown/pages/putdowndiary/diarydetailputdown.dart';
import 'package:http/http.dart' as http;
import 'package:diown/pages/event/carousel_loading.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static String id = 'HomePage';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var latest;

  findLatest() async {
    latest = await findLatestPutdown();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: findLatest(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 5, 15, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'images/logo_support.png',
                                width: 120,
                              ),
                            ],
                          ),
                        ),
                        CarouselLoading(),
                        Container(
                            alignment: Alignment.topLeft,
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(14, 8, 14, 0),
                              child: Text(
                                'Latest following putdown:',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            )),
                        const SizedBox(height: 15),
                        Column(
                          children: latest.map<Widget>((e) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xfff1f3f4),
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'https://storage.googleapis.com/noseason/${e['user_detail'][0]['profile_image']}'),
                                  ),
                                  title: e['topic'] != null
                                      ? Text(e['topic'])
                                      : Text(
                                          '${e['mood_emoji']} ${e['mood_detail']}'),
                                  subtitle: Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          '@${e['user_detail'][0]['username']} - ',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Flexible(
                                        child: Row(children: [
                                          const Icon(
                                            MdiIcons.mapMarker,
                                            color: Colors.black54,
                                            size: 14,
                                          ),
                                          Flexible(
                                            child: Text(
                                                '${e['marker_detail'][0]['marker_id']}',
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    )),
                                          )
                                        ]),
                                      ),
                                    ],
                                  ),
                                  trailing: Text(
                                    e['date'].toString().substring(0, 10),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: DiaryDetailPutdown(
                                              id: e['_id'],
                                            ),
                                            type: PageTransitionType.rightToLeft));
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(
                          height: 30,
                        )
                      ],
                    )
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

findLatestPutdown() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'http://10.0.2.2:3000/putdown/findLatestPutdown';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{'token': token},
      ));
  var result = jsonDecode(response.body);
  return result;
}
