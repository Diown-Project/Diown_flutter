import 'package:flutter/material.dart';

class FollowRequest_Page extends StatelessWidget {
  const FollowRequest_Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Follow request'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 243, 243, 243),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipOval(
                        child: Image.asset('images/non.jpg', width: 45),
                      ),
                      const SizedBox(width: 15),
                      Flexible(
                          child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Donut Natcha',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Sent request 5 min',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 122, 122, 122)),
                            ),
                          ],
                        ),
                      )),
                      Padding(
                        padding: const EdgeInsets.only(top: 6, left: 20),
                        child: Container(
                          width: 70,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            color: Color.fromARGB(255, 149, 83, 255),
                            border: Border.all(
                              color: Color.fromARGB(255, 149, 83, 255),
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(2, 0, 5, 0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Accept',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color.fromARGB(255, 255, 255, 255)),
                                  ),
                                ]),
                          ),
                        ),
                      ), 
                      const SizedBox(width: 5),  
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Container(
                            width: 70,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              color: Color.fromARGB(255, 255, 255, 255),
                              border: Border.all(
                                color: Color.fromARGB(255, 0, 0, 0),
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Delete',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                    ),
                                  ]),
                            ),
                          ),
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
