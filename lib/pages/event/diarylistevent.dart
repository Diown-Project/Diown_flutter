import 'dart:convert';
import 'package:diown/pages/mainpage/map.dart';
import 'package:diown/pages/putdowndiary/diarydetailputdown.dart';
import 'package:diown/pages/screens/visitorprofile.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
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
    var url = 'http://10.0.2.2:3000/putdown/findListDiaryInEvent';
    final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
          <String, dynamic>{'token': token, 'event_id': widget.id},
        ));
    diaryList = jsonDecode(response.body);
    setState(() {});
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
        appBar: AppBar(
          elevation: 0.0,
          title: const Text('Diary in event.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () => Navigator.of(context).pop()),
        ),
        body: diaryList != null
            ? SingleChildScrollView(
                child: Column(
                  children: diaryList.map<Widget>((e) {
                    return ListTile(
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
                    );
                  }).toList(),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
