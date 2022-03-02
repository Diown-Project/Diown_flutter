import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class TitleLast extends StatelessWidget {
  final String leftText;
  TitleLast(this.leftText);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Last Diary", 
              style: TextStyle(
                fontFamily: 'readex',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color.fromARGB(255, 56, 56, 56)),),
            
            
          ],   
               
        ),
      
    );
  }
}