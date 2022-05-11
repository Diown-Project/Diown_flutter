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

import 'diarylistevent.dart';

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
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    findevent();
    if (mounted) {
      setState(() {});
    }
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
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) {
                                    return makeDismissible(
                                      child: DraggableScrollableSheet(
                                        initialChildSize: 1,
                                        builder:(_, controller) => Container(
                                          color: Colors.white,
                                          child: Scaffold(
                                            extendBodyBehindAppBar: true,
                                            backgroundColor: Colors.white,
                                            // appBar: AppBar(
                                            //   backgroundColor:Colors.white,
                                            //   elevation: 0,
                                            //   leading: IconButton(
                                            //     icon: Container(
                                            //       width: 45,
                                            //       height: 45,
                                            //       decoration: const BoxDecoration(
                                            //           color: Color(
                                            //               0xffe5e5e6),
                                            //           shape: BoxShape
                                            //               .circle),
                                            //       child:
                                            //           Center(
                                            //         child: Icon(Icons.arrow_back_ios_new_rounded,
                                            //         color: Colors.black)
                                            //       ),
                                            //     ),
                                            //     onPressed: () => Navigator.of(context).pop(),
                                            //   ),
                                            // ),
                                            body: Column(
                                              children: [
                                                ClipRRect(
                                                child: Image.network(
                                                  'https://storage.googleapis.com/noseason/${_event[index]['imageLocation']}',
                                                  fit: BoxFit.cover,
                                                  height: 300,
                                                  width: double.infinity,
                                                )),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
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
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          _event[index]['topic'],
                                                          style: const TextStyle(
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.bold),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
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
                                                        const SizedBox(height: 10),
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                            context,
                                                            PageTransition(
                                                                child: DiaryListInEvent(
                                                                  id: _event[index]['_id'],
                                                                ),
                                                                type:
                                                                    PageTransitionType.rightToLeft));
                                                          },
                                                          child: Container(
                                                            width: double.infinity,
                                                            height: 40,
                                                            decoration: const BoxDecoration(color: Color(0xff8b82ff), borderRadius: BorderRadius.all(Radius.circular(5))),
                                                            child: const Center(
                                                              child: Text('Diary in event',
                                                                  style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 16,
                                                                  )),
                                                            )),
                                                        ),
                                                        const SizedBox(height: 10),
                                                        const Divider(thickness: 0.8),
                                                        const SizedBox(height: 10),
                                                        const Text(
                                                          'What To Expect',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold),
                                                        ),
                                                        const SizedBox(height: 10),
                                                        Text(
                                                          _event[index]['detail'],
                                                          style: TextStyle(fontSize: 15),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            floatingActionButton: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 70
                                              ),
                                              child: FloatingActionButton(
                                                mini: true,
                                                onPressed: () => Navigator.of(context).pop(),
                                                elevation: 0,
                                                backgroundColor: Colors.black87,
                                                child: const Icon(Icons.arrow_back_ios_new_rounded,
                                                color: Colors.white,
                                                size: 20,
                                                ),
                                              ),
                                            ),
                                            floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
                                          ),
                                        )
                                      ),
                                    );
                                  }
                                );
                                // showDialog(
                                //     context: context,
                                //     builder: (context) => AlertDialog(
                                //           scrollable: true,
                                //           title: Center(
                                //             child: Text(_event[index]['topic']),
                                //           ),
                                //           content: Column(
                                //             children: [
                                //               Image.network(
                                //                   'https://storage.googleapis.com/noseason/${_event[index]['imageLocation']}'),
                                //               SizedBox(
                                //                 height: 5,
                                //               ),
                                //               Text(
                                //                 DateFormat('EEE. MMM d / yyyy')
                                //                         .format(DateTime.parse(
                                //                             _event[index][
                                //                                 'start_date'])) +
                                //                     ' - ' +
                                //                     DateFormat(
                                //                             'EEE. MMM d / yyyy')
                                //                         .format(DateTime.parse(
                                //                             _event[index]
                                //                                 ['end_date'])),
                                //                 style: TextStyle(
                                //                   fontSize: 14,
                                //                 ),
                                //               ),
                                //               Row(
                                //                 children: [
                                //                   Icon(
                                //                     MdiIcons.mapMarker,
                                //                     color: Colors.black54,
                                //                   ),
                                //                   Text(
                                //                     _event[index]['marker_id'],
                                //                     style: TextStyle(
                                //                         color: Colors.black54),
                                //                   )
                                //                 ],
                                //               ),
                                //               Text(
                                //                 _event[index]['detail'],
                                //                 style: TextStyle(fontSize: 15),
                                //               ),
                                //               ElevatedButton(
                                //                   onPressed: () {
                                //                     Navigator.pop(context);
                                //                   },
                                //                   style:
                                //                       ElevatedButton.styleFrom(
                                //                           minimumSize:
                                //                               Size(280, 30)),
                                //                   child: Text('ok'))
                                //             ],
                                //           ),
                                //         ));
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
   Widget makeDismissible({required Widget child}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(
            onTap: FocusScope.of(context).unfocus, child: child),
      );
}

findEventOnTime() async {
  var url = 'https://diown-app-server.herokuapp.com/putdown/findEventOnTime';
  final http.Response response = await http.get(
    Uri.parse(url),
  );
  var result = jsonDecode(response.body);
  return result;
}
