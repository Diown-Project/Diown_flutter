import 'package:flutter/material.dart';

class FollowPage extends StatelessWidget {
  const FollowPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text('My Follower'),
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
                        child: Image.asset('images/non.jpg', width: 55),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                          child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'thin_non',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '200 following 350 follower',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 122, 122, 122)),
                            ),
                          ],
                        ),
                      )),
                      Padding(
                        padding: const EdgeInsets.only(top: 12, left: 20),
                        child: Container(
                          width: 80,
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
                              color: Color.fromRGBO(0, 0, 0, 1),
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
                                        color: Color.fromARGB(255, 32, 32, 32)),
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
