import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 15,
        right: 25,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        
        Padding(
          padding: const EdgeInsets.only(
            top: 10
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome home', 
              style: TextStyle(
                  fontFamily: 'readex',
                  fontWeight: FontWeight.bold,
                  // fontSize: 18,
                  color: Color.fromARGB(255, 88, 88, 88))),
              SizedBox(height: 5,),
              Text('Diown', 
              style: TextStyle(
                  fontFamily: 'readex',
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Color.fromARGB(255, 148, 22, 173))),
            ],
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 10.0
              ),
              child: Row(
                children: [
                  ClipOval(
                    child: Image.asset('images/non.jpg', width: 60),
                  ),
                ],
              ),
            ),
          ],
        )
      ]),
    );
  }
}