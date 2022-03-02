import 'package:diown/pages/mainpage/homeDetail/DataTest.dart';
import 'package:flutter/material.dart';

class ListEvent extends StatelessWidget {
  final DataTest dataTest;
  ListEvent(this.dataTest);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            height: 150,
            width: 250,
            decoration: BoxDecoration(
                // color: index.isEven
                //     ? Color.fromARGB(255, 177, 226, 255)
                //     : Color.fromARGB(255, 242, 196, 253),
                color: Color.fromARGB(255, 227, 242, 255),
                borderRadius: BorderRadius.circular(20)),
            child: Column(children: [
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          dataTest.eventImg,
                          fit: BoxFit.cover,
                        )),
                    // fit: BoxFit.cover)),
                  )),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              dataTest.date,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 166, 97, 179),
                                  fontSize: 16,
                                  fontFamily: 'readex'),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              dataTest.eventName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 41, 41, 41),
                                  fontSize: 18,
                                  fontFamily: 'readex'),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                color: Color.fromARGB(255, 148, 148, 148),
                                size: 15),
                            SizedBox(width: 5),
                            Text(
                              dataTest.location,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 148, 148, 148),
                                  fontSize: 12,
                                  fontFamily: 'readex'),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              width: 5,
                              height: 5,
                            ),
                            SizedBox(width: 10),
                            Text(
                              dataTest.putDown,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 148, 148, 148),
                                  fontSize: 12,
                                  fontFamily: 'readex'),
                            )
                          ],
                        )
                      ]),
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}
