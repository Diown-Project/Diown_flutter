import 'package:flutter/material.dart';

class ChoiceImage extends StatefulWidget {
  const ChoiceImage({Key? key}) : super(key: key);

  @override
  _ChoiceImageState createState() => _ChoiceImageState();
}

class _ChoiceImageState extends State<ChoiceImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choice to Select Images.'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
    );
  }
}
