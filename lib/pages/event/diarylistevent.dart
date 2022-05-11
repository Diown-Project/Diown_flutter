import 'dart:convert';
import 'package:diown/pages/mainpage/map.dart';
import 'package:diown/pages/putdowndiary/diarydetailputdown.dart';
import 'package:diown/pages/screens/visitorprofile.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DiaryListInEvent extends StatefulWidget {
  const DiaryListInEvent({Key? key, required this.id}) : super(key: key);
  final id;
  @override
  State<DiaryListInEvent> createState() => _DiaryListInEventState();
}

class _DiaryListInEventState extends State<DiaryListInEvent> {
  var diaryList;
  findDiaryInPinThisPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var url =
        'https://diown-app-server.herokuapp.com/putdown/findListDiaryInEvent';
    final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
          <String, dynamic>{'token': token, 'event_id': widget.id},
        ));
    diaryList = jsonDecode(response.body);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findDiaryInPinThisPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: diaryList != null
        ? diaryList.length == 0 ? true : false 
        : false,
        backgroundColor: Color(0xffeff2f5),
        appBar: AppBar(
          elevation: 0.0,
          title: const Text('Diary in Event',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: diaryList != null
            ? diaryList.length != 0 
              ? SingleChildScrollView(
                child: Column(
                  children: diaryList.map<Widget>((e) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.all(Radius.circular(5))),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://storage.googleapis.com/noseason/${e['user_detail'][0]['profile_image']}'),
                          ),
                          title: e['topic'] != null
                              ? Text(e['topic'])
                              : Text('${e['mood_emoji']} ${e['mood_detail']}'),
                          subtitle: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  '@${e['user_detail'][0]['username']}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              e['activity'] != null
                                  ? Flexible(
                                      child: Text(' - ${e['activity']}'),
                                    )
                                  : Container()
                            ],
                          ),
                          trailing: Text(
                            e['date'].toString().substring(0, 10),
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () async {
                            if (e['status'] == 'Follower') {
                              var check =
                                  await findFollow(e['user_detail'][0]['_id']);
                              if (check['message'] == 'true') {
                                Navigator.push(
                                        context,
                                        PageTransition(
                                            child: DiaryDetailPutdown(id: e['_id']),
                                            type: PageTransitionType.rightToLeft))
                                    .then((_) {
                                  setState(() {});
                                });
                              } else if (check['message'] == 'false') {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: VisitorProfile(
                                          user_id: e['user_id'],
                                        ),
                                        type: PageTransitionType.rightToLeft));
                              } else {}
                            } else {
                              Navigator.push(
                                      context,
                                      PageTransition(
                                          child: DiaryDetailPutdown(id: e['_id']),
                                          type: PageTransitionType.rightToLeft))
                                  .then((_) {
                                setState(() {});
                              });
                            }
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )
              : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  
                  children: [
                    const SizedBox(height: 20),
                    Icon(
                      MdiIcons.bookMarker,
                      size: 100,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Don\'t have putdown diary \nin this event',
                      style:
                          TextStyle(fontSize: 20, color: Colors.grey),
                      textAlign: TextAlign.center,
                    )
                  ],
                )
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
