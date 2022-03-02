import 'package:diown/pages/mainpage/home.dart';
import 'package:diown/pages/mainpage/homeDetail/DataTest.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class EventPage extends StatelessWidget {


// final DataTest;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('Event',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 24)),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(
                  context, 
                  PageTransition(
                    type: PageTransitionType.leftToRight,
                    child: Home(),
                  ),
                );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Container(
              child: Card(
                elevation: 0.0,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                color: Colors.blue[50],
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                    ),
                    Row(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset("images/non.jpg", width: 130,
                            )),
                        SizedBox(width: 10),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("date", //วันที่
                                  style: TextStyle(
                                    color: Color.fromRGBO(148, 92, 254, 1),
                                    fontSize: 13,
                                  )),
                              const SizedBox(height: 10),
                              RichText(
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  text: "eventName",
                                  style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text("putDown", //จำนวนคน putdow
                                  style: TextStyle(
                                    color: Color.fromRGBO(165, 167, 181, 1),
                                    fontSize: 13,
                                  )),
                              const SizedBox(height: 10),
                              Container(
                                child: Row(
                                  children: [
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Icon(Icons.location_on)),
                                    Container(
                                        margin: const EdgeInsets.only(
                                            left: 8, top: 5),
                                        child: Text(
                                          "location", //สถานที่
                                          style: TextStyle(fontSize: 13),
                                        ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
