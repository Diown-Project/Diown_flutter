import 'dart:convert';
import 'package:diown/pages/event/diarylistevent.dart';
import 'package:http/http.dart' as http;
import 'package:diown/pages/mainpage/home.dart';
import 'package:flutter/material.dart';
import 'package:ink_widget/ink_widget.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';

class EventPage extends StatefulWidget {
  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  var dropdownInit = 'ongoing';
  var eventList;

  findEventToVar(string) async {
    eventList = await findEvent(string);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findEventToVar(dropdownInit);
  }

// final DataTest;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            title: const Text('Event',
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                      value: dropdownInit,
                      onChanged: (String? newval) {
                        setState(() {
                          dropdownInit = newval!;
                        });
                      },
                      items: <String>[
                        'ongoing',
                        'complete',
                        'upcoming',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          onTap: () {
                            findEventToVar(value);
                          },
                          child: Text(
                            value,
                            style: TextStyle(color: Color(0xff6559ff)),
                          ),
                        );
                      }).toList(),
                    )),
                  ),
                ),
                Column(
                  children: eventList != null
                      ? dropdownInit == "upcoming"
                          ? eventList.map<Widget>((e) {
                              return InkWidget(
                                onTap: () {},
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                                  decoration: const BoxDecoration(
                                      color: Color(0xfff1f3f4),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.network(
                                              'https://storage.googleapis.com/noseason/${e['imageLocation']}',
                                              fit: BoxFit.cover,
                                              height: 120,
                                              width: 120,
                                            )),
                                      ),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              DateFormat('MMM d / yyyy').format(
                                                      DateTime.parse(
                                                          e['start_date'])) +
                                                  ' - ' +
                                                  DateFormat('MMM d / yyyy')
                                                      .format(DateTime.parse(
                                                          e['end_date'])),
                                              style: TextStyle(
                                                fontSize: 13,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              e['topic'],
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                Icon(
                                                  MdiIcons.mapMarker,
                                                  color: Colors.black54,
                                                  size: 18,
                                                ),
                                                Text(
                                                  e['marker_id'],
                                                  style: TextStyle(
                                                      color: Colors.black54),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }).toList()
                          : eventList.map<Widget>((e) {
                              return InkWidget(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: DiaryListInEvent(
                                            id: e['_id'],
                                          ),
                                          type:
                                              PageTransitionType.rightToLeft));
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                                  decoration: const BoxDecoration(
                                      color: Color(0xfff1f3f4),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.network(
                                              'https://storage.googleapis.com/noseason/${e['imageLocation']}',
                                              fit: BoxFit.cover,
                                              height: 120,
                                              width: 120,
                                            )),
                                      ),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              DateFormat('MMM d / yyyy').format(
                                                      DateTime.parse(
                                                          e['start_date'])) +
                                                  ' - ' +
                                                  DateFormat('MMM d / yyyy')
                                                      .format(DateTime.parse(
                                                          e['end_date'])),
                                              style: TextStyle(
                                                fontSize: 13,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              e['topic'],
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                Icon(
                                                  MdiIcons.mapMarker,
                                                  color: Colors.black54,
                                                  size: 18,
                                                ),
                                                Text(
                                                  e['marker_id'],
                                                  style: TextStyle(
                                                      color: Colors.black54),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }).toList()
                      : [
                          Center(
                            child: CircularProgressIndicator(),
                          )
                        ],
                )
              ],
            ),
          )),
    );
  }
}

findEvent(string) async {
  var url = 'http://10.0.2.2:3000/putdown/findEventFromDropdown';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{'string': string},
      ));
  var result = jsonDecode(response.body);
  return result;
}
