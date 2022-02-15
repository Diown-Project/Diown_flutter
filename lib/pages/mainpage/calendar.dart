import 'dart:convert';

import 'package:diown/pages/diary/choosediary.dart';
import 'package:diown/pages/diary/diarydetail.dart';
import 'package:flutter/material.dart';
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
        padding: const EdgeInsets.all(8.0),
        child: Scaffold(
            body: diary != null
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        TableCalendar(
                          firstDay: DateTime.utc(2010, 10, 16),
                          lastDay: DateTime.utc(2030, 3, 14),
                          focusedDay: _focusedDay,
                          selectedDayPredicate: (day) =>
                              isSameDay(_selectedDay, day),
                          rangeStartDay: _rangeStart,
                          rangeEndDay: _rangeEnd,
                          calendarFormat: _calendarFormat,
                          rangeSelectionMode: _rangeSelectionMode,
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
                          calendarStyle: const CalendarStyle(
                            // Use `CalendarStyle` to customize the UI
                            outsideDaysVisible: false,
                          ),
                          onDaySelected: _onDaySelected,
                          onRangeSelected: _onRangeSelected,
                          onFormatChanged: (format) {
                            if (_calendarFormat != format) {
                              setState(() {
                                _calendarFormat = format;
                              });
                            }
                          },
                          onPageChanged: (focusedDay) {
                            _focusedDay = focusedDay;
                          },
                        ),
                        const SizedBox(height: 8.0),
                        diary2 != null
                            ? Column(
                                children: [
                                  for (int i = 0; i < diary2.length; i++)
                                    Container(
                                      margin: EdgeInsets.only(bottom: 8),
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
                                        trailing: Text(
                                            '${diary2[i]['date'].toString().substring(0, 10)}'),
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
