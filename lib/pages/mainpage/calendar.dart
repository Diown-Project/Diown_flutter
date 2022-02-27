import 'dart:convert';

import 'package:diown/pages/diary/choosediary.dart';
import 'package:diown/pages/diary/diarydetail.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);
  static String id = 'CalendarPage';
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime? selectedDay2;
  DateTime? focusDay2;
  dynamic diary;
  dynamic diary2;
  var dateCheck;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  waitForFind() async {
    diary = await findAllYourDiary1();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    waitForFind();
    _selectedDay = _focusedDay;
    // _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        diary2 = [];
        selectedDay2 = selectedDay;
        focusDay2 = focusedDay;
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
        for (int i = 0; i < diary.length; i++) {
          if (diary[i]['date'].toString().substring(0, 10) ==
              _selectedDay.toString().substring(0, 10)) {
            // print(diary[i]['date'].toString());
            diary2.add(diary[i]);
          }
        }
      });

      // _selectedEvents.value = _getEventsForDay(selectedDay);
    } else {
      setState(() {
        diary2 = [];
        selectedDay2 = selectedDay;
        focusDay2 = focusedDay;
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
        for (int i = 0; i < diary.length; i++) {
          if (diary[i]['date'].toString().substring(0, 10) ==
              _selectedDay.toString().substring(0, 10)) {
            // print(diary[i]['date'].toString());
            diary2.add(diary[i]);
          }
        }
      });
    }
  }

  onLoading() async {
    await waitForFind();
    _onDaySelected(selectedDay2!, focusDay2!);
    setState(() {});
    _refreshController.loadComplete();
  }

  void onRefresh() async {
    // monitor network fetch
    await waitForFind();
    _onDaySelected(selectedDay2!, focusDay2!);
    setState(() {});
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      // _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      // _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      // _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: onRefresh,
      onLoading: onLoading,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Calendar',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
            body: diary != null
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(8, 0, 8, 5),
                          width: double.infinity,
                          decoration:  BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(colors: [Color(0xff8b82ff), Color(0xff8a7efd)]),
                            // boxShadow: <BoxShadow>[
                            //   BoxShadow(
                            //     color: Colors.black12,
                            //     blurRadius: 5,
                            //     offset: new Offset(0.0, 5)
                            //   )
                            // ]
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: TableCalendar(
                              calendarStyle: const CalendarStyle(
                                // Use `CalendarStyle` to customize the UI
                                outsideDaysVisible: false,
                                defaultTextStyle: TextStyle(color: Colors.white),
                                weekendTextStyle: TextStyle(color: Colors.white),
                                selectedDecoration: BoxDecoration(
                                  color: Color(0xff6559ff),
                                  shape: BoxShape.circle
                                ),
                                todayDecoration: BoxDecoration(
                                  color: Colors.white60,
                                  shape: BoxShape.circle
                                ),
                                markerDecoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle                               
                                ),
                                markerSize: 6,                  
                                selectedTextStyle: TextStyle(color: Colors.white),
                                todayTextStyle: TextStyle(color: Color(0xff6559ff)),                          
                              ),
                              headerStyle: const HeaderStyle(
                                leftChevronIcon: Icon(Icons.arrow_back_ios, size: 17, color: Colors.white),
                                rightChevronIcon: Icon(Icons.arrow_forward_ios, size: 17, color: Colors.white),
                                titleTextStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white
                                ),
                                titleCentered: true,
                                formatButtonVisible: false
                              ),
                              daysOfWeekStyle: const DaysOfWeekStyle(
                                weekdayStyle: TextStyle(color: Colors.white38),
                                weekendStyle: TextStyle(color: Colors.white38)
                              ),
                              onDaySelected: _onDaySelected,                            
                              firstDay: DateTime.utc(2010, 10, 16),
                              lastDay: DateTime.utc(2030, 3, 14),
                              focusedDay: _focusedDay,
                              selectedDayPredicate: (day) =>
                                  isSameDay(_selectedDay, day),
                              eventLoader: (date) {
                                var result = [];
                                dateCheck = date;
                                for (int i = 0; i < diary.length; i++) {
                                  var c = diary[i]['date'];
                                  if (c.toString().substring(0, 10) ==
                                      date.toString().substring(0, 10)) {
                                    result.add(c);
                                  }
                                }
                                return result;
                              },
                              // onPageChanged: (focusedDay) {
                              //   _focusedDay = focusedDay;
                              // },
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        diary2 != null
                            ? Column(
                                children: [
                                  diary2.length == 0
                                  ? Column(
                                    children: [
                                      const SizedBox(height: 20),
                                      Icon(
                                        MdiIcons.book,
                                        size: 100,
                                        color: Colors.grey[300],
                                      ),
                                      const SizedBox(height: 20),
                                      const Text(
                                        'No diary on this date',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey
                                        ),
                                      )
                                    ],
                                  )
                                  : Container(),
                                  for (int i = 0; i < diary2.length; i++)
                                    Container(
                                      margin: EdgeInsets.fromLTRB(8, 0, 8, 10),
                                      child: ListTile(
                                        leading: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${diary2[i]['mood_emoji']}',
                                              style: TextStyle(fontSize: 24),
                                            ),
                                          ],
                                        ),
                                        title: diary2[i]['topic'] == null
                                            ? Text(
                                                '${diary2[i]['mood_detail']}',
                                                style: TextStyle(fontSize: 16))
                                            : RichText(
                                                overflow: TextOverflow.ellipsis,
                                                text: TextSpan(
                                                    text:
                                                        '${diary2[i]['topic']}',
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16)),
                                              ),
                                        subtitle: diary2[i]['activity'] == null
                                            ? null
                                            : Text('${diary2[i]['activity']}'),
                                        // trailing: Text(
                                        //     '${diary2[i]['date'].toString().substring(0, 10)}'),
                                        tileColor: Color(0xfff1f3f4),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        onTap: () async {
                                          Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      child: DiaryDetail(
                                                          id: diary2[i]['_id']),
                                                      type: PageTransitionType
                                                          .rightToLeft))
                                              .then((_) async {
                                            await waitForFind();
                                            _onDaySelected(
                                                selectedDay2!, focusDay2!);
                                            setState(() {});
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 25)
                                ],
                              )
                            : Container()
                      ],
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  )),
      ),
    );
  }
}

//Scaffold(
// body: Column(
//   children: [
//     TableCalendar(
//       firstDay: DateTime.utc(2010, 10, 16),
//       lastDay: DateTime.utc(2030, 3, 14),
//       focusedDay: _focusedDay,
//       onPageChanged: (focusedDay) {
//         _focusedDay = focusedDay;
//       },
//     ),
// Center(
//   child: ElevatedButton(
//       onPressed: () {
//         Navigator.push(
//             context,
//             PageTransition(
//                 child: const ChooseDiary(),
//                 type: PageTransitionType.rightToLeft));
//       },
//       child: Text('diary')),
// ),
//],
//),
findAllYourDiary1() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'http://10.0.2.2:3000/localDiary/findAllDiary';
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
