import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:diown/pages/event/EventPage.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;

class CarouselLoading extends StatefulWidget {
  const CarouselLoading({Key? key}) : super(key: key);

  @override
  _CarouselLoadingState createState() => _CarouselLoadingState();
}

class _CarouselLoadingState extends State<CarouselLoading> {
  var _event;
  int activeIndex = 0;

  findevent() async {
    _event = await findEventOnTime();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    findevent();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _event != null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Event',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: EventPage(),
                          ),
                        );
                      },
                      child: Container(
                        width: 80,
                        height: 30,
                        decoration: const BoxDecoration(
                            color: Color(0xff8b82ff),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text(
                                  'More',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                const Icon(
                                  MdiIcons.chevronRight,
                                  color: Colors.white,
                                )
                              ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _event != null
                  ? _event.length != 0
                      ? CarouselSlider.builder(
                          itemCount: _event.length,
                          options: CarouselOptions(
                              viewportFraction: 1,
                              height: 255,
                              enableInfiniteScroll: false,
                              onPageChanged: (index, reason) =>
                                  setState(() => activeIndex = index)),
                          itemBuilder: (context, index, realIndex) {
                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          scrollable: true,
                                          title: Center(
                                            child: Text(_event[index]['topic']),
                                          ),
                                          content: Column(
                                            children: [
                                              Image.network(
                                                  'https://storage.googleapis.com/noseason/${_event[index]['imageLocation']}'),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                DateFormat('EEE. MMM d / yyyy')
                                                        .format(DateTime.parse(
                                                            _event[index][
                                                                'start_date'])) +
                                                    ' - ' +
                                                    DateFormat(
                                                            'EEE. MMM d / yyyy')
                                                        .format(DateTime.parse(
                                                            _event[index]
                                                                ['end_date'])),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    MdiIcons.mapMarker,
                                                    color: Colors.black54,
                                                  ),
                                                  Text(
                                                    _event[index]['marker_id'],
                                                    style: TextStyle(
                                                        color: Colors.black54),
                                                  )
                                                ],
                                              ),
                                              Text(
                                                _event[index]['detail'],
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          minimumSize:
                                                              Size(280, 30)),
                                                  child: Text('ok'))
                                            ],
                                          ),
                                        ));
                              },
                              child: Container(
                                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  decoration: const BoxDecoration(
                                      color: Color(0xfff1f3f4),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15)),
                                          child: Image.network(
                                            'https://storage.googleapis.com/noseason/${_event[index]['imageLocation']}',
                                            fit: BoxFit.cover,
                                            height: 150,
                                            width: double.infinity,
                                          )),
                                      const SizedBox(height: 6),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              DateFormat('EEE. MMM d / yyyy')
                                                      .format(DateTime.parse(
                                                          _event[index]
                                                              ['start_date'])) +
                                                  ' - ' +
                                                  DateFormat(
                                                          'EEE. MMM d / yyyy')
                                                      .format(DateTime.parse(
                                                          _event[index]
                                                              ['end_date'])),
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              _event[index]['topic'],
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      MdiIcons.mapMarker,
                                                      color: Colors.black54,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      _event[index]
                                                          ['marker_id'],
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black54),
                                                    )
                                                  ],
                                                ),
                                                // Flexible(
                                                //   child: TextButton(
                                                //     child: Text(
                                                //       'Details',
                                                //       style: TextStyle(
                                                //           color: Colors.greenAccent,
                                                //           fontWeight: FontWeight.bold),
                                                //     ),
                                                //     onPressed: () {
                                                //       showDialog(
                                                //           context: context,
                                                //           builder: (context) => AlertDialog(
                                                //                 scrollable: true,
                                                //                 title: Center(
                                                //                   child: Text(
                                                //                       _event[index]['topic']),
                                                //                 ),
                                                //                 content: Column(
                                                //                   children: [
                                                //                     Image.network(
                                                //                         'https://storage.googleapis.com/noseason/${_event[index]['imageLocation']}'),
                                                //                     SizedBox(
                                                //                       height: 5,
                                                //                     ),
                                                //                     Text(
                                                //                       DateFormat('EEE. MMM d / yyyy')
                                                //                               .format(DateTime
                                                //                                   .parse(_event[
                                                //                                           index]
                                                //                                       [
                                                //                                       'start_date'])) +
                                                //                           ' - ' +
                                                //                           DateFormat(
                                                //                                   'EEE. MMM d / yyyy')
                                                //                               .format(DateTime
                                                //                                   .parse(_event[
                                                //                                           index]
                                                //                                       [
                                                //                                       'end_date'])),
                                                //                       style: TextStyle(
                                                //                         fontSize: 14,
                                                //                       ),
                                                //                     ),
                                                //                     Row(
                                                //                       children: [
                                                //                         Icon(
                                                //                           MdiIcons.mapMarker,
                                                //                           color: Colors.black54,
                                                //                         ),
                                                //                         Text(
                                                //                           _event[index]
                                                //                               ['marker_id'],
                                                //                           style: TextStyle(
                                                //                               color: Colors
                                                //                                   .black54),
                                                //                         )
                                                //                       ],
                                                //                     ),
                                                //                     Text(
                                                //                       _event[index]['detail'],
                                                //                       style: TextStyle(
                                                //                           fontSize: 15),
                                                //                     ),
                                                //                     ElevatedButton(
                                                //                         onPressed: () {
                                                //                           Navigator.pop(
                                                //                               context);
                                                //                         },
                                                //                         style: ElevatedButton
                                                //                             .styleFrom(
                                                //                                 minimumSize:
                                                //                                     Size(280,
                                                //                                         30)),
                                                //                         child: Text('ok'))
                                                //                   ],
                                                //                 ),
                                                //               ));
                                                //     },
                                                //   ),
                                                // )
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )),
                            );
                          },
                        )
                      : Container()
                  : Container(),
              const SizedBox(height: 10),
              _event.length > 1 ? buildIndicator() : Container(),
            ],
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: _event.length,
        effect: const SlideEffect(
            dotWidth: 10,
            dotHeight: 10,
            activeDotColor: Colors.black54,
            dotColor: Colors.black12),
      );
}

findEventOnTime() async {
  var url = 'http://10.0.2.2:3000/putdown/findEventOnTime';
  final http.Response response = await http.get(
    Uri.parse(url),
  );
  var result = jsonDecode(response.body);
  return result;
}
