import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BarChartOne extends StatefulWidget {
  // final List<MoodChart> list;
  // const BarChartOne(this.list, {Key? key}) : super(key:key);

  @override
  State<StatefulWidget> createState() => BarChartOneState();
}

class BarChartOneState extends State<BarChartOne> {
  final List<double> weeklyData = [5.0, 6.5, 5.0, 7.5, 9.0, 11.5, 6.5];
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 290,
        constraints: BoxConstraints.tightFor(height: 290),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.0),
          color: const Color(0xffC7B7FF),
        ),
        margin: const EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 20.0),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Mood',
              style: TextStyle(
                  color: Color(0xff3f3a83),
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 4,
            ),
            const Text(
              'weekly status',
              style: TextStyle(
                  color: Color(0xff5a519e),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 25,
            ),
            Expanded(
              child: BarChart(BarChartData(
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Color(0xff5a519e),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String? weekDay;
                      switch (group.x.toInt()) {
                        case 0:
                          weekDay = 'Monday';
                          break;
                        case 1:
                          weekDay = 'Tuesday';
                          break;
                        case 2:
                          weekDay = 'Wednesday';
                          break;
                        case 3:
                          weekDay = 'Thursday';
                          break;
                        case 4:
                          weekDay = 'Friday';
                          break;
                        case 5:
                          weekDay = 'Saturday';
                          break;
                        case 6:
                          weekDay = 'Sunday';
                          break;
                      }
                      return BarTooltipItem(
                        weekDay! + '\n' + (rod.y).toString(),
                        TextStyle(color: Color(0xffFFC600)),
                      );
                    },
                  ),
                  touchCallback: (FlTouchEvent event, barTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          barTouchResponse == null ||
                          barTouchResponse.spot == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          barTouchResponse.spot!.touchedBarGroupIndex;
                    });
                  },
                ),
                titlesData: FlTitlesData(
                    // Build X axis.
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (context, value) => const TextStyle(
                        fontSize: 25,
                      ),
                      margin: 16,
                      getTitles: (double value) {
                        switch (value.toInt()) {
                          case 0:
                            return '😀';
                          case 1:
                            return '😀';
                          case 2:
                            return '😀';
                          case 3:
                            return '😀';
                          case 4:
                            return '😀';
                          case 5:
                            return '😀';
                          case 6:
                            return '😀';
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
                  weeklyData.length,
                  (index) => _buildBar(index, weeklyData[index],
                      isTouched: index == touchedIndex),
                ),
              )),
            )
          ],
        ),
      ),
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
