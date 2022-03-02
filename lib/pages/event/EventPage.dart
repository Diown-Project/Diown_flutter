import 'package:diown/pages/mainpage/home.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';

class EventPage extends StatefulWidget {


  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final event = [
    'images/event_cut.png',
    'images/event_cut.png',
    'images/event_cut.png',
    'images/event_cut.png',
    'images/event_cut.png'
  ];
// final DataTest;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('Event',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop()
        ),
      ),
      body: ListView.builder(
          itemCount: event.length,
          itemBuilder: ( context, index ) {
            return Container(
              margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
              decoration: const BoxDecoration(
                color: Color(0xfff1f3f4),
                borderRadius: BorderRadius.all(Radius.circular(15))
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        event[index],
                        fit: BoxFit.cover,
                        height: 120,
                        width: 120,
                      )
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'San, Dec 25',
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Christmas & thanksgiving event',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5), 
                        Text(
                          '200+ putdown',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              MdiIcons.mapMarker,
                              color: Colors.black54,
                              size: 18,
                            ),
                            const Text(
                              'central world',
                              style: TextStyle(
                                color: Colors.black54
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              )
            );
          }
        ),
      );
  }
}
