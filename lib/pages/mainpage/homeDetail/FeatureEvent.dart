import 'package:diown/pages/mainpage/homeDetail/DataTest.dart';
import 'package:diown/pages/mainpage/homeDetail/ListEvent.dart';
import 'package:diown/pages/mainpage/homeDetail/TitleEvent.dart';
import 'package:flutter/material.dart';

class FeatureEvent extends StatelessWidget {
  final data_testList = DataTest.generateCourses();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TitleEvent('Event', '+more'),
          Container(
            height: 300,
            child: ListView.separated(
              padding: EdgeInsets.all(15),
              scrollDirection: Axis.horizontal,
              itemCount: data_testList.length,
              itemBuilder: (context, index) =>
              ListEvent(data_testList[index]), 
              separatorBuilder: 
              (context, int index) => SizedBox(width: 15,),),
          )
      ]),
    );
  }
}