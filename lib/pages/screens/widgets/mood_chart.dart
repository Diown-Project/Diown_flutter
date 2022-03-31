import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BarChartOne extends StatefulWidget {
  // final List<MoodChart> list;
  // const BarChartOne(this.list, {Key? key}) : super(key:key);

  @override
  State<StatefulWidget> createState() => BarChartOneState();
}

class BarChartOneState extends State<BarChartOne> {
  dynamic moodCount;
  dynamic moodKey;
  dynamic textChart = '7';
  getMood(value) async {
    moodCount = await findEmoji(value);
    setState(() {
      moodKey = moodCount.keys.toList();
      for (var i = 0; i < moodKey.length; i++) {
        moodCount[moodKey[i]] = moodCount[moodKey[i]].toDouble();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMood(7);
  }

  int touchedIndex = -1;
  String? choose;
  String? dropdownvalue = "7";
  var textChartList = {
    '7': 'weekly mood status',
    '30': '30 days mood status',
    '60': '60 days mood status',
    '90': '90 days mood status',
    '180': '180 days mood status',
    '365': '1 year mood status'
  };
  var dropDownList = {
    '7': '7 days',
    '30': '1 month',
    '60': '2 months',
    '90': '3 months',
    '180': '6 months',
    '365': '1 year'
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: moodCount != null
              ? Column(
                  children: [
                    Container(
                      height: 290,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.0),
                        color: const Color(0xff8a7efd),
                      ),
                      margin: const EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 20.0),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Mood',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                // width: 110,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    focusColor: Colors.black,
                                    isDense: true,
                                    // isExpanded: true,
                                    value: dropdownvalue,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Color(0xff6559ff),
                                    ),
                                    iconSize: 28,
                                    // elevation: 100,
                                    onChanged: (String? newval) {
                                      setState(() {
                                        dropdownvalue = newval;
                                      });
                                    },
                                    items: <String>[
                                      '7',
                                      '30',
                                      '60',
                                      '90',
                                      '180',
                                      '365'
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        onTap: () {
                                          var c = int.parse(value);
                                          textChart = value;
                                          getMood(value);
                                          setState(() {});
                                        },
                                        child: Text(
                                          '${dropDownList[value]}',
                                          style: TextStyle(
                                              color: Color(0xff6559ff)),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            '${textChartList[textChart]}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w100),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Expanded(
                            child: BarChart(BarChartData(
                              barTouchData: BarTouchData(
                                touchTooltipData: BarTouchTooltipData(
                                  tooltipBgColor: Color(0xff5a519e),
                                  getTooltipItem:
                                      (group, groupIndex, rod, rodIndex) {
                                    String? moodDetail;
                                    String? moodCountnum;
                                    switch (group.x.toInt()) {
                                      case 0:
                                        moodDetail =
                                            moodKey[0].toString().substring(3);
                                        moodCountnum =
                                            moodCount[moodKey[0].toString()]
                                                .toString();
                                        break;
                                      case 1:
                                        moodDetail =
                                            moodKey[1].toString().substring(3);
                                        moodCountnum =
                                            moodCount[moodKey[1].toString()]
                                                .toString();
                                        break;
                                      case 2:
                                        moodDetail =
                                            moodKey[2].toString().substring(3);
                                        moodCountnum =
                                            moodCount[moodKey[2].toString()]
                                                .toString();
                                        break;
                                      case 3:
                                        moodDetail =
                                            moodKey[3].toString().substring(3);
                                        moodCountnum =
                                            moodCount[moodKey[3].toString()]
                                                .toString();
                                        break;
                                      case 4:
                                        moodDetail =
                                            moodKey[4].toString().substring(3);
                                        moodCountnum =
                                            moodCount[moodKey[4].toString()]
                                                .toString();
                                        break;
                                      case 5:
                                        moodDetail =
                                            moodKey[5].toString().substring(3);
                                        moodCountnum =
                                            moodCount[moodKey[5].toString()]
                                                .toString();
                                        break;
                                      case 6:
                                        moodDetail =
                                            moodKey[6].toString().substring(3);
                                        moodCountnum =
                                            moodCount[moodKey[6].toString()]
                                                .toString();
                                        break;
                                    }
                                    return BarTooltipItem(
                                      moodDetail! + '\n' + moodCountnum!,
                                      TextStyle(color: Color(0xffFFC600)),
                                    );
                                  },
                                ),
                                touchCallback:
                                    (FlTouchEvent event, barTouchResponse) {
                                  setState(() {
                                    if (!event.isInterestedForInteractions ||
                                        barTouchResponse == null ||
                                        barTouchResponse.spot == null) {
                                      touchedIndex = -1;
                                      return;
                                    }
                                    touchedIndex = barTouchResponse
                                        .spot!.touchedBarGroupIndex;
                                  });
                                },
                              ),
                              titlesData: FlTitlesData(
                                  // Build X axis.
                                  bottomTitles: SideTitles(
                                    showTitles: true,
                                    getTextStyles: (context, value) =>
                                        const TextStyle(
                                      fontSize: 25,
                                    ),
                                    margin: 16,
                                    getTitles: (double value) {
                                      switch (value.toInt()) {
                                        case 0:
                                          return moodKey[0]
                                              .toString()
                                              .substring(0, 3);
                                        case 1:
                                          return moodKey[1]
                                              .toString()
                                              .substring(0, 3);
                                        case 2:
                                          return moodKey[2]
                                              .toString()
                                              .substring(0, 3);
                                        case 3:
                                          return moodKey[3]
                                              .toString()
                                              .substring(0, 3);
                                        case 4:
                                          return moodKey[4]
                                              .toString()
                                              .substring(0, 3);
                                        case 5:
                                          return moodKey[5]
                                              .toString()
                                              .substring(0, 3);
                                        case 6:
                                          return moodKey[6]
                                              .toString()
                                              .substring(0, 3);
                                        default:
                                          return '';
                                      }
                                    },
                                  ),
                                  // Build Y axis.
                                  leftTitles: SideTitles(
                                    showTitles: false,
                                    getTitles: (double value) {
                                      return value.toString();
                                    },
                                  ),
                                  rightTitles: SideTitles(showTitles: false),
                                  topTitles: SideTitles(showTitles: false)),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              gridData: FlGridData(
                                show: false,
                              ),
                              barGroups: List.generate(
                                moodCount.length,
                                (index) => _buildBar(
                                    index, moodCount[moodKey[index]],
                                    isTouched: index == touchedIndex),
                              ),
                            )),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }

  BarChartGroupData _buildBar(
    int x,
    double y, {
    bool isTouched = false,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: isTouched ? [Color(0xffFFC600)] : [Color(0xfff4edff)],
          width: 20,
          borderSide: isTouched
              ? BorderSide(color: Color(0xffFFC600), width: 1)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 15,
            colors: [const Color(0xffab9cf1)],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }
}

findEmoji(period) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'http://10.0.2.2:3000/mood_router/findAll';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{'token': token, 'period': period},
      ));
  var result = jsonDecode(response.body);
  return result;
}
