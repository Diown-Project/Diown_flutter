import 'package:flutter/material.dart';

class OwnerPin extends StatefulWidget {
  const OwnerPin({Key? key}) : super(key: key);

  @override
  State<OwnerPin> createState() => _OwnerPinState();
}

class _OwnerPinState extends State<OwnerPin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your own pin.'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
    );
  }
}
