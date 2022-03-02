import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class TitlePut extends StatelessWidget {
  final String leftText;
  final String rightText;
  TitlePut(
    this.leftText,
    this.rightText,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Following put down",
            style: TextStyle(
                fontFamily: 'readex',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color.fromARGB(255, 56, 56, 56)),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                  height: 27,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Color.fromARGB(255, 243, 155, 255),
                  onPressed: () {},
                  // {Navigator.push(
                  //   context,
                  //   PageTransition(
                  //     type: PageTransitionType.leftToRight,
                  //     child: EventPage(),
                  //   ),
                  // );},
                  child: Text(
                    "+ More",
                    style: TextStyle(color: Color.fromARGB(255, 36, 36, 36)),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
