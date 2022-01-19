import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class PrivacypolicyWidget extends StatelessWidget {
  const PrivacypolicyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Privacy policy'),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: const Text(
                'Privacy policy of Diown',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Please take a moment to familiarize yourself with our Privacy policy and let us know if you have any questions',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.topLeft,
              child: const Text(
                'Introduction',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'This Privacy policy ("Privacy Policy") describes the privacy practices that we, DIOWN with Lock, employ with regard to collecting, using and disclosing information, both personal and non-personal information, which we receive when you use our Services. By using the Services you consent to the practices described in this Privacy Policy. IF YOU DO NOT AGREE WITH THE PRACTICES EXPLAINED IN THIS PRIVACY POLICY, DO NOT ACCESS, BROWSE OR USE THE MY DIARY SERVICES.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'We are committed to safeguarding any information collected through the Services. This Privacy policy is intended to inform you of our policies and procedures regarding the collection, use and disclosure of information on our Services. We also want to inform you about your choices regarding information you share with us. If you have any questions or concerns, please let us know.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'As used in this Privacy Policy, the terms using and processing information include using cookies on a computer or mobile device, subjecting the information to statistical or other analysis and using or handling information in any way, including, but not limited to collecting, storing, evaluating, modifying, deleting, using, combining, disclosing and  transferring information within our organization or among our affiliates within the United States or internationally.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(
              height: 25,
            ),
            const Image(
              image: AssetImage('images/diownlogo.png'),
              width: 150,
            )
          ],
        ),
      )),
    );
  }
}
